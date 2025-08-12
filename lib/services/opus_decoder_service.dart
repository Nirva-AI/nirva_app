import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter/opus_flutter.dart' as opus_flutter;

/// Service for decoding Opus audio data from OMI device
/// 
/// Converts Opus-encoded audio to PCM format for playback
class OpusDecoderService extends ChangeNotifier {
  // Opus decoder instance
  SimpleOpusDecoder? _decoder;
  
  // Decoder state
  bool _isInitialized = false;
  bool _isDecoding = false;
  
  // Configuration (matching OMI firmware)
  static const int _sampleRate = 16000;  // 16 kHz as per OMI firmware
  static const int _channels = 1;         // Mono audio
  static const int _frameSize = 160;      // 10ms frames (16000Hz / 160 = 100Hz)
  
  // Statistics
  int _totalPacketsDecoded = 0;
  int _totalBytesDecoded = 0;
  int _failedDecodes = 0;
  
  // Stream controller for decoded PCM data
  final StreamController<Uint8List> _decodedAudioController = 
      StreamController<Uint8List>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isDecoding => _isDecoding;
  Stream<Uint8List> get decodedAudio => _decodedAudioController.stream;
  
  // Statistics getters
  int get totalPacketsDecoded => _totalPacketsDecoded;
  int get totalBytesDecoded => _totalBytesDecoded;
  int get failedDecodes => _failedDecodes;
  double get successRate => _totalPacketsDecoded > 0 
      ? (_totalPacketsDecoded - _failedDecodes) / _totalPacketsDecoded 
      : 0.0;
  
