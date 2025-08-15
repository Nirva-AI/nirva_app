import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service for reassembling fragmented audio packets from OMI device
/// 
/// OMI firmware sends audio data in fragmented packets over BLE GATT
/// This service reassembles them into complete Opus audio frames
class OmiPacketReassembler extends ChangeNotifier {
  // Packet buffers organized by packet ID and fragment index
  final Map<int, Map<int, List<int>>> _packetBuffers = {};
  
  // Metadata for each packet (total fragments, timestamp, etc.)
  final Map<int, PacketMetadata> _packetMetadata = {};
  
  // Stream controller for complete packets
  final StreamController<List<int>> _completePacketController = 
      StreamController<List<int>>.broadcast();
  
  // Configuration
  static const int _maxPacketAge = 5000; // 5 seconds
  static const int _maxActivePackets = 100;
  static const int _cleanupInterval = 1000; // 1 second
  
  // Statistics
  int _totalPacketsReceived = 0;
  int _totalCompletePackets = 0;
  int _totalDroppedPackets = 0;
  
  // Cleanup timer
  Timer? _cleanupTimer;
  
  OmiPacketReassembler() {
    _startCleanupTimer();
  }
  
  // Getters
  Stream<List<int>> get completePackets => _completePacketController.stream;
  int get activePacketCount => _packetMetadata.length;
  int get totalPacketsReceived => _totalPacketsReceived;
  int get totalCompletePackets => _totalCompletePackets;
  int get totalDroppedPackets => _totalDroppedPackets;
  
  /// Process incoming fragmented packet from OMI device
  /// 
  /// [data] - Raw packet data with header: [ID_LSB][ID_MSB][Index][Audio_Data...]
  void processPacket(List<int> data) {
    if (data.length < 3) {
      debugPrint('OmiPacketReassembler: Packet too short: ${data.length} bytes');
      return;
    }
    
    try {
      // Extract packet header information
      final packetId = data[0] | (data[1] << 8); // 16-bit packet ID
      final fragmentIndex = data[2]; // Fragment index
      final audioData = data.sublist(3); // Audio data after header
      
      _totalPacketsReceived++;
      
      // Initialize packet buffer if needed
      _packetBuffers.putIfAbsent(packetId, () => {});
      
      // Store fragment data
      _packetBuffers[packetId]![fragmentIndex] = audioData;
      
      // Update or create packet metadata
      if (!_packetMetadata.containsKey(packetId)) {
        _packetMetadata[packetId] = PacketMetadata(
          packetId: packetId,
          timestamp: DateTime.now(),
          totalFragments: 0, // Will be updated when we determine total
        );
      }
      
      // Check if this packet is complete
      _checkPacketCompleteness(packetId);
      
      // Notify listeners of state change
      notifyListeners();
      
    } catch (e) {
      debugPrint('OmiPacketReassembler: Error processing packet: $e');
    }
  }
  
  /// Check if a packet is complete and can be reassembled
  void _checkPacketCompleteness(int packetId) {
    final buffer = _packetBuffers[packetId];
    final metadata = _packetMetadata[packetId];
    
    if (buffer == null || metadata == null) return;
    
    // Determine total fragments by finding the highest index
    final maxIndex = buffer.keys.fold(0, (max, index) => index > max ? index : max);
    metadata.totalFragments = maxIndex + 1;
    
    // Check if we have all fragments
    if (buffer.length == metadata.totalFragments) {
      // Reassemble complete packet
      final completePacket = _reassemblePacket(packetId);
      if (completePacket != null) {
        _totalCompletePackets++;
        _completePacketController.add(completePacket);
        
        // Clean up completed packet
        _cleanupPacket(packetId);
      }
    }
  }
  
  /// Reassemble a complete packet from its fragments
  List<int>? _reassemblePacket(int packetId) {
    try {
      final buffer = _packetBuffers[packetId];
      final metadata = _packetMetadata[packetId];
      
      if (buffer == null || metadata == null) return null;
      
      // Check if all fragments are present
      for (int i = 0; i < metadata.totalFragments; i++) {
        final fragment = buffer[i];
        if (fragment == null) {
          debugPrint('OmiPacketReassembler: Missing fragment $i for packet $packetId');
          return null;
        }
      }
      
      // Reassemble in order
      final completePacket = <int>[];
      for (int i = 0; i < metadata.totalFragments; i++) {
        final fragment = buffer[i]!;
        completePacket.addAll(fragment);
      }
      
      return completePacket;
      
    } catch (e) {
      debugPrint('OmiPacketReassembler: Error reassembling packet $packetId: $e');
      return null;
    }
  }
  
  /// Clean up completed or expired packets
  void _cleanupPacket(int packetId) {
    _packetBuffers.remove(packetId);
    _packetMetadata.remove(packetId);
  }
  
  /// Start cleanup timer to remove old packets
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(milliseconds: _cleanupInterval), (timer) {
      _cleanupExpiredPackets();
    });
  }
  
  /// Remove packets that are too old
  void _cleanupExpiredPackets() {
    final now = DateTime.now();
    final expiredPackets = <int>[];
    
    for (final entry in _packetMetadata.entries) {
      final age = now.difference(entry.value.timestamp).inMilliseconds;
      if (age > _maxPacketAge) {
        expiredPackets.add(entry.key);
      }
    }
    
    for (final packetId in expiredPackets) {
      debugPrint('OmiPacketReassembler: Cleaning up expired packet $packetId');
      _cleanupPacket(packetId);
      _totalDroppedPackets++;
    }
    
    // Limit active packets
    if (_packetMetadata.length > _maxActivePackets) {
      final oldestPackets = _packetMetadata.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final toRemove = oldestPackets.take(_packetMetadata.length - _maxActivePackets);
      for (final entry in toRemove) {
        debugPrint('OmiPacketReassembler: Dropping old packet ${entry.key} due to limit');
        _cleanupPacket(entry.key);
        _totalDroppedPackets++;
      }
    }
    
    if (expiredPackets.isNotEmpty || _packetMetadata.length > _maxActivePackets) {
      notifyListeners();
    }
  }
  
  /// Reset all buffers and statistics
  void reset() {
    debugPrint('OmiPacketReassembler: Resetting all buffers and statistics');
    
    _packetBuffers.clear();
    _packetMetadata.clear();
    _totalPacketsReceived = 0;
    _totalCompletePackets = 0;
    _totalDroppedPackets = 0;
    
    notifyListeners();
  }
  
  /// Get debug information
  Map<String, dynamic> getDebugInfo() {
    return {
      'activePacketCount': activePacketCount,
      'totalPacketsReceived': totalPacketsReceived,
      'totalCompletePackets': totalCompletePackets,
      'totalDroppedPackets': totalDroppedPackets,
      'maxActivePackets': _maxActivePackets,
      'maxPacketAge': _maxPacketAge,
      'cleanupInterval': _cleanupInterval,
    };
  }
  
  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _completePacketController.close();
    super.dispose();
  }
}

/// Metadata for tracking packet reassembly progress
class PacketMetadata {
  final int packetId;
  final DateTime timestamp;
  int totalFragments;
  
  PacketMetadata({
    required this.packetId,
    required this.timestamp,
    this.totalFragments = 0,
  });
}
