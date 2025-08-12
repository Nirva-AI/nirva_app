import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';

import 'services/hardware_service.dart';
import 'services/hardware_audio_recorder.dart';
import 'services/audio_streaming_service.dart';

class HardwareAudioPage extends StatefulWidget {
  const HardwareAudioPage({super.key});

  @override
  State<HardwareAudioPage> createState() => _HardwareAudioPageState();
}

class _HardwareAudioPageState extends State<HardwareAudioPage> {
  List<FileSystemEntity> _capturedFiles = [];
  bool _isLoadingFiles = false;
  
  // Audio playback state
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingFile;
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  
  // File rotation countdown timer
  Timer? _countdownTimer;
  Duration _nextRotationCountdown = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _loadCapturedFiles();
    _setupAudioPlayer();
    _startCountdownTimer();
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  void _setupAudioPlayer() {
    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
    
    // Listen to audio duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });
    
    // Listen to audio position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
    
    // Listen to audio completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentlyPlayingFile = null;
          _currentPosition = Duration.zero;
        });
      }
    });
  }
  
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final audioCapture = context.read<HardwareAudioCapture>();
        if (audioCapture.isCapturing) {
          final captureDuration = audioCapture.captureDuration;
          final nextRotation = Duration(seconds: 10) - Duration(seconds: captureDuration.inSeconds % 10);
          setState(() {
            _nextRotationCountdown = nextRotation;
          });
        }
      }
    });
  }

  Future<void> _loadCapturedFiles() async {
    setState(() {
      _isLoadingFiles = true;
    });

    try {
      final hardwareService = context.read<HardwareService>();
      final audioCapture = HardwareAudioCapture(hardwareService);
      final files = await audioCapture.getCapturedFiles();
      
      setState(() {
        _capturedFiles = files;
        _isLoadingFiles = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFiles = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading captured files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hardware Audio Recording'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCapturedFiles,
            tooltip: 'Refresh Files',
          ),
        ],
      ),
      body: Column(
        children: [
          // Global audio player controls (when audio is playing)
          if (_isPlaying && _currentlyPlayingFile != null)
            _buildGlobalAudioControls(),
          
          // Audio capture controls
          _buildCaptureControls(),
          
          // Capture statistics summary
          _buildCaptureStatistics(),
          
          // Audio streaming status
          _buildStreamingStatus(),
          
          // Captured files list
          Expanded(
            child: _buildCapturedFilesList(),
          ),
        ],
      ),
    );
  }

  /// Build global audio player controls bar
  Widget _buildGlobalAudioControls() {
    final fileName = _currentlyPlayingFile!.split('/').last;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(color: Colors.blue[200]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header with filename and controls
          Row(
            children: [
              Icon(Icons.music_note, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Now Playing: $fileName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Playback controls
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _isPlaying ? _pauseAudio : _resumeAudio,
                tooltip: _isPlaying ? 'Pause' : 'Resume',
                color: Colors.blue[700],
                iconSize: 24,
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: _stopAudio,
                tooltip: 'Stop',
                color: Colors.red[700],
                iconSize: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          if (_audioDuration > Duration.zero) ...[
            LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) => _onProgressBarTap(details, constraints.maxWidth),
                  child: LinearProgressIndicator(
                    value: _audioDuration.inMilliseconds > 0 
                        ? _currentPosition.inMilliseconds / _audioDuration.inMilliseconds 
                        : 0.0,
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            // Time display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(_audioDuration),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Consumer2<HardwareService, HardwareAudioCapture>(
      builder: (context, hardwareService, audioCapture, child) {
        final isConnected = hardwareService.isConnected;
        final isCapturing = audioCapture.isCapturing;
        final device = hardwareService.connectedDevice;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection status
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: isConnected ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConnected 
                        ? 'Connected to ${device?.name ?? 'Unknown Device'}'
                        : 'No device connected',
                    style: TextStyle(
                      color: isConnected ? Colors.green[700] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Capture controls
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isConnected && !isCapturing
                          ? () => _startCapture(audioCapture)
                          : null,
                      icon: const Icon(Icons.fiber_manual_record),
                      label: const Text('Start Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isConnected && isCapturing
                          ? () => _stopCapture(audioCapture)
                          : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCaptureStatistics() {
    return Consumer<HardwareAudioCapture>(
      builder: (context, audioCapture, child) {
        if (!audioCapture.isCapturing) return const SizedBox.shrink();
        
        final duration = audioCapture.captureDuration;
        final nextRotation = _nextRotationCountdown;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(
              bottom: BorderSide(color: Colors.blue[200]!, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Recording in Progress',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Recording Time',
                      _formatDuration(duration),
                      Icons.access_time,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Next File Rotation',
                      _formatDuration(nextRotation),
                      Icons.rotate_right,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCapturedFilesList() {
    if (_isLoadingFiles) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_capturedFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audio_file,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No audio files captured yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start recording to capture audio from your hardware device',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _capturedFiles.length,
      itemBuilder: (context, index) {
        final file = _capturedFiles[index];
        final fileName = file.path.split('/').last;
        final fileSize = _formatFileSize(file.statSync().size);
        final modifiedTime = file.statSync().modified;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              Icons.audio_file,
              color: Colors.blue[600],
              size: 32,
            ),
            title: Text(
              fileName,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Size: $fileSize'),
                Text('Modified: ${_formatDateTime(modifiedTime)}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _currentlyPlayingFile == file.path && _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () => _playAudioFile(file.path),
                  tooltip: 'Play',
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareAudioFile(file.path),
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteAudioFile(file.path),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Audio playback methods
  Future<void> _playAudioFile(String filePath) async {
    try {
      if (_currentlyPlayingFile == filePath && _isPlaying) {
        await _pauseAudio();
        return;
      }
      
      if (_currentlyPlayingFile != filePath) {
        await _stopAudio();
        await _audioPlayer.play(DeviceFileSource(filePath));
        setState(() {
          _currentlyPlayingFile = filePath;
        });
      } else {
        await _resumeAudio();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _resumeAudio() async {
    await _audioPlayer.resume();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _currentlyPlayingFile = null;
      _currentPosition = Duration.zero;
    });
  }

  void _onProgressBarTap(TapDownDetails details, double maxWidth) {
    final relativePosition = details.localPosition.dx / maxWidth;
    final newPosition = Duration(
      milliseconds: (relativePosition * _audioDuration.inMilliseconds).round(),
    );
    _audioPlayer.seek(newPosition);
  }

  // Capture control methods
  Future<void> _startCapture(HardwareAudioCapture audioCapture) async {
    try {
      await audioCapture.startCapture();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio recording started'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopCapture(HardwareAudioCapture audioCapture) async {
    try {
      debugPrint('HardwareRecordingPage: Stopping capture...');
      await audioCapture.stopCapture();
      
      // Wait a moment for the state to update
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if it's truly stopped
      if (audioCapture.isTrulyStopped) {
        debugPrint('HardwareRecordingPage: Capture successfully stopped');
        await _loadCapturedFiles(); // Refresh the file list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audio recording stopped - WAV file saved'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        debugPrint('HardwareRecordingPage: Warning - Capture may not be fully stopped');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audio recording stopped (checking status...)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('HardwareRecordingPage: Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Utility methods
  Future<void> _shareAudioFile(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)], text: 'Audio file from hardware device');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteAudioFile(String filePath) async {
    try {
      final hardwareService = context.read<HardwareService>();
      final audioCapture = HardwareAudioCapture(hardwareService);
      final success = await audioCapture.deleteCapturedFile(filePath);
      
      if (success) {
        await _loadCapturedFiles(); // Refresh the file list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audio file deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete audio file'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Build audio streaming status widget
  Widget _buildStreamingStatus() {
    return Consumer<AudioStreamingService>(
      builder: (context, streamingService, child) {
        final stats = streamingService.getStats();
        final isUploading = stats['isUploading'] as bool;
        final uploadedCount = stats['uploadedFilesCount'] as int;
        final errorCount = stats['uploadErrorsCount'] as int;
        final processedCount = stats['processedFilesCount'] as int;
        final isFileWatcherActive = stats['isFileWatcherActive'] as bool;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            border: Border(
              bottom: BorderSide(color: Colors.purple[200]!, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isFileWatcherActive ? Icons.cloud_upload : Icons.cloud_off,
                    color: isFileWatcherActive ? Colors.purple[700] : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Audio Streaming Status',
                    style: TextStyle(
                      color: Colors.purple[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (isUploading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStreamingStatItem(
                      'Uploaded',
                      uploadedCount.toString(),
                      Icons.cloud_done,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStreamingStatItem(
                      'Processed',
                      processedCount.toString(),
                      Icons.check_circle,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStreamingStatItem(
                      'Errors',
                      errorCount.toString(),
                      Icons.error,
                      errorCount > 0 ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isUploading ? null : () {
                        streamingService.processAllExistingFiles();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Process All Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        foregroundColor: Colors.purple[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        streamingService.clearHistory();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear History'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[700],
                        side: BorderSide(color: Colors.purple[300]!),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreamingStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