  /// Initialize the Opus decoder
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('OpusDecoderService: Already initialized');
      return true;
    }
    
    try {
      debugPrint('OpusDecoderService: Initializing Opus decoder...');
      
      // Initialize the opus library first
      debugPrint('OpusDecoderService: Initializing opus library...');
      try {
        // Use opus_flutter to load the native Opus library
        debugPrint('OpusDecoderService: Loading native Opus library via opus_flutter...');
        final opusLib = await opus_flutter.load();
        initOpus(opusLib);
        debugPrint('OpusDecoderService: Opus library initialized successfully via opus_flutter');
      } catch (e) {
        debugPrint('OpusDecoderService: Failed to initialize opus library: $e');
        debugPrint('  - Error details: $e');
        return false;
      }
      
      // Create Opus decoder with OMI firmware parameters
      _decoder = SimpleOpusDecoder(
        sampleRate: _sampleRate,
        channels: _channels,
      );
      
      _isInitialized = true;
      debugPrint('OpusDecoderService: Opus decoder initialized successfully');
      debugPrint('  - Sample Rate: $_sampleRate Hz');
      debugPrint('  - Channels: $_channels');
      debugPrint('  - Frame Size: $_frameSize samples');
      
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('OpusDecoderService: Failed to initialize Opus decoder: $e');
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Decode Opus audio data to PCM
  /// 
  /// [opusData] - Raw Opus-encoded audio data from OMI device
  /// Returns decoded PCM audio data or null if decoding fails
  Uint8List? decodeOpus(List<int> opusData) {
    if (!_isInitialized) {
      debugPrint('OpusDecoderService: Cannot decode - decoder not initialized');
      debugPrint('  - _isInitialized: $_isInitialized');
      debugPrint('  - _decoder: ${_decoder != null ? 'exists' : 'null'}');
      return null;
    }
    
    if (_decoder == null) {
      debugPrint('OpusDecoderService: Cannot decode - decoder instance is null');
      return null;
    }
    
    if (opusData.isEmpty) {
      debugPrint('OpusDecoderService: Cannot decode empty data');
      return null;
    }
    
    try {
      _isDecoding = true;
      notifyListeners();
      
      debugPrint('OpusDecoderService: Decoding ${opusData.length} bytes of Opus data');
      debugPrint('  - Sample rate: $_sampleRate Hz');
      debugPrint('  - Channels: $_channels');
      debugPrint('  - Frame size: $_frameSize');
      
      // Decode Opus data to PCM using the correct API
      final pcmData = _decoder!.decode(input: Uint8List.fromList(opusData));
      
      if (pcmData.isNotEmpty) {
        // Convert Int16List to Uint8List for consistency
        final pcmBytes = Uint8List(pcmData.length * 2);
        final pcmBuffer = pcmBytes.buffer.asByteData();
        
        for (int i = 0; i < pcmData.length; i++) {
          pcmBuffer.setInt16(i * 2, pcmData[i], Endian.little);
        }
        
        // Update statistics
        _totalPacketsDecoded++;
        _totalBytesDecoded += pcmBytes.length;
        
        debugPrint('OpusDecoderService: Successfully decoded ${opusData.length} bytes to ${pcmBytes.length} bytes PCM');
        debugPrint('  - PCM samples: ${pcmData.length}');
        debugPrint('  - PCM bytes: ${pcmBytes.length}');
        
        // Broadcast decoded audio
        _decodedAudioController.add(pcmBytes);
        
        return pcmBytes;
      } else {
        _failedDecodes++;
        debugPrint('OpusDecoderService: Decoding returned empty data');
        return null;
      }
      
    } catch (e) {
      _failedDecodes++;
      debugPrint('OpusDecoderService: Error decoding Opus data: $e');
      debugPrint('  - Stack trace: ${StackTrace.current}');
      return null;
    } finally {
      _isDecoding = false;
      notifyListeners();
    }
  }
  
  /// Decode multiple Opus packets in sequence
  /// 
  /// [opusPackets] - List of Opus-encoded audio packets
  /// Returns list of decoded PCM audio data
  List<Uint8List> decodeMultiplePackets(List<List<int>> opusPackets) {
    if (!_isInitialized || _decoder == null) {
      debugPrint('OpusDecoderService: Cannot decode - decoder not initialized');
      return [];
    }
    
    final decodedPackets = <Uint8List>[];
    
    for (final packet in opusPackets) {
      final decoded = decodeOpus(packet);
      if (decoded != null) {
        decodedPackets.add(decoded);
      }
    }
    
    debugPrint('OpusDecoderService: Decoded ${decodedPackets.length}/${opusPackets.length} packets');
    return decodedPackets;
  }
  
  /// Convert PCM data to WAV format for file saving
  /// 
  /// [pcmData] - Raw PCM audio data
  /// [sampleRate] - Audio sample rate (default: OMI firmware rate)
  /// [channels] - Number of audio channels (default: mono)
  /// [bitDepth] - Audio bit depth (default: 16-bit)
  /// Returns WAV file bytes
  Uint8List convertPcmToWav(
    Uint8List pcmData, {
    int sampleRate = _sampleRate,
    int channels = _channels,
    int bitDepth = 16,
  }) {
    try {
      debugPrint('OpusDecoderService: Converting ${pcmData.length} bytes PCM to WAV format');
      
      // WAV file header (44 bytes)
      final header = _createWavHeader(
        pcmData.length,
        sampleRate: sampleRate,
        channels: channels,
        bitDepth: bitDepth,
      );
      
      // Combine header and PCM data
      final wavData = Uint8List(header.length + pcmData.length);
      wavData.setRange(0, header.length, header);
      wavData.setRange(header.length, wavData.length, pcmData);
      
      debugPrint('OpusDecoderService: WAV conversion complete - ${wavData.length} bytes');
      return wavData;
      
    } catch (e) {
      debugPrint('OpusDecoderService: Error converting PCM to WAV: $e');
      return Uint8List(0);
    }
  }
  
  /// Create WAV file header
  Uint8List _createWavHeader(
    int pcmDataSize, {
    required int sampleRate,
    required int channels,
    required int bitDepth,
  }) {
    final header = ByteData(44);
    
    // RIFF header
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    
    // File size (4 bytes) - total file size minus 8 bytes
    header.setUint32(4, 36 + pcmDataSize, Endian.little);
    
    // WAVE identifier
    header.setUint8(8, 0x57);  // 'W'
    header.setUint8(9, 0x41);  // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'
    
    // fmt chunk
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    
    // fmt chunk size (16 bytes)
    header.setUint32(16, 16, Endian.little);
    
    // Audio format (1 = PCM)
    header.setUint16(20, 1, Endian.little);
    
    // Number of channels
    header.setUint16(22, channels, Endian.little);
    
    // Sample rate
    header.setUint32(24, sampleRate, Endian.little);
    
    // Byte rate (sample rate * channels * bits per sample / 8)
    final byteRate = sampleRate * channels * bitDepth ~/ 8;
    header.setUint32(28, byteRate, Endian.little);
    
    // Block align (channels * bits per sample / 8)
    final blockAlign = channels * bitDepth ~/ 8;
    header.setUint16(32, blockAlign, Endian.little);
    
    // Bits per sample
    header.setUint16(34, bitDepth, Endian.little);
    
    // data chunk
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    
    // data chunk size
    header.setUint32(40, pcmDataSize, Endian.little);
    
    return header.buffer.asUint8List();
  }
  
  /// Reset decoder statistics
  void resetStatistics() {
    _totalPacketsDecoded = 0;
    _totalBytesDecoded = 0;
    _failedDecodes = 0;
    notifyListeners();
  }
  
  /// Get debug information about decoder state
  Map<String, dynamic> getDebugInfo() {
    return {
      'isInitialized': _isInitialized,
      'isDecoding': _isDecoding,
      'totalPacketsDecoded': _totalPacketsDecoded,
      'totalBytesDecoded': _totalBytesDecoded,
      'failedDecodes': _failedDecodes,
      'successRate': successRate,
      'sampleRate': _sampleRate,
      'channels': _channels,
      'frameSize': _frameSize,
    };
  }
  
  /// Dispose of resources
  @override
  void dispose() {
    _decoder?.destroy();
    _decodedAudioController.close();
    super.dispose();
  }
}
