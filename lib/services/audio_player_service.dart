import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();
  
  final Logger _logger = Logger();
  AudioPlayer? _audioPlayer;
  final Map<String, File> _cachedFiles = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  
  String? _currentlyPlayingKey;
  bool _isLoading = false;
  bool _isInitialized = false;
  
  // Cache duration - 24 hours
  static const Duration _cacheDuration = Duration(hours: 24);
  
  AudioPlayer get player {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }
  bool get isLoading => _isLoading;
  String? get currentlyPlayingKey => _currentlyPlayingKey;
  
  Future<void> init() async {
    if (_isInitialized) return;
    
    // Clean up old cache files on init
    await _cleanupOldCache();
    
    // Set up player configurations
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setPlayerMode(PlayerMode.mediaPlayer);
    _isInitialized = true;
  }
  
  /// Play audio from a presigned URL
  /// Returns true if playback started successfully
  Future<bool> playFromUrl(String presignedUrl, String s3Key) async {
    try {
      _isLoading = true;
      _currentlyPlayingKey = s3Key;
      
      // Check if we have a cached file
      File? audioFile = await _getCachedFile(s3Key);
      
      if (audioFile == null) {
        // Download and cache the file
        audioFile = await _downloadAndCacheFile(presignedUrl, s3Key);
      }
      
      if (audioFile != null) {
        // Play from local file
        await player.play(DeviceFileSource(audioFile.path));
        _logger.d('Playing audio from cache: ${audioFile.path}');
        _isLoading = false;
        return true;
      }
      
      _isLoading = false;
      return false;
    } catch (e) {
      _logger.e('Error playing audio: $e');
      _isLoading = false;
      _currentlyPlayingKey = null;
      return false;
    }
  }
  
  /// Pause playback
  Future<void> pause() async {
    try {
      if (_audioPlayer != null) {
        final state = _audioPlayer!.state;
        if (state == PlayerState.playing) {
          await _audioPlayer!.pause();
        }
      }
    } catch (e) {
      _logger.e('Error pausing audio: $e');
    }
  }
  
  /// Resume playback
  Future<void> resume() async {
    try {
      if (_audioPlayer != null) {
        final state = _audioPlayer!.state;
        if (state == PlayerState.paused) {
          await _audioPlayer!.resume();
        }
      }
    } catch (e) {
      _logger.e('Error resuming audio: $e');
    }
  }
  
  /// Stop playback
  Future<void> stop() async {
    try {
      if (_audioPlayer != null) {
        final state = _audioPlayer!.state;
        if (state != PlayerState.stopped && state != PlayerState.disposed) {
          await _audioPlayer!.stop();
        }
      }
    } catch (e) {
      _logger.e('Error stopping audio: $e');
    }
    _currentlyPlayingKey = null;
  }
  
  /// Get cached file if exists and not expired
  Future<File?> _getCachedFile(String s3Key) async {
    if (_cachedFiles.containsKey(s3Key)) {
      final file = _cachedFiles[s3Key]!;
      final timestamp = _cacheTimestamps[s3Key]!;
      
      // Check if cache is still valid (24 hours)
      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        if (await file.exists()) {
          _logger.d('Using cached audio file for: $s3Key');
          return file;
        }
      } else {
        // Cache expired, remove it
        _logger.d('Cache expired for: $s3Key');
        await _removeCachedFile(s3Key);
      }
    }
    return null;
  }
  
  /// Download audio file and cache it
  Future<File?> _downloadAndCacheFile(String url, String s3Key) async {
    try {
      _logger.d('Downloading audio from URL for key: $s3Key');
      
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final audioDir = Directory('${tempDir.path}/audio_cache');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      // Generate safe filename from s3Key
      final filename = s3Key.replaceAll('/', '_').replaceAll(' ', '_');
      final filePath = '${audioDir.path}/$filename';
      final file = File(filePath);
      
      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        
        // Cache the file reference
        _cachedFiles[s3Key] = file;
        _cacheTimestamps[s3Key] = DateTime.now();
        
        _logger.d('Audio file cached successfully: $filePath');
        return file;
      } else {
        _logger.e('Failed to download audio: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error downloading audio file: $e');
      return null;
    }
  }
  
  /// Remove a cached file
  Future<void> _removeCachedFile(String s3Key) async {
    if (_cachedFiles.containsKey(s3Key)) {
      final file = _cachedFiles[s3Key]!;
      if (await file.exists()) {
        await file.delete();
        _logger.d('Deleted cached file: ${file.path}');
      }
      _cachedFiles.remove(s3Key);
      _cacheTimestamps.remove(s3Key);
    }
  }
  
  /// Clean up old cache files (older than 24 hours)
  Future<void> _cleanupOldCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final audioDir = Directory('${tempDir.path}/audio_cache');
      
      if (await audioDir.exists()) {
        final now = DateTime.now();
        await for (final file in audioDir.list()) {
          if (file is File) {
            final stat = await file.stat();
            final age = now.difference(stat.modified);
            if (age > _cacheDuration) {
              await file.delete();
              _logger.d('Cleaned up old cache file: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      _logger.e('Error cleaning up cache: $e');
    }
  }
  
  /// Clean all cached files
  Future<void> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final audioDir = Directory('${tempDir.path}/audio_cache');
      
      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
        _logger.d('Cleared all audio cache');
      }
      
      _cachedFiles.clear();
      _cacheTimestamps.clear();
    } catch (e) {
      _logger.e('Error clearing cache: $e');
    }
  }
  
  void dispose() {
    try {
      _audioPlayer?.dispose();
      _audioPlayer = null;
      _isInitialized = false;
    } catch (e) {
      _logger.e('Error disposing audio player: $e');
    }
  }
}