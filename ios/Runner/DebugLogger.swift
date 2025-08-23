import Foundation

class DebugLogger {
    static let shared = DebugLogger()
    private let logFile: URL
    
    private init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        logFile = documentsPath.appendingPathComponent("ble_debug.log")
        
        // Append session marker instead of clearing
        let sessionMarker = "\n\n=== BLE Debug Log Session Started at \(Date()) ===\n"
        if let data = sessionMarker.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFile.path) {
                // Append to existing log
                if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                // Create new log file
                try? data.write(to: logFile)
            }
        }
    }
    
    func log(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        
        // Add app state indicator
        let appState = UIApplication.shared.applicationState
        let stateStr = appState == .background ? "BG" : appState == .inactive ? "IN" : "FG"
        
        let logMessage = "[\(timestamp)][\(stateStr)] \(message)\n"
        
        // Write to file with immediate flush
        if let data = logMessage.data(using: .utf8) {
            if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.synchronizeFile() // Force flush to disk
                fileHandle.closeFile()
            }
        }
        
        // Also print to console
        print(logMessage)
    }
    
    func getLogPath() -> String {
        return logFile.path
    }
    
    func markBackgroundWake() {
        log("⚡️⚡️⚡️ BACKGROUND WAKE EVENT ⚡️⚡️⚡️")
        log("App State: \(UIApplication.shared.applicationState.rawValue)")
        log("Date: \(Date())")
    }
    
    func getLogContents() -> String {
        return (try? String(contentsOf: logFile, encoding: .utf8)) ?? "No log file found"
    }
    
    func getRecentLogContents(maxBytes: Int = 102400) -> String { // Increased to 100KB
        guard let data = try? Data(contentsOf: logFile) else {
            return "No log file found"
        }
        
        if data.count <= maxBytes {
            return String(data: data, encoding: .utf8) ?? "Failed to decode log"
        }
        
        // Get the last N bytes
        let recentData = data.suffix(maxBytes)
        let logText = String(data: recentData, encoding: .utf8) ?? "Failed to decode log"
        return "...(showing last \(recentData.count) of \(data.count) bytes)...\n" + logText
    }
}