import Foundation
import CommonCrypto

/// Handles background S3 uploads with AWS v4 signature
@available(iOS 13.0, *)
class S3BackgroundUploader: NSObject {
    
    // MARK: - Singleton
    static let shared = S3BackgroundUploader()
    
    // MARK: - Properties
    private var backgroundSession: URLSession!
    private let sessionIdentifier = "com.nirva.s3upload"
    
    // AWS Credentials (stored securely)
    private var credentials: S3Credentials?
    
    // Upload queue management
    private var uploadQueue: [PendingS3Upload] = []
    private let queueFile = "s3_upload_queue.json"
    
    // Tracking
    private var activeUploads: [URLSessionTask: PendingS3Upload] = [:]
    
    // Background completion handler
    var backgroundCompletionHandler: (() -> Void)?
    
    // Callbacks
    var onUploadComplete: ((String, String) -> Void)? // (localPath, s3URL)
    var onUploadFailed: ((String, Error) -> Void)? // (localPath, error)
    var onUploadProgress: ((String, Double) -> Void)? // (localPath, progress)
    
    // MARK: - Initialization
    private override init() {
        super.init()
        setupBackgroundSession()
        loadUploadQueue()
        
        print("S3BackgroundUploader: Initialized")
        DebugLogger.shared.log("S3BackgroundUploader: Initialized with background session")
    }
    
    private func setupBackgroundSession() {
        let config = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        config.isDiscretionary = false
        config.sessionSendsLaunchEvents = true
        config.allowsCellularAccess = true
        config.shouldUseExtendedBackgroundIdleMode = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        
        backgroundSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    // MARK: - Credentials Management
    
    func setCredentials(_ creds: [String: Any]) {
        credentials = S3Credentials(
            accessKeyId: creds["accessKeyId"] as? String ?? "",
            secretAccessKey: creds["secretAccessKey"] as? String ?? "",
            sessionToken: creds["sessionToken"] as? String ?? "",
            bucket: creds["bucket"] as? String ?? "",
            region: creds["region"] as? String ?? "us-east-1",
            prefix: creds["prefix"] as? String ?? ""
        )
        
        print("S3BackgroundUploader: Credentials updated")
        DebugLogger.shared.log("S3BackgroundUploader: Credentials updated for bucket: \(credentials?.bucket ?? "")")
        
        // Process any queued uploads immediately
        processQueuedUploads()
    }
    
    // MARK: - Upload Management
    
    func queueUpload(localPath: String, userId: String, metadata: [String: String] = [:]) {
        guard FileManager.default.fileExists(atPath: localPath) else {
            print("S3BackgroundUploader: File not found: \(localPath)")
            onUploadFailed?(localPath, UploadError.fileNotFound)
            return
        }
        
        let fileName = URL(fileURLWithPath: localPath).lastPathComponent
        // Simplified path: native-audio/{userId}/{filename}
        let s3Key = "native-audio/\(userId)/\(fileName)"
        
        let upload = PendingS3Upload(
            localPath: localPath,
            s3Key: s3Key,
            userId: userId,
            metadata: metadata,
            retryCount: 0,
            createdAt: Date()
        )
        
        uploadQueue.append(upload)
        saveUploadQueue()
        
        print("S3BackgroundUploader: Queued upload: \(fileName)")
        DebugLogger.shared.log("S3BackgroundUploader: Queued upload: \(s3Key)")
        
        // Try to process immediately if we have credentials
        if credentials != nil {
            processQueuedUploads()
        }
    }
    
    func processQueuedUploads() {
        guard let creds = credentials else {
            print("S3BackgroundUploader: No credentials available")
            return
        }
        
        guard !uploadQueue.isEmpty else {
            return
        }
        
        // Check if there are already active uploads for these files
        let activeFiles = Set(activeUploads.values.map { $0.localPath })
        let queuedFiles = uploadQueue.filter { !activeFiles.contains($0.localPath) }
        
        guard !queuedFiles.isEmpty else {
            print("S3BackgroundUploader: All queued files are already being uploaded")
            return
        }
        
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        print("S3BackgroundUploader: Processing \(queuedFiles.count) of \(uploadQueue.count) queued uploads (App State: \(stateString))")
        DebugLogger.shared.log("S3BackgroundUploader: Processing \(queuedFiles.count) uploads in \(stateString)")
        
        // Process all queued uploads that aren't already active
        for upload in queuedFiles {
            // Verify file still exists before trying to upload
            guard FileManager.default.fileExists(atPath: upload.localPath) else {
                print("S3BackgroundUploader: File no longer exists, removing from queue: \(upload.localPath)")
                uploadQueue.removeAll { $0.localPath == upload.localPath }
                saveUploadQueue()
                continue
            }
            startUpload(upload, with: creds)
        }
    }
    
    private func startUpload(_ upload: PendingS3Upload, with creds: S3Credentials) {
        do {
            let fileURL = URL(fileURLWithPath: upload.localPath)
            
            // Build S3 URL
            let s3URL = "https://\(creds.bucket).s3.\(creds.region).amazonaws.com/\(upload.s3Key)"
            guard let url = URL(string: s3URL) else {
                throw UploadError.invalidURL
            }
            
            // Create request with AWS v4 signature
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("audio/wav", forHTTPHeaderField: "Content-Type")
            
            // Add AWS v4 signature headers
            let headers = createAWSv4Headers(
                for: request,
                credentials: creds,
                s3Key: upload.s3Key,
                fileURL: fileURL
            )
            
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            // Create upload task
            let task = backgroundSession.uploadTask(with: request, fromFile: fileURL)
            activeUploads[task] = upload
            
            task.resume()
            
            print("S3BackgroundUploader: Started upload for: \(upload.localPath)")
            DebugLogger.shared.log("S3BackgroundUploader: Upload started: \(upload.s3Key)")
            
        } catch {
            print("S3BackgroundUploader: Failed to start upload: \(error)")
            handleUploadFailure(upload, error: error)
        }
    }
    
    // MARK: - AWS v4 Signature
    
    private func createAWSv4Headers(
        for request: URLRequest,
        credentials: S3Credentials,
        s3Key: String,
        fileURL: URL
    ) -> [String: String] {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let amzDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStamp = dateFormatter.string(from: date)
        
        // Get file data for content hash
        let fileData = (try? Data(contentsOf: fileURL)) ?? Data()
        let payloadHash = sha256Hash(fileData)
        
        var headers: [String: String] = [:]
        headers["x-amz-date"] = amzDate
        headers["x-amz-content-sha256"] = payloadHash
        headers["x-amz-security-token"] = credentials.sessionToken
        
        // Create canonical request
        let canonicalHeaders = """
            content-type:audio/wav
            host:\(credentials.bucket).s3.\(credentials.region).amazonaws.com
            x-amz-content-sha256:\(payloadHash)
            x-amz-date:\(amzDate)
            x-amz-security-token:\(credentials.sessionToken)
            """
        
        let signedHeaders = "content-type;host;x-amz-content-sha256;x-amz-date;x-amz-security-token"
        
        let canonicalRequest = """
            PUT
            /\(s3Key)
            
            \(canonicalHeaders)
            
            \(signedHeaders)
            \(payloadHash)
            """
        
        // Create string to sign
        let algorithm = "AWS4-HMAC-SHA256"
        let credentialScope = "\(dateStamp)/\(credentials.region)/s3/aws4_request"
        let canonicalRequestHash = sha256Hash(canonicalRequest.data(using: .utf8)!)
        
        let stringToSign = """
            \(algorithm)
            \(amzDate)
            \(credentialScope)
            \(canonicalRequestHash)
            """
        
        // Calculate signature
        let signature = calculateSignature(
            key: credentials.secretAccessKey,
            dateStamp: dateStamp,
            region: credentials.region,
            service: "s3",
            stringToSign: stringToSign
        )
        
        // Create authorization header
        let authorization = "\(algorithm) Credential=\(credentials.accessKeyId)/\(credentialScope), SignedHeaders=\(signedHeaders), Signature=\(signature)"
        
        headers["Authorization"] = authorization
        
        return headers
    }
    
    private func sha256Hash(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    private func hmac(key: Data, data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        key.withUnsafeBytes { keyBuffer in
            data.withUnsafeBytes { dataBuffer in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
                       keyBuffer.baseAddress, key.count,
                       dataBuffer.baseAddress, data.count,
                       &hash)
            }
        }
        return Data(hash)
    }
    
    private func calculateSignature(key: String, dateStamp: String, region: String, service: String, stringToSign: String) -> String {
        let kSecret = "AWS4\(key)".data(using: .utf8)!
        let kDate = hmac(key: kSecret, data: dateStamp.data(using: .utf8)!)
        let kRegion = hmac(key: kDate, data: region.data(using: .utf8)!)
        let kService = hmac(key: kRegion, data: service.data(using: .utf8)!)
        let kSigning = hmac(key: kService, data: "aws4_request".data(using: .utf8)!)
        let signature = hmac(key: kSigning, data: stringToSign.data(using: .utf8)!)
        return signature.map { String(format: "%02x", $0) }.joined()
    }
    
    // MARK: - Queue Persistence
    
    private func saveUploadQueue() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let queueURL = documentsPath.appendingPathComponent(queueFile)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(uploadQueue)
            try data.write(to: queueURL)
        } catch {
            print("S3BackgroundUploader: Failed to save queue: \(error)")
        }
    }
    
    private func loadUploadQueue() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let queueURL = documentsPath.appendingPathComponent(queueFile)
        
        do {
            let data = try Data(contentsOf: queueURL)
            let decoder = JSONDecoder()
            uploadQueue = try decoder.decode([PendingS3Upload].self, from: data)
            
            // Filter out any invalid entries
            uploadQueue = uploadQueue.filter { upload in
                let exists = FileManager.default.fileExists(atPath: upload.localPath)
                if !exists {
                    print("S3BackgroundUploader: Removing non-existent file from queue: \(upload.localPath)")
                }
                return exists
            }
            
            print("S3BackgroundUploader: Loaded \(uploadQueue.count) valid pending uploads")
            DebugLogger.shared.log("S3BackgroundUploader: Loaded \(uploadQueue.count) pending uploads")
            
            // Save cleaned queue
            if uploadQueue.count > 0 {
                saveUploadQueue()
            }
            
        } catch {
            // No saved queue or error loading
            print("S3BackgroundUploader: No saved queue or error loading: \(error)")
            uploadQueue = []
        }
    }
    
    private func handleUploadFailure(_ upload: PendingS3Upload, error: Error) {
        if upload.retryCount < 3 {
            var retryUpload = upload
            retryUpload.retryCount += 1
            uploadQueue.insert(retryUpload, at: 0)
            saveUploadQueue()
            
            print("S3BackgroundUploader: Will retry upload (attempt \(retryUpload.retryCount))")
            
            // Retry after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.processQueuedUploads()
            }
        } else {
            onUploadFailed?(upload.localPath, error)
            // Remove from queue after max retries
            uploadQueue.removeAll { $0.localPath == upload.localPath }
            saveUploadQueue()
            
            // Process any remaining queued uploads
            if !uploadQueue.isEmpty {
                print("S3BackgroundUploader: Processing remaining \(uploadQueue.count) queued uploads after failure")
                processQueuedUploads()
            }
        }
    }
    
    // MARK: - Status
    
    func getStatistics() -> [String: Any] {
        return [
            "pendingUploads": uploadQueue.count,
            "activeUploads": activeUploads.count,
            "hasCredentials": credentials != nil
        ]
    }
}

// MARK: - URLSessionDelegate

@available(iOS 13.0, *)
extension S3BackgroundUploader: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let upload = activeUploads[task] else { return }
        
        activeUploads.removeValue(forKey: task)
        
        if let error = error {
            print("S3BackgroundUploader: Upload failed: \(error)")
            DebugLogger.shared.log("S3BackgroundUploader: Upload failed: \(error.localizedDescription)")
            handleUploadFailure(upload, error: error)
        } else if let response = task.response as? HTTPURLResponse {
            if response.statusCode == 200 || response.statusCode == 204 {
                print("S3BackgroundUploader: Upload successful: \(upload.s3Key)")
                DebugLogger.shared.log("S3BackgroundUploader: Upload successful: \(upload.s3Key)")
                
                // Remove from queue
                uploadQueue.removeAll { $0.localPath == upload.localPath }
                saveUploadQueue()
                
                // Notify success
                let s3URL = "https://\(credentials?.bucket ?? "").s3.\(credentials?.region ?? "").amazonaws.com/\(upload.s3Key)"
                onUploadComplete?(upload.localPath, s3URL)
                
                // Delete local file after successful upload
                try? FileManager.default.removeItem(atPath: upload.localPath)
                
                // Process any remaining queued uploads
                if !uploadQueue.isEmpty {
                    print("S3BackgroundUploader: Processing remaining \(uploadQueue.count) queued uploads")
                    processQueuedUploads()
                }
            } else {
                print("S3BackgroundUploader: Upload failed with status: \(response.statusCode)")
                handleUploadFailure(upload, error: UploadError.httpError(response.statusCode))
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let upload = activeUploads[task] else { return }
        
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        onUploadProgress?(upload.localPath, progress)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        print("S3BackgroundUploader: Background session finished events (App State: \(stateString))")
        DebugLogger.shared.log("S3BackgroundUploader: Background session finished in \(stateString) state")
        
        // Call the stored completion handler to let iOS know we're done
        if let completionHandler = backgroundCompletionHandler {
            print("S3BackgroundUploader: Calling background completion handler")
            DispatchQueue.main.async {
                completionHandler()
            }
            backgroundCompletionHandler = nil
        }
        
        // Process any remaining queued uploads
        if !uploadQueue.isEmpty {
            print("S3BackgroundUploader: Processing remaining queued uploads after session finish")
            processQueuedUploads()
        }
    }
}

// MARK: - Supporting Types

struct S3Credentials {
    let accessKeyId: String
    let secretAccessKey: String
    let sessionToken: String
    let bucket: String
    let region: String
    let prefix: String
}

struct PendingS3Upload: Codable {
    let localPath: String
    let s3Key: String
    let userId: String
    let metadata: [String: String]
    var retryCount: Int
    let createdAt: Date
}

enum UploadError: LocalizedError {
    case fileNotFound
    case invalidURL
    case httpError(Int)
    case noCredentials
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .invalidURL:
            return "Invalid S3 URL"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .noCredentials:
            return "No S3 credentials available"
        }
    }
}