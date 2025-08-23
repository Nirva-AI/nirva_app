import Foundation

/// Native packet reassembler for OMI device audio packets
/// Ported from OmiPacketReassembler.dart to handle fragmented packets in background
@available(iOS 13.0, *)
class PacketReassembler {
    
    // MARK: - Packet Structure
    struct PacketHeader {
        let packetId: UInt16
        let fragmentIndex: UInt8
        let audioData: Data
        
        init?(from data: Data) {
            // Minimum header size: 2 bytes packet ID + 1 byte fragment index
            guard data.count >= 3 else { return nil }
            
            // Extract packet ID (16-bit, little endian)
            self.packetId = UInt16(data[0]) | (UInt16(data[1]) << 8)
            
            // Extract fragment index
            self.fragmentIndex = data[2]
            
            // Extract audio data (everything after header)
            self.audioData = data.subdata(in: 3..<data.count)
        }
    }
    
    // MARK: - Packet Metadata
    class PacketMetadata {
        let packetId: UInt16
        let timestamp: Date
        var totalFragments: Int = 0
        var fragments: [UInt8: Data] = [:]
        
        init(packetId: UInt16) {
            self.packetId = packetId
            self.timestamp = Date()
        }
        
        var age: TimeInterval {
            return Date().timeIntervalSince(timestamp)
        }
        
        var isComplete: Bool {
            guard totalFragments > 0 else { return false }
            return fragments.count == totalFragments
        }
        
        func assemblePacket() -> Data? {
            guard isComplete else { return nil }
            
            var assembledData = Data()
            for index in 0..<totalFragments {
                guard let fragment = fragments[UInt8(index)] else {
                    print("PacketReassembler: Missing fragment \(index) for packet \(packetId)")
                    return nil
                }
                assembledData.append(fragment)
            }
            
            return assembledData
        }
    }
    
    // MARK: - Properties
    private var packetBuffers: [UInt16: PacketMetadata] = [:]
    private let bufferQueue = DispatchQueue(label: "com.nirva.packet.reassembler", qos: .userInitiated)
    
    // Configuration
    private let maxPacketAge: TimeInterval = 5.0  // 5 seconds
    private let maxActivePackets = 100
    private let cleanupInterval: TimeInterval = 1.0
    
    // Statistics
    private var totalPacketsReceived = 0
    private var totalCompletePackets = 0
    private var totalDroppedPackets = 0
    private var totalFragmentsReceived = 0
    
    // Cleanup timer
    private var cleanupTimer: Timer?
    
    // Callback for complete packets
    var onCompletePacket: ((Data) -> Void)?
    
    // MARK: - Initialization
    init() {
        startCleanupTimer()
    }
    
