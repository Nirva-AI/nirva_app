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
    
    // Upload queue management
    private var uploadQueue: [PendingS3Upload] = []
    private let queueFile = "s3_upload_queue.json"
    
    // Batch upload configuration
    private let maxConcurrentUploads = 5  // Process 5 files at once to reduce wake frequency (increased from 3)
    private var lastBatchTime: Date?
    private let minBackgroundUploadInterval: TimeInterval = 30.0  // Only applies in FOREGROUND mode to prevent network overload
    
    // Tracking
    private var activeUploads: [URLSessionTask: PendingS3Upload] = [:]
    
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
        loadUploadQueue()
        
        print("S3BackgroundUploader: Initialized")
        DebugLogger.shared.log("S3BackgroundUploader: Initialized with background session")
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
        
        // Immediately check for existing tasks from previous app session
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            if !tasks.isEmpty {
                DebugLogger.shared.log("S3BackgroundUploader: Found \(tasks.count) existing tasks from previous session")
                for task in tasks {
                    DebugLogger.shared.log("S3BackgroundUploader: Existing task \(task.taskIdentifier) state: \(task.state.rawValue)")
                    // Ensure task is resumed if suspended
                    if task.state == .suspended {
                        task.resume()
                        DebugLogger.shared.log("S3BackgroundUploader: Resumed suspended task \(task.taskIdentifier)")
                    }
                }
            }
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
        
        // Log current state
        DebugLogger.shared.log("S3BackgroundUploader: Active uploads: \(activeUploads.count), Queued: \(uploadQueue.count)")
        
        // CRITICAL: Process queued uploads immediately in background
        if appState == .background && !uploadQueue.isEmpty {
            DebugLogger.shared.log("S3BackgroundUploader: 🚀 BACKGROUND - Processing \(uploadQueue.count) queued uploads immediately after credentials")
            processQueuedUploads()
        }
        
        // Reconnect to existing tasks
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            DebugLogger.shared.log("S3BackgroundUploader: Background session has \(tasks.count) tasks")
            
            // Log and handle orphaned tasks
            for task in tasks {
                DebugLogger.shared.log("S3BackgroundUploader: Task \(task.taskIdentifier): state=\(task.state.rawValue), progress=\(task.progress.fractionCompleted)")
                
                if self.activeUploads[task] == nil {
                    DebugLogger.shared.log("S3BackgroundUploader: Found orphaned task \(task.taskIdentifier), state: \(task.state.rawValue)")
                    // Don't cancel - let it complete and handle in delegate
                }
            }
            
            // Process new uploads if no active tasks running
            let hasActiveTasks = tasks.contains { $0.state == .running }
            if !hasActiveTasks && !self.uploadQueue.isEmpty {
                DebugLogger.shared.log("S3BackgroundUploader: No active tasks, processing \(self.uploadQueue.count) queued uploads")
                self.processQueuedUploads()
            } else if hasActiveTasks {
                DebugLogger.shared.log("S3BackgroundUploader: \(tasks.filter { $0.state == .running }.count) tasks still running, waiting for completion")
            }
        }
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
        
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        print("S3BackgroundUploader: Queued upload: \(fileName)")
        DebugLogger.shared.log("S3BackgroundUploader: Queued upload: \(s3Key) in \(stateString)")
        
        // Try to process immediately if we have credentials
        if let creds = credentials {
            DebugLogger.shared.log("S3BackgroundUploader: Have credentials, processing immediately")
            processQueuedUploads()
        } else {
            DebugLogger.shared.log("S3BackgroundUploader: ⚠️ No credentials yet, upload queued for later when credentials arrive")
        }
    }
    
    func processQueuedUploads() {
        guard let creds = credentials else {
            print("S3BackgroundUploader: No credentials available")
            DebugLogger.shared.log("S3BackgroundUploader: No credentials available")
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
            DebugLogger.shared.log("S3BackgroundUploader: All queued files already uploading")
            return
        }
        
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
        
        // NO THROTTLING IN BACKGROUND - iOS gives us limited time, must process immediately
        if appState == .background || appState == .inactive {
            // Process immediately without any delay in background
            DebugLogger.shared.log("S3BackgroundUploader: ⚡ BACKGROUND MODE - Processing uploads immediately (no throttling)")
            lastBatchTime = Date()
        } else {
            // Only throttle in foreground to prevent network overload
            if let lastTime = lastBatchTime {
                let timeSinceLastBatch = Date().timeIntervalSince(lastTime)
                if timeSinceLastBatch < minBackgroundUploadInterval {
                    let remainingDelay = minBackgroundUploadInterval - timeSinceLastBatch
                    DebugLogger.shared.log("S3BackgroundUploader: FOREGROUND - Delaying batch by \(remainingDelay)s to prevent network overload")
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + remainingDelay) { [weak self] in
                        self?.processQueuedUploads()
                    }
                    return
                }
            }
            lastBatchTime = Date()
            DebugLogger.shared.log("S3BackgroundUploader: Processing foreground batch (30s rate limit)")
        }
        
        // Limit batch size to prevent too many wake events
        let batchSize = min(queuedFiles.count, maxConcurrentUploads)
        let batch = Array(queuedFiles.prefix(batchSize))
        
        print("S3BackgroundUploader: Processing batch of \(batch.count) from \(queuedFiles.count) queued uploads (App State: \(stateString))")
        DebugLogger.shared.log("S3BackgroundUploader: Processing batch of \(batch.count) uploads in \(stateString)")
        
        // Request background task if we're in background
        if appState == .background || appState == .inactive {
            beginBackgroundTask()
        }
        
        // Process batch of uploads
        for upload in batch {
            // Verify file still exists before trying to upload
            guard FileManager.default.fileExists(atPath: upload.localPath) else {
                print("S3BackgroundUploader: File no longer exists, removing from queue: \(upload.localPath)")
                DebugLogger.shared.log("S3BackgroundUploader: File no longer exists: \(upload.localPath)")
                uploadQueue.removeAll { $0.localPath == upload.localPath }
                saveUploadQueue()
                continue
            }
            startUpload(upload, with: creds)
        }
    }
    
    private func startUpload(_ upload: PendingS3Upload, with creds: S3Credentials) {
        // CRITICAL: Begin background task to ensure upload has time to start
        let appState = UIApplication.shared.applicationState  
        if appState == .background {
            beginBackgroundTask()
        }
        
        // Check if this file is already being uploaded
        backgroundSession?.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            let isAlreadyUploading = tasks.contains { task in
                if let url = task.originalRequest?.url?.absoluteString {
                    return url.contains(upload.s3Key) && task.state == .running
                }
                return false
            }
            
            if isAlreadyUploading {
                DebugLogger.shared.log("S3BackgroundUploader: Skipping duplicate upload: \(upload.s3Key)")
                return
            }
            
            // Proceed with upload
            do {
                let fileURL = URL(fileURLWithPath: upload.localPath)
                
                // Get file size for Content-Length header
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: upload.localPath)
                let fileSize = fileAttributes[.size] as? Int64 ?? 0
                
                // Build S3 URL
                let s3URL = "https://\(creds.bucket).s3.\(creds.region).amazonaws.com/\(upload.s3Key)"
                guard let url = URL(string: s3URL) else {
                    throw UploadError.invalidURL
                }
                
                // Create request with AWS v4 signature
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("audio/wav", forHTTPHeaderField: "Content-Type")
                request.setValue("\(fileSize)", forHTTPHeaderField: "Content-Length")
                
                // Add custom metadata as x-amz-meta-* headers
                for (key, value) in upload.metadata {
                    request.setValue(value, forHTTPHeaderField: "x-amz-meta-\(key.lowercased())")
                }
                
                // Add AWS v4 signature headers
                let headers = self.createAWSv4Headers(
                    for: request,
                    credentials: creds,
                    s3Key: upload.s3Key,
                    fileURL: fileURL,
                    metadata: upload.metadata
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
                self.activeUploads[task] = upload
                
                // CRITICAL: Set task priority for immediate execution
                if #available(iOS 11.0, *) {
                    task.priority = URLSessionTask.highPriority  // Use high priority for immediate upload
                } else {
                    task.priority = 1.0  // Maximum priority for iOS 10
                }
                
                task.resume()
                
                let appState = UIApplication.shared.applicationState
                let stateString = appState == .background ? "BACKGROUND" : appState == .inactive ? "INACTIVE" : "FOREGROUND"
                
                // CRITICAL: Force immediate flush in background
                if appState == .background {
                    // Ensure we have enough time to flush
                    beginBackgroundTask()
                    
                    if #available(iOS 13.0, *) {
                        Task { @MainActor in
                            await session.flush()  // Force the session to process pending tasks immediately
                            DebugLogger.shared.log("S3BackgroundUploader: 🔥 Forced session flush in BACKGROUND")
                            
                            // Verify tasks are actually running after flush
                            session.getAllTasks { tasks in
                                DebugLogger.shared.log("S3BackgroundUploader: After flush - \(tasks.count) tasks")
                                for (index, task) in tasks.enumerated() {
                                    DebugLogger.shared.log("S3BackgroundUploader: Task \(task.taskIdentifier) state: \(task.state.rawValue), bytes sent: \(task.countOfBytesSent)")
                                    if index < 3 && task.state == .suspended {
                                        task.resume()
                                        DebugLogger.shared.log("S3BackgroundUploader: Force resumed task \(task.taskIdentifier)")
                                    }
                                }
                            }
                        }
                    } else {
                        // For iOS < 13, try to force processing by getting all tasks
                        session.getAllTasks { tasks in
                            DebugLogger.shared.log("S3BackgroundUploader: 🔥 Background has \(tasks.count) tasks queued")
                        }
                    }
                }
                
                print("S3BackgroundUploader: Started upload for: \(upload.localPath)")
                DebugLogger.shared.log("S3BackgroundUploader: Started upload task \(task.taskIdentifier) for: \(upload.s3Key)")
                DebugLogger.shared.log("S3BackgroundUploader: Upload task \(task.taskIdentifier) started in \(stateString): \(upload.s3Key)")
                DebugLogger.shared.log("S3BackgroundUploader: Task state after resume: \(task.state.rawValue), priority: \(task.priority)")
                
            } catch {
                print("S3BackgroundUploader: Failed to start upload: \(error)")
                DebugLogger.shared.log("S3BackgroundUploader: Failed to start upload: \(error.localizedDescription)")
                self.handleUploadFailure(upload, error: error)
            }
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
            DebugLogger.shared.log("S3BackgroundUploader: Failed to save queue: \(error.localizedDescription)")
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
                    DebugLogger.shared.log("S3BackgroundUploader: Removing non-existent file from queue: \(upload.localPath)")
                }
                return exists
            }
            
            // Remove duplicates from queue but keep all unique files
            var seen = Set<String>()
            uploadQueue = uploadQueue.filter { upload in
                if seen.contains(upload.s3Key) {
                    DebugLogger.shared.log("S3BackgroundUploader: Removing duplicate from queue: \(upload.s3Key)")
                    return false
                }
                seen.insert(upload.s3Key)
                return true
            }
            
            print("S3BackgroundUploader: Loaded \(uploadQueue.count) unique valid pending uploads")
            DebugLogger.shared.log("S3BackgroundUploader: Loaded \(uploadQueue.count) unique valid pending uploads from disk")
            DebugLogger.shared.log("S3BackgroundUploader: Loaded \(uploadQueue.count) unique pending uploads")
            
            // Save cleaned queue
            if uploadQueue.count > 0 {
                saveUploadQueue()
            }
            
        } catch {
            // No saved queue or error loading
            print("S3BackgroundUploader: No saved queue or error loading: \(error)")
            DebugLogger.shared.log("S3BackgroundUploader: No saved queue or error loading: \(error.localizedDescription)")
            uploadQueue = []
        }
    }
    
    private func handleUploadFailure(_ upload: PendingS3Upload, error: Error) {
        // Log detailed error information
        DebugLogger.shared.log("S3BackgroundUploader: Handling failure for: \(upload.s3Key)")
        DebugLogger.shared.log("S3BackgroundUploader: Retry count: \(upload.retryCount)/unlimited")
        
        // Check if the file still exists before retrying
        if !FileManager.default.fileExists(atPath: upload.localPath) {
            DebugLogger.shared.log("S3BackgroundUploader: File no longer exists, removing from queue: \(upload.localPath)")
            print("S3BackgroundUploader: File no longer exists, removing from queue: \(upload.localPath)")
            
            // Remove from queue since file doesn't exist
            uploadQueue.removeAll { $0.localPath == upload.localPath }
            saveUploadQueue()
            
            // Notify failure and don't retry
            onUploadFailed?(upload.localPath, UploadError.fileNotFound)
            return
        }
        
        // NEVER give up - keep retrying with exponential backoff (only for existing files)
        var retryUpload = upload
        retryUpload.retryCount += 1
        
        // Don't remove from queue, just update retry count
        if let index = uploadQueue.firstIndex(where: { $0.localPath == upload.localPath }) {
            uploadQueue[index] = retryUpload
        } else {
            uploadQueue.insert(retryUpload, at: 0)
        }
        saveUploadQueue()
        
        // Exponential backoff: 2s, 4s, 8s, 16s, then cap at 30s
        let backoffDelay = min(pow(2.0, Double(retryUpload.retryCount)), 30.0)
        
        print("S3BackgroundUploader: Will retry upload (attempt \(retryUpload.retryCount)) after \(backoffDelay)s")
        DebugLogger.shared.log("S3BackgroundUploader: Will retry upload \(retryUpload.s3Key) (attempt \(retryUpload.retryCount)) after \(backoffDelay)s")
        DebugLogger.shared.log("S3BackgroundUploader: Will retry upload (attempt \(retryUpload.retryCount)) after \(backoffDelay)s")
        
        // Retry after backoff delay
        DispatchQueue.main.asyncAfter(deadline: .now() + backoffDelay) { [weak self] in
            guard let self = self, let creds = self.credentials else { 
                DebugLogger.shared.log("S3BackgroundUploader: No credentials for retry")
                return 
            }
            self.startUpload(retryUpload, with: creds)
        }
        
        // Notify failure (but we're retrying)
        onUploadFailed?(upload.localPath, error)
        
        // NEVER delete the local file on failure
        DebugLogger.shared.log("S3BackgroundUploader: Keeping local file for retry: \(upload.localPath)")
    }
    
    // MARK: - Status
    
    func getStatistics() -> [String: Any] {
        return [
            "pendingUploads": uploadQueue.count,
            "activeUploads": activeUploads.count,
            "hasCredentials": credentials != nil
        ]
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
        DebugLogger.shared.log("S3BackgroundUploader: Active uploads: \(activeUploads.count), Queued: \(uploadQueue.count)")
        
        // Ensure session exists
        recreateSessionIfNeeded()
        
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
            
            // Process any queued uploads
            if !self.uploadQueue.isEmpty {
                self.processQueuedUploads()
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
        
        // CRITICAL: Log whether error is nil or present
        if error == nil {
            DebugLogger.shared.log("S3BackgroundUploader: ✅ didCompleteWithError called with SUCCESS (error is nil) in \(stateString) - task \(task.taskIdentifier)")
        } else {
            DebugLogger.shared.log("S3BackgroundUploader: ❌ didCompleteWithError called with ERROR in \(stateString) - task \(task.taskIdentifier)")
        }
        
        // Try to get upload from activeUploads first
        if let upload = activeUploads[task] {
            activeUploads.removeValue(forKey: task)
            
            if let error = error {
                // COMPREHENSIVE ERROR LOGGING
                let nsError = error as NSError
                print("S3BackgroundUploader: Upload failed: \(error)")
                DebugLogger.shared.log("S3BackgroundUploader: ❌ ERROR DETAILS for \(upload.s3Key):")
                DebugLogger.shared.log("  - Error Description: \(error.localizedDescription)")
                DebugLogger.shared.log("  - Error Domain: \(nsError.domain)")
                DebugLogger.shared.log("  - Error Code: \(nsError.code)")
                DebugLogger.shared.log("  - User Info: \(nsError.userInfo)")
                
                // Log specific error types
                if nsError.domain == NSURLErrorDomain {
                    DebugLogger.shared.log("  - Network Error Type: \(self.getURLErrorDescription(code: nsError.code))")
                }
                
                // Log recovery suggestion if available
                if let recoverySuggestion = nsError.localizedRecoverySuggestion {
                    DebugLogger.shared.log("  - Recovery Suggestion: \(recoverySuggestion)")
                }
                
                // Always retry - never drop files
                handleUploadFailure(upload, error: error)
            } else if let response = task.response as? HTTPURLResponse {
                if response.statusCode == 200 || response.statusCode == 204 {
                    print("S3BackgroundUploader: Upload successful: \(upload.s3Key)")
                    DebugLogger.shared.log("S3BackgroundUploader: ✅ SUCCESS - HTTP \(response.statusCode) for: \(upload.s3Key)")
                    
                    // Log response headers for debugging
                    if let headers = response.allHeaderFields as? [String: String] {
                        DebugLogger.shared.log("  - Response Headers: \(headers)")
                    }
                    
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
                        DebugLogger.shared.log("S3BackgroundUploader: Processing remaining \(uploadQueue.count) queued uploads after success")
                        processQueuedUploads()
                    }
                } else {
                    // HTTP ERROR - DETAILED LOGGING
                    print("S3BackgroundUploader: Upload failed with status: \(response.statusCode)")
                    DebugLogger.shared.log("S3BackgroundUploader: ❌ HTTP ERROR \(response.statusCode) for: \(upload.s3Key)")
                    
                    // Log response headers for debugging HTTP errors
                    if let headers = response.allHeaderFields as? [String: String] {
                        DebugLogger.shared.log("  - Error Response Headers: \(headers)")
                    }
                    
                    handleUploadFailure(upload, error: UploadError.httpError(response.statusCode))
                }
            } else {
                // CRITICAL: No error but also no HTTP response - this is the mystery case!
                DebugLogger.shared.log("S3BackgroundUploader: ⚠️ UNUSUAL: didCompleteWithError called with nil error but NO HTTP response!")
                DebugLogger.shared.log("  - Upload: \(upload.s3Key)")
                DebugLogger.shared.log("  - Task State: \(task.state.rawValue)")
                DebugLogger.shared.log("  - Task Response: \(String(describing: task.response))")
                DebugLogger.shared.log("  - Original Request: \(String(describing: task.originalRequest?.url))")
                
                // Treat as failure and retry
                handleUploadFailure(upload, error: UploadError.unknown)
            }
        } else {
            // CRITICAL: Handle orphaned task
            
            // Log whether error is nil or present for orphaned task
            if error == nil {
                DebugLogger.shared.log("S3BackgroundUploader: ⚠️ Orphaned task \(task.taskIdentifier) completed with SUCCESS (error is nil) in \(stateString)")
            } else {
                DebugLogger.shared.log("S3BackgroundUploader: ⚠️ Orphaned task \(task.taskIdentifier) completed with ERROR in \(stateString)")
            }
            
            DebugLogger.shared.log("S3BackgroundUploader: Task URL: \(task.originalRequest?.url?.absoluteString ?? "nil")")
            
            // Try to identify the upload from the task's URL
            if let url = task.originalRequest?.url?.absoluteString,
               let index = uploadQueue.firstIndex(where: { url.contains($0.s3Key) }) {
                let orphanedUpload = uploadQueue[index]
                DebugLogger.shared.log("S3BackgroundUploader: Identified orphaned upload: \(orphanedUpload.s3Key)")
                
                if let error = error {
                    // COMPREHENSIVE ERROR LOGGING for orphaned task
                    let nsError = error as NSError
                    DebugLogger.shared.log("S3BackgroundUploader: ❌ ORPHANED TASK ERROR DETAILS:")
                    DebugLogger.shared.log("  - Error Description: \(error.localizedDescription)")
                    DebugLogger.shared.log("  - Error Domain: \(nsError.domain)")
                    DebugLogger.shared.log("  - Error Code: \(nsError.code)")
                    DebugLogger.shared.log("  - User Info: \(nsError.userInfo)")
                    
                    if nsError.domain == NSURLErrorDomain {
                        DebugLogger.shared.log("  - Network Error Type: \(self.getURLErrorDescription(code: nsError.code))")
                    }
                    
                    // Retry - don't remove from queue
                    handleUploadFailure(orphanedUpload, error: error)
                } else if let response = task.response as? HTTPURLResponse {
                    if response.statusCode == 200 || response.statusCode == 204 {
                        // Success - remove from queue
                        uploadQueue.remove(at: index)
                        saveUploadQueue()
                        DebugLogger.shared.log("S3BackgroundUploader: ✅ ORPHANED SUCCESS - HTTP \(response.statusCode) for: \(orphanedUpload.s3Key)")
                        
                        // Delete local file only after successful upload
                        try? FileManager.default.removeItem(atPath: orphanedUpload.localPath)
                    } else {
                        // HTTP error for orphaned task
                        DebugLogger.shared.log("S3BackgroundUploader: ❌ ORPHANED HTTP ERROR \(response.statusCode)")
                        
                        // Log response headers for debugging
                        if let headers = response.allHeaderFields as? [String: String] {
                            DebugLogger.shared.log("  - Error Response Headers: \(headers)")
                        }
                        
                        handleUploadFailure(orphanedUpload, error: UploadError.httpError(response.statusCode))
                    }
                } else {
                    // CRITICAL: Orphaned task with no error and no response
                    DebugLogger.shared.log("S3BackgroundUploader: ⚠️ UNUSUAL ORPHANED: nil error but NO HTTP response!")
                    DebugLogger.shared.log("  - Task State: \(task.state.rawValue)")
                    DebugLogger.shared.log("  - Task Response: \(String(describing: task.response))")
                    
                    // Treat as failure and retry
                    handleUploadFailure(orphanedUpload, error: UploadError.unknown)
                }
            } else {
                DebugLogger.shared.log("S3BackgroundUploader: ⚠️ Could not identify orphaned task from URL")
                DebugLogger.shared.log("S3BackgroundUploader: Queue has \(uploadQueue.count) items, activeUploads has \(activeUploads.count) items")
            }
            
            // Always process next uploads
            if !uploadQueue.isEmpty {
                processQueuedUploads()
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
        DebugLogger.shared.log("S3BackgroundUploader: 🏁 urlSessionDidFinishEvents called in \(stateString)")
        DebugLogger.shared.log("S3BackgroundUploader: Active uploads: \(activeUploads.count), Queued: \(uploadQueue.count)")
        DebugLogger.shared.log("S3BackgroundUploader: Background session finished in \(stateString) state")
        
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
    case unknown
    
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
        case .unknown:
            return "Unknown error occurred"
        }
    }
}