import Foundation
import CommonCrypto

/// Handles background S3 uploads with AWS v4 signature
@available(iOS 13.0, *)
class S3BackgroundUploader: NSObject {
    
    // MARK: - Singleton
    static let shared = S3BackgroundUploader()
    
    // MARK: - Properties
    private var backgroundSession: URLSession?  // Made optional to handle recreation
    private let sessionIdentifier = "com.nirva.s3upload"  // MUST be constant across app launches
    private let delegateQueue = OperationQueue()
    
    // AWS Credentials (stored securely)
    private var credentials: S3Credentials?
    
    // Simplified configuration
    private let maxConcurrentUploads = 5  // Process 5 files at once
    private var lastSyncTime: Date?
    private let syncInterval: TimeInterval = 10.0  // Check for new files every 10 seconds
    
    // Directory to monitor
    private var audioDirectory: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (documentsPath as NSString).appendingPathComponent("ble_audio_segments")
    }
    
    // Background task management
    private var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
    
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
        
        print("S3BackgroundUploader: Initialized (Simplified)")
        DebugLogger.shared.log("S3BackgroundUploader: Initialized with simplified directory sync")
        
        // Start syncing immediately if we have credentials
        if credentials != nil {
            syncAllAudioFiles()
        }
    }
    
    // Public method to recreate session when app is woken for background events
    func recreateSessionIfNeeded() {
        if backgroundSession == nil {
            DebugLogger.shared.log("S3BackgroundUploader: Recreating session for background events")
            setupBackgroundSession()
        }
    }
    
    private func setupBackgroundSession() {
        // First check if we need to reconnect to an existing session
        DebugLogger.shared.log("S3BackgroundUploader: Setting up background session with identifier: \(sessionIdentifier)")
        
        let config = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        config.isDiscretionary = false  // CRITICAL: Must be false for immediate uploads
        config.sessionSendsLaunchEvents = true  // MUST be true for background callbacks to work
        config.allowsCellularAccess = true
        config.shouldUseExtendedBackgroundIdleMode = true
        config.timeoutIntervalForRequest = 300  // 5 minutes per request
        config.timeoutIntervalForResource = 86400  // 24 hours total
        config.waitsForConnectivity = false  // CRITICAL: Don't wait - start immediately
        config.httpMaximumConnectionsPerHost = 5  // Allow max concurrent uploads
        config.networkServiceType = .responsiveData  // CRITICAL: Higher priority than .background
        
        // CRITICAL: Additional settings for immediate background execution
        if #available(iOS 13.0, *) {
            config.allowsConstrainedNetworkAccess = true
            config.allowsExpensiveNetworkAccess = true
        }
        
        // Configure delegate queue for background operations
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.qualityOfService = .userInitiated  // CRITICAL: Higher priority for immediate execution
        delegateQueue.name = "com.nirva.s3upload.queue"
        
        backgroundSession = URLSession(configuration: config, delegate: self, delegateQueue: delegateQueue)
        
        // Check for existing tasks and resume them
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            if !tasks.isEmpty {
                DebugLogger.shared.log("S3BackgroundUploader: Found \(tasks.count) existing tasks")
                for task in tasks {
                    if task.state == .suspended {
                        task.resume()
                    }
                }
            }
            // Always try to sync after checking existing tasks
            self.syncAllAudioFiles()
        }
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
        
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        print("S3BackgroundUploader: Credentials updated in \(stateString)")
        DebugLogger.shared.log("S3BackgroundUploader: ✅ Credentials updated for bucket: \(credentials?.bucket ?? "") in \(stateString)")
        
        // Immediately sync all audio files
        syncAllAudioFiles()
    }
    
    // MARK: - Simplified Directory Sync
    
    func syncAllAudioFiles() {
        guard let creds = credentials else {
            DebugLogger.shared.log("S3BackgroundUploader: No credentials, skipping sync")
            return
        }
        
        // Check if enough time has passed since last sync
        if let lastSync = lastSyncTime {
            let timeSinceSync = Date().timeIntervalSince(lastSync)
            if timeSinceSync < syncInterval {
                return
            }
        }
        
        lastSyncTime = Date()
        
        // Get all wav files in the audio directory
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: audioDirectory) else {
            DebugLogger.shared.log("S3BackgroundUploader: Could not read audio directory")
            return
        }
        
        let wavFiles = files.filter { $0.hasSuffix(".wav") }
        
        if wavFiles.isEmpty {
            return
        }
        
        DebugLogger.shared.log("S3BackgroundUploader: Found \(wavFiles.count) wav files to sync")
        
        // Check what's already uploading
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            // Get list of files currently uploading
            let uploadingFiles = Set(tasks.compactMap { task -> String? in
                guard let url = task.originalRequest?.url?.absoluteString else { return nil }
                // Extract filename from S3 URL
                return url.components(separatedBy: "/").last
            })
            
            // Find files not yet uploading
            let filesToUpload = wavFiles.filter { !uploadingFiles.contains($0) }
            
            if filesToUpload.isEmpty {
                DebugLogger.shared.log("S3BackgroundUploader: All files already uploading")
                return
            }
            
            DebugLogger.shared.log("S3BackgroundUploader: Starting upload for \(filesToUpload.count) new files")
            
            // Upload files in batches
            let batch = Array(filesToUpload.prefix(self.maxConcurrentUploads))
            for fileName in batch {
                self.uploadFile(fileName: fileName, credentials: creds)
            }
        }
    }
    
    private func uploadFile(fileName: String, credentials: S3Credentials) {
        let filePath = (audioDirectory as NSString).appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            DebugLogger.shared.log("S3BackgroundUploader: File no longer exists: \(fileName)")
            return
        }
        
        // Load metadata from companion JSON file if it exists
        var metadata: [String: String] = [:]
        let metadataFileName = fileName.replacingOccurrences(of: ".wav", with: ".json")
        let metadataPath = (audioDirectory as NSString).appendingPathComponent(metadataFileName)
        
        if FileManager.default.fileExists(atPath: metadataPath) {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: metadataPath))
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData) as? [String: String] {
                    metadata = jsonDict
                    DebugLogger.shared.log("S3BackgroundUploader: Loaded metadata for \(fileName)")
                }
            } catch {
                DebugLogger.shared.log("S3BackgroundUploader: Failed to load metadata: \(error)")
            }
        }
        
        // Get user ID from metadata or UserDefaults
        let userId = metadata["userId"] ?? UserDefaults.standard.string(forKey: "userId") ?? "default_user"
        
        let s3Key = "native-audio/\(userId)/\(fileName)"
        
        // Remove userId from metadata since it's already in the path
        metadata.removeValue(forKey: "userId")
        
        // Create and start upload task with metadata
        startUploadTask(
            localPath: filePath,
            s3Key: s3Key,
            credentials: credentials,
            metadata: metadata
        )
    }
    
    private func startUploadTask(localPath: String, s3Key: String, credentials: S3Credentials, metadata: [String: String]) {
        // CRITICAL: Begin background task to ensure upload has time to start
        let appState = UIApplication.shared.applicationState  
        if appState == .background {
            beginBackgroundTask()
        }
        
        do {
            let fileURL = URL(fileURLWithPath: localPath)
            
            // Get file size for Content-Length header
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: localPath)
            let fileSize = fileAttributes[.size] as? Int64 ?? 0
            
            // Build S3 URL
            let s3URL = "https://\(credentials.bucket).s3.\(credentials.region).amazonaws.com/\(s3Key)"
            guard let url = URL(string: s3URL) else {
                throw UploadError.invalidURL
            }
            
            // Create request with AWS v4 signature
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("audio/wav", forHTTPHeaderField: "Content-Type")
            request.setValue("\(fileSize)", forHTTPHeaderField: "Content-Length")
            
            // Add custom metadata as x-amz-meta-* headers
            for (key, value) in metadata {
                request.setValue(value, forHTTPHeaderField: "x-amz-meta-\(key.lowercased())")
            }
            
            // Add AWS v4 signature headers
            let headers = self.createAWSv4Headers(
                for: request,
                credentials: credentials,
                s3Key: s3Key,
                fileURL: fileURL,
                metadata: metadata
            )
            
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            // Create upload task (ensure session exists)
            guard let session = self.backgroundSession else {
                DebugLogger.shared.log("S3BackgroundUploader: ERROR - Session is nil, recreating...")
                self.setupBackgroundSession()
                return
            }
            let task = session.uploadTask(with: request, fromFile: fileURL)
            
            // CRITICAL: Set task priority for immediate execution
            if #available(iOS 11.0, *) {
                task.priority = URLSessionTask.highPriority  // Use high priority for immediate upload
            } else {
                task.priority = 1.0  // Maximum priority for iOS 10
            }
            
            task.resume()
            
            let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
            
            // CRITICAL: Force immediate flush in background
            if appState == .background {
                // Ensure we have enough time to flush
                beginBackgroundTask()
                
                if #available(iOS 13.0, *) {
                    Task { @MainActor in
                        await session.flush()  // Force the session to process pending tasks immediately
                        DebugLogger.shared.log("S3BackgroundUploader: 🔥 Forced session flush in BACKGROUND")
                    }
                }
            }
            
            print("S3BackgroundUploader: Started upload for: \(localPath)")
            DebugLogger.shared.log("S3BackgroundUploader: Started upload task \(task.taskIdentifier) for: \(s3Key) in \(stateString)")
            
        } catch {
            print("S3BackgroundUploader: Failed to start upload: \(error)")
            DebugLogger.shared.log("S3BackgroundUploader: Failed to start upload for \(localPath): \(error.localizedDescription)")
            onUploadFailed?(localPath, error)
        }
    }
    
    // MARK: - AWS v4 Signature
    
    private func createAWSv4Headers(
        for request: URLRequest,
        credentials: S3Credentials,
        s3Key: String,
        fileURL: URL,
        metadata: [String: String] = [:]
    ) -> [String: String] {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let amzDate = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStamp = dateFormatter.string(from: date)
        
        // For background uploads, use UNSIGNED-PAYLOAD to avoid loading file into memory
        // This is required for large files and background sessions
        let payloadHash = "UNSIGNED-PAYLOAD"
        
        var headers: [String: String] = [:]
        headers["x-amz-date"] = amzDate
        headers["x-amz-content-sha256"] = payloadHash
        if !credentials.sessionToken.isEmpty {
            headers["x-amz-security-token"] = credentials.sessionToken
        }
        
        // Create canonical request
        let canonicalHeaders: String
        let signedHeaders: String
        
        // Sort metadata keys for consistent ordering in canonical request
        let sortedMetadataKeys = metadata.keys.sorted()
        let metadataHeaders = sortedMetadataKeys.map { key in
            "x-amz-meta-\(key.lowercased()):\(metadata[key] ?? "")"
        }.joined(separator: "\n")
        
        let metadataSignedHeaders = sortedMetadataKeys.map { key in "x-amz-meta-\(key.lowercased())" }.joined(separator: ";")
        
        if !credentials.sessionToken.isEmpty {
            if !metadata.isEmpty {
                canonicalHeaders = """
                    content-type:audio/wav
                    host:\(credentials.bucket).s3.\(credentials.region).amazonaws.com
                    x-amz-content-sha256:\(payloadHash)
                    x-amz-date:\(amzDate)
                    \(metadataHeaders)
                    x-amz-security-token:\(credentials.sessionToken)
                    """
                signedHeaders = "content-type;host;x-amz-content-sha256;x-amz-date;\(metadataSignedHeaders);x-amz-security-token"
            } else {
                canonicalHeaders = """
                    content-type:audio/wav
                    host:\(credentials.bucket).s3.\(credentials.region).amazonaws.com
                    x-amz-content-sha256:\(payloadHash)
                    x-amz-date:\(amzDate)
                    x-amz-security-token:\(credentials.sessionToken)
                    """
                signedHeaders = "content-type;host;x-amz-content-sha256;x-amz-date;x-amz-security-token"
            }
        } else {
            if !metadata.isEmpty {
                canonicalHeaders = """
                    content-type:audio/wav
                    host:\(credentials.bucket).s3.\(credentials.region).amazonaws.com
                    x-amz-content-sha256:\(payloadHash)
                    x-amz-date:\(amzDate)
                    \(metadataHeaders)
                    """
                signedHeaders = "content-type;host;x-amz-content-sha256;x-amz-date;\(metadataSignedHeaders)"
            } else {
                canonicalHeaders = """
                    content-type:audio/wav
                    host:\(credentials.bucket).s3.\(credentials.region).amazonaws.com
                    x-amz-content-sha256:\(payloadHash)
                    x-amz-date:\(amzDate)
                    """
                signedHeaders = "content-type;host;x-amz-content-sha256;x-amz-date"
            }
        }
        
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
    
    
    // MARK: - Status
    
    func getStatistics() -> [String: Any] {
        var stats: [String: Any] = [
            "hasCredentials": credentials != nil,
            "audioDirectory": audioDirectory
        ]
        
        // Count files in audio directory
        if let files = try? FileManager.default.contentsOfDirectory(atPath: audioDirectory) {
            let wavFiles = files.filter { $0.hasSuffix(".wav") }
            stats["localWavFiles"] = wavFiles.count
        }
        
        return stats
    }
    
    // MARK: - Background Task Management
    
    private func beginBackgroundTask() {
        guard backgroundTaskId == .invalid else { return }
        
        backgroundTaskId = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        if backgroundTaskId != .invalid {
            DebugLogger.shared.log("S3BackgroundUploader: Background task started")
        }
    }
    
    private func endBackgroundTask() {
        guard backgroundTaskId != .invalid else { return }
        
        DebugLogger.shared.log("S3BackgroundUploader: Ending background task")
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
        backgroundTaskId = .invalid
    }
    
    // Called when app enters background
    func handleAppBackground() {
        DebugLogger.shared.log("S3BackgroundUploader: App entering background, ensuring uploads continue")
        
        // Ensure session exists
        recreateSessionIfNeeded()
        
        // Sync any pending files
        syncAllAudioFiles()
        
        // Begin background task to ensure we have time
        beginBackgroundTask()
        
        // Force URLSession to process any pending tasks
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            DebugLogger.shared.log("S3BackgroundUploader: \(tasks.count) tasks in background session")
            let runningTasks = tasks.filter { $0.state == .running }.count
            let suspendedTasks = tasks.filter { $0.state == .suspended }.count
            DebugLogger.shared.log("S3BackgroundUploader: Running: \(runningTasks), Suspended: \(suspendedTasks)")
            
            for task in tasks {
                if task.state == .suspended {
                    DebugLogger.shared.log("S3BackgroundUploader: Resuming suspended task \(task.taskIdentifier)")
                    task.resume()
                }
            }
            
        }
        
        // Don't block - let iOS handle the delegate callbacks asynchronously
        // Removed: delegateQueue.waitUntilAllOperationsAreFinished() - this was blocking!
    }
    
    // MARK: - Helper Methods
    
    private func getURLErrorDescription(code: Int) -> String {
        switch code {
        case NSURLErrorUnknown:
            return "Unknown error"
        case NSURLErrorCancelled:
            return "Request cancelled"
        case NSURLErrorBadURL:
            return "Bad URL"
        case NSURLErrorTimedOut:
            return "Request timed out"
        case NSURLErrorUnsupportedURL:
            return "Unsupported URL"
        case NSURLErrorCannotFindHost:
            return "Cannot find host"
        case NSURLErrorCannotConnectToHost:
            return "Cannot connect to host"
        case NSURLErrorNetworkConnectionLost:
            return "Network connection lost"
        case NSURLErrorDNSLookupFailed:
            return "DNS lookup failed"
        case NSURLErrorHTTPTooManyRedirects:
            return "Too many redirects"
        case NSURLErrorResourceUnavailable:
            return "Resource unavailable"
        case NSURLErrorNotConnectedToInternet:
            return "Not connected to internet"
        case NSURLErrorRedirectToNonExistentLocation:
            return "Redirect to non-existent location"
        case NSURLErrorBadServerResponse:
            return "Bad server response"
        case NSURLErrorUserCancelledAuthentication:
            return "User cancelled authentication"
        case NSURLErrorUserAuthenticationRequired:
            return "User authentication required"
        case NSURLErrorZeroByteResource:
            return "Zero byte resource"
        case NSURLErrorCannotDecodeRawData:
            return "Cannot decode raw data"
        case NSURLErrorCannotDecodeContentData:
            return "Cannot decode content data"
        case NSURLErrorCannotParseResponse:
            return "Cannot parse response"
        case NSURLErrorFileDoesNotExist:
            return "File does not exist"
        case NSURLErrorFileIsDirectory:
            return "File is directory"
        case NSURLErrorNoPermissionsToReadFile:
            return "No permissions to read file"
        case NSURLErrorDataLengthExceedsMaximum:
            return "Data length exceeds maximum"
        case NSURLErrorSecureConnectionFailed:
            return "Secure connection failed"
        case NSURLErrorServerCertificateHasBadDate:
            return "Server certificate has bad date"
        case NSURLErrorServerCertificateUntrusted:
            return "Server certificate untrusted"
        case NSURLErrorServerCertificateHasUnknownRoot:
            return "Server certificate has unknown root"
        case NSURLErrorServerCertificateNotYetValid:
            return "Server certificate not yet valid"
        case NSURLErrorClientCertificateRejected:
            return "Client certificate rejected"
        case NSURLErrorClientCertificateRequired:
            return "Client certificate required"
        case NSURLErrorCannotLoadFromNetwork:
            return "Cannot load from network"
        case NSURLErrorDownloadDecodingFailedMidStream:
            return "Download decoding failed mid-stream"
        case NSURLErrorDownloadDecodingFailedToComplete:
            return "Download decoding failed to complete"
        case NSURLErrorInternationalRoamingOff:
            return "International roaming off"
        case NSURLErrorCallIsActive:
            return "Call is active"
        case NSURLErrorDataNotAllowed:
            return "Data not allowed"
        case NSURLErrorRequestBodyStreamExhausted:
            return "Request body stream exhausted"
        case NSURLErrorBackgroundSessionRequiresSharedContainer:
            return "Background session requires shared container"
        case NSURLErrorBackgroundSessionInUseByAnotherProcess:
            return "Background session in use by another process"
        case NSURLErrorBackgroundSessionWasDisconnected:
            return "Background session was disconnected"
        default:
            return "Error code: \(code)"
        }
    }
}

// MARK: - URLSessionDelegate

@available(iOS 13.0, *)
extension S3BackgroundUploader: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        // Extract file info from the task URL
        guard let url = task.originalRequest?.url?.absoluteString else {
            DebugLogger.shared.log("S3BackgroundUploader: Task completed but no URL found")
            return
        }
        
        // Extract filename from S3 URL
        let fileName = url.components(separatedBy: "/").last ?? "unknown"
        let localPath = (audioDirectory as NSString).appendingPathComponent(fileName)
            
        
        if let error = error {
            // Error occurred
            let nsError = error as NSError
            print("S3BackgroundUploader: Upload failed for \(fileName): \(error)")
            DebugLogger.shared.log("S3BackgroundUploader: ❌ Upload failed for \(fileName) in \(stateString):")
            DebugLogger.shared.log("  - Error: \(error.localizedDescription)")
            onUploadFailed?(localPath, error)
            
            // File will be retried on next sync
        } else if let response = task.response as? HTTPURLResponse {
            if response.statusCode == 200 || response.statusCode == 204 {
                // Success
                print("S3BackgroundUploader: Upload successful: \(fileName)")
                DebugLogger.shared.log("S3BackgroundUploader: ✅ Upload successful for \(fileName) - HTTP \(response.statusCode)")
                
                // Notify success
                let s3URL = url
                onUploadComplete?(localPath, s3URL)
                
                // Delete local file after successful upload
                try? FileManager.default.removeItem(atPath: localPath)
                
                // Also delete the companion metadata JSON file if it exists
                let metadataFileName = fileName.replacingOccurrences(of: ".wav", with: ".json")
                let metadataPath = (audioDirectory as NSString).appendingPathComponent(metadataFileName)
                if FileManager.default.fileExists(atPath: metadataPath) {
                    try? FileManager.default.removeItem(atPath: metadataPath)
                    DebugLogger.shared.log("S3BackgroundUploader: Deleted metadata file: \(metadataFileName)")
                }
                
                // Sync again to upload any remaining files
                syncAllAudioFiles()
            } else {
                // HTTP error
                print("S3BackgroundUploader: Upload failed with status \(response.statusCode) for \(fileName)")
                DebugLogger.shared.log("S3BackgroundUploader: ❌ HTTP error \(response.statusCode) for \(fileName)")
                onUploadFailed?(localPath, UploadError.httpError(response.statusCode))
                
                // File will be retried on next sync
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        // Extract filename from task URL
        if let url = task.originalRequest?.url?.absoluteString {
            let fileName = url.components(separatedBy: "/").last ?? "unknown"
            let localPath = (audioDirectory as NSString).appendingPathComponent(fileName)
            let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
            onUploadProgress?(localPath, progress)
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        print("S3BackgroundUploader: Background session finished events (App State: \(stateString))")
        DebugLogger.shared.log("S3BackgroundUploader: 🏁 urlSessionDidFinishEvents called in \(stateString)")
        
        // End our background task if we have one
        endBackgroundTask()
        
        // Call the stored completion handler to let iOS know we're done
        if let completionHandler = backgroundCompletionHandler {
            print("S3BackgroundUploader: Calling background completion handler")
            DebugLogger.shared.log("S3BackgroundUploader: Calling iOS background completion handler")
            DispatchQueue.main.async {
                completionHandler()
            }
            backgroundCompletionHandler = nil
        }
        
        // Sync again to upload any remaining files
        syncAllAudioFiles()
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

enum UploadError: LocalizedError {
    case fileNotFound
    case invalidURL
    case httpError(Int)
    case noCredentials
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .noCredentials:
            return "No credentials available"
        case .unknown:
            return "Unknown error"
        }
    }
}