    deinit {
        cleanupTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Process incoming packet data
    func processPacket(_ data: Data) {
        bufferQueue.async { [weak self] in
            self?.processPacketInternal(data)
        }
    }
    
    /// Get current statistics
    func getStatistics() -> [String: Any] {
        return bufferQueue.sync {
            return [
                "activePacketCount": packetBuffers.count,
                "totalPacketsReceived": totalPacketsReceived,
                "totalCompletePackets": totalCompletePackets,
                "totalDroppedPackets": totalDroppedPackets,
                "maxActivePackets": maxActivePackets,
                "maxPacketAge": maxPacketAge
            ]
        }
    }
    
    /// Reset all buffers and statistics
    func reset() {
        bufferQueue.async { [weak self] in
            self?.resetInternal()
        }
    }
    
    // MARK: - Private Methods
    
    private func processPacketInternal(_ data: Data) {
        // Parse packet header
        guard let header = PacketHeader(from: data) else {
            print("PacketReassembler: Invalid packet header, data size: \(data.count)")
            DebugLogger.shared.log("PacketReassembler: Invalid packet header, data size: \(data.count)")
            return
        }
        
        totalPacketsReceived += 1
        totalFragmentsReceived += 1
        
        // Log first few packets and periodically
        if totalFragmentsReceived <= 5 || totalFragmentsReceived % 50 == 0 {
            print("PacketReassembler: Fragment #\(totalFragmentsReceived) - Packet ID: \(header.packetId), Fragment: \(header.fragmentIndex), Audio: \(header.audioData.count) bytes")
            DebugLogger.shared.log("PacketReassembler: Fragment #\(totalFragmentsReceived) - Packet ID: \(header.packetId), Fragment: \(header.fragmentIndex), Audio: \(header.audioData.count) bytes")
        }
        
        // Get or create packet metadata
        let metadata = packetBuffers[header.packetId] ?? PacketMetadata(packetId: header.packetId)
        packetBuffers[header.packetId] = metadata
        
        // Store fragment
        metadata.fragments[header.fragmentIndex] = header.audioData
        
        // Update total fragments estimate (highest index + 1)
        let estimatedTotal = Int(header.fragmentIndex) + 1
        if estimatedTotal > metadata.totalFragments {
            metadata.totalFragments = estimatedTotal
        }
        
        // Check if packet is complete
        checkPacketCompleteness(metadata)
    }
    
    private func checkPacketCompleteness(_ metadata: PacketMetadata) {
        // Check if we have all fragments by looking for continuous sequence
        var hasAllFragments = true
        for index in 0..<metadata.fragments.count {
            if metadata.fragments[UInt8(index)] == nil {
                hasAllFragments = false
                break
            }
        }
        
        // If we have a continuous sequence, update total fragments
        if hasAllFragments {
            metadata.totalFragments = metadata.fragments.count
        }
        
        // For single-fragment packets (fragment index 0 only), mark as complete
        if metadata.fragments.count == 1 && metadata.fragments[0] != nil {
            metadata.totalFragments = 1
            print("PacketReassembler: Single-fragment packet \(metadata.packetId) detected")
            DebugLogger.shared.log("PacketReassembler: Single-fragment packet \(metadata.packetId) detected")
        }
        
        // Check if packet is complete
        if metadata.isComplete {
            if let completePacket = metadata.assemblePacket() {
                print("PacketReassembler: Complete packet \(metadata.packetId) assembled (\(completePacket.count) bytes)")
                DebugLogger.shared.log("PacketReassembler: Complete packet \(metadata.packetId) assembled (\(completePacket.count) bytes)")
                
                totalCompletePackets += 1
                
                // Deliver complete packet
                DispatchQueue.main.async { [weak self] in
                    self?.onCompletePacket?(completePacket)
                }
                
                // Remove from buffers
                packetBuffers.removeValue(forKey: metadata.packetId)
            }
        }
    }
    
    private func startCleanupTimer() {
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: cleanupInterval, repeats: true) { [weak self] _ in
            self?.performCleanup()
        }
    }
    
    private func performCleanup() {
        bufferQueue.async { [weak self] in
            self?.cleanupExpiredPackets()
        }
    }
    
    private func cleanupExpiredPackets() {
        var expiredPackets: [UInt16] = []
        
        // Find expired packets
        for (packetId, metadata) in packetBuffers {
            if metadata.age > maxPacketAge {
                expiredPackets.append(packetId)
            }
        }
        
        // Remove expired packets
        for packetId in expiredPackets {
            print("PacketReassembler: Dropping expired packet \(packetId)")
            packetBuffers.removeValue(forKey: packetId)
            totalDroppedPackets += 1
        }
        
        // Limit active packets
        if packetBuffers.count > maxActivePackets {
            // Sort by age and remove oldest
            let sortedPackets = packetBuffers.sorted { $0.value.timestamp < $1.value.timestamp }
            let toRemove = sortedPackets.prefix(packetBuffers.count - maxActivePackets)
            
            for (packetId, _) in toRemove {
                print("PacketReassembler: Dropping packet \(packetId) due to buffer limit")
                packetBuffers.removeValue(forKey: packetId)
                totalDroppedPackets += 1
            }
        }
    }
    
    private func resetInternal() {
        print("PacketReassembler: Resetting all buffers and statistics")
        
        packetBuffers.removeAll()
        totalPacketsReceived = 0
        totalCompletePackets = 0
        totalDroppedPackets = 0
    }
}