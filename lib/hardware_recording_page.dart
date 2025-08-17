import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import 'services/hardware_service.dart';
import 'services/hardware_audio_recorder.dart';
import 'providers/local_audio_provider.dart';
import 'providers/cloud_audio_provider.dart';
import 'models/processed_audio_result.dart';
import 'services/cloud_audio_processor.dart';
import 'services/app_settings_service.dart';
import 'my_hive_objects.dart';

class HardwareAudioPage extends StatefulWidget {
  const HardwareAudioPage({super.key});

  @override
  State<HardwareAudioPage> createState() => _HardwareAudioPageState();
}

class _HardwareAudioPageState extends State<HardwareAudioPage> {

  

  

  
  @override
  void initState() {
    super.initState();
    
    // Ensure local audio processing is enabled when page loads (only if enabled in settings)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if local ASR is enabled in system settings
      final settings = context.read<AppSettingsService>();
      if (settings.localAsrEnabled) {
        // Only initialize local ASR if it's enabled in settings
        final provider = context.read<LocalAudioProvider?>();
        if (provider != null && provider.isInitialized) {
          provider.enableProcessing();
        }
      }
    });
  }
  
  @override
  void dispose() {
    // Note: Temporary file cleanup is now disabled to preserve audio files
    // Files are stored persistently for playback across app sessions
    debugPrint('HardwareRecordingPage: Audio files preserved for persistent storage');
    
    super.dispose();
  }
  

  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recording'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Audio capture controls
          _buildCaptureControls(),
          
          // Results view based on ASR mode
          Expanded(
            child: Consumer<AppSettingsService>(
              builder: (context, settings, child) {
                if (settings.localAsrEnabled) {
                  // Show only local ASR results
                  return _buildLocalTranscriptionResults();
                } else {
                  // Show only cloud ASR results
                  return _buildCloudTranscriptionResults();
                }
              },
            ),
          ),
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Connection status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: isConnected ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConnected 
                        ? 'Connected to ${device?.name ?? 'Unknown Device'}'
                        : 'No device connected',
                    style: TextStyle(
                      color: isConnected ? Colors.green[700] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ASR Mode tag
                  Consumer<AppSettingsService>(
                    builder: (context, settings, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: settings.localAsrEnabled ? Colors.blue[50] : Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: settings.localAsrEnabled ? Colors.blue[200]! : Colors.green[200]!,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              settings.localAsrEnabled ? Icons.mic : Icons.cloud,
                              color: settings.localAsrEnabled ? Colors.blue[600] : Colors.green[600],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              settings.localAsrEnabled ? 'Local' : 'Cloud',
                              style: TextStyle(
                                color: settings.localAsrEnabled ? Colors.blue[700] : Colors.green[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Recording status
              if (isCapturing) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.red[600], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Recording...',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              

              
              // Capture controls
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isConnected && !isCapturing
                          ? () => _startCapture(audioCapture)
                          : null,
                      icon: Icon(isCapturing ? Icons.fiber_manual_record : Icons.play_arrow),
                      label: Text(isCapturing ? 'Recording...' : 'Start Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCapturing ? Colors.grey[400] : Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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







  // Capture control methods
  Future<void> _startCapture(HardwareAudioCapture audioCapture) async {
    try {
      await audioCapture.startCapture();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording started'),
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
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording stopped'),
            backgroundColor: Colors.green,
          ),
        );
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



  /// Build local transcription results widget
  Widget _buildLocalTranscriptionResults() {
    return Consumer<LocalAudioProvider?>(
      builder: (context, localProvider, child) {
        if (localProvider == null) {
          return const Center(
            child: Text(
              'Local ASR is disabled in system settings.\nTo enable, modify AppSettingsService.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        
        return Selector<LocalAudioProvider, List<ProcessedAudioResult>>(
          selector: (context, provider) => provider.processingResults,
          builder: (context, results, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with language selector
                Row(
                  children: [
                    Icon(Icons.translate, color: Colors.blue[600], size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Transcription Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const Spacer(),
                    // Auto-language detection status
                    Consumer<LocalAudioProvider>(
                      builder: (context, provider, child) {
                        final currentLang = provider.currentLanguage;
                        final langNames = {'en': 'English', 'zh': '中文', 'auto': 'Auto-Detect'};
                        final langName = langNames[currentLang] ?? currentLang;
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.green[600], size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Multilingual',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        '${results.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ],
                ),
                

                const SizedBox(height: 16),
                
                // Debug status section
                Consumer<LocalAudioProvider>(
                  builder: (context, provider, child) {
                    final stats = provider.getStats();
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Debug Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatusItem('Initialized', stats['isInitialized'] ?? false),
                              const SizedBox(width: 16),
                              _buildStatusItem('Results', stats['processingResultsCount'] ?? 0),
                              const SizedBox(width: 16),
                              _buildStatusItem('Auto-Lang', stats['currentLanguage'] ?? 'unknown'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Memory usage row
                          Consumer<LocalAudioProvider>(
                            builder: (context, provider, child) {
                              final asrService = provider.asrService;
                              final memoryStats = asrService.getMemoryStats();
                              return Row(
                                children: [
                                  _buildStatusItem('Models', memoryStats['recognizersLoaded'] ?? 0),
                                  const SizedBox(width: 16),
                                  _buildStatusItem('Mode', 'Multilingual'),
                                  const SizedBox(width: 16),
                                  _buildStatusItem('Language', memoryStats['currentLanguage'] ?? 'auto'),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          // Action buttons row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  provider.enableProcessing();
                                  setState(() {});
                                },
                                icon: Icon(Icons.refresh, size: 16),
                                label: Text('Refresh', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  minimumSize: Size(0, 32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Results list
                if (results.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transcriptions yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start recording to see real-time transcriptions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result = results[results.length - 1 - index]; // Show newest first
                        return _buildTranscriptionResultItem(result);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

  /// Build individual transcription result item
  Widget _buildTranscriptionResultItem(ProcessedAudioResult result) {
    // Calculate timing information
    final hasSpeechSegment = result.speechSegment != null;
    final speechStartTime = hasSpeechSegment ? result.speechSegment!.startTime : null;
    final speechEndTime = hasSpeechSegment ? result.speechSegment!.endTime : null;
    
    // Format timestamps for timeline display
    final startTimeStr = speechStartTime != null 
        ? '${speechStartTime.inMinutes.toString().padLeft(2, '0')}:${(speechStartTime.inSeconds % 60).toString().padLeft(2, '0')}'
        : '00:00';
    
    final endTimeStr = speechEndTime != null 
        ? '${speechEndTime.inMinutes.toString().padLeft(2, '0')}:${(speechEndTime.inSeconds % 60).toString().padLeft(2, '0')}'
        : '00:00';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline timestamp
          Container(
            width: 60,
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              startTimeStr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontFamily: 'monospace',
              ),
            ),
          ),
          
          // Timeline connector
          Container(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: result.isFinalResult ? Colors.green : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          
          // Transcription content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: result.isFinalResult ? Colors.green[200]! : Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transcription text
                  Text(
                    result.transcription.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  
                  // Language indicator
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: result.transcription.language == 'zh' ? Colors.orange[50] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: result.transcription.language == 'zh' ? Colors.orange[200]! : Colors.blue[200]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language,
                          size: 12,
                          color: result.transcription.language == 'zh' ? Colors.orange[600] : Colors.blue[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          result.transcription.language == 'zh' ? '中文 (Auto)' : 'English (Auto)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: result.transcription.language == 'zh' ? Colors.orange[600] : Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build cloud transcription results widget
  Widget _buildCloudTranscriptionResults() {
    return Consumer<CloudAudioProvider?>(
      builder: (context, cloudProvider, child) {
        if (cloudProvider == null) {
          return const Center(
            child: Text(
              'Cloud ASR is disabled in system settings.\nTo enable, modify AppSettingsService.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // Tab bar
              Container(
                color: Colors.grey[100],
                child: TabBar(
                  labelColor: Colors.blue[700],
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.blue[700],
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.cloud_queue),
                      text: 'Current Session',
                    ),
                    Tab(
                      icon: Icon(Icons.history),
                      text: 'All Results',
                    ),
                  ],
                ),
              ),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  children: [
                    // Current session results
                    _buildCurrentSessionResults(cloudProvider),
                    // Persistent results
                    _buildPersistentResults(cloudProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build current session results tab
  Widget _buildCurrentSessionResults(CloudAudioProvider cloudProvider) {
    return Selector<CloudAudioProvider, List<CloudAudioResult>>(
      selector: (context, provider) => provider.cloudProcessor.transcriptionResults,
      builder: (context, results, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.cloud_queue, color: Colors.blue[600], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Current Session',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${results.length} results',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Results list
              if (results.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No current transcriptions',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start recording to see real-time transcriptions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[results.length - 1 - index]; // Show newest first
                      
                      return _buildCloudTranscriptionResultItem(result);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build persistent results tab
  Widget _buildPersistentResults(CloudAudioProvider cloudProvider) {
    return Selector<CloudAudioProvider, List<CloudAsrResultStorage>>(
      selector: (context, provider) {
        final results = provider.persistentResults;
        debugPrint('HardwareRecordingPage: Selector called - provider.isInitialized: ${provider.isInitialized}');
        debugPrint('HardwareRecordingPage: Selector called - results length: ${results.length}');
        if (results.isNotEmpty) {
          debugPrint('HardwareRecordingPage: Selector called - first result transcription: "${results.first.transcription}"');
        }
        return results;
      },
      builder: (context, results, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with storage stats
              Row(
                children: [
                  Icon(Icons.history, color: Colors.green[600], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'All Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const Spacer(),
                  Consumer<CloudAudioProvider>(
                    builder: (context, provider, child) {
                      final stats = provider.storageStats;
                      final totalMB = stats['totalAudioSizeMB'] ?? '0';
                      return Text(
                        '${results.length} results • ${totalMB} MB',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Results list
              if (results.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stored transcriptions',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Transcriptions will appear here after processing',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      
                      // Debug: Log what's being displayed
                      debugPrint('HardwareRecordingPage: Displaying result ${result.id} - transcription length: ${result.transcription?.length ?? 0}');
                      debugPrint('HardwareRecordingPage: Displaying transcription: "${result.transcription}"');
                      
                      // Debug: Check if transcription is truncated
                      if (result.transcription != null && result.transcription!.length > 100) {
                        debugPrint('HardwareRecordingPage: Long transcription detected - first 100 chars: "${result.transcription!.substring(0, 100)}..."');
                        debugPrint('HardwareRecordingPage: Long transcription detected - last 100 chars: "...${result.transcription!.substring(result.transcription!.length - 100)}"');
                      }
                      
                      return _buildPersistentTranscriptionResultItem(result);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build individual cloud transcription result item
  Widget _buildCloudTranscriptionResultItem(CloudAudioResult result) {
    // Format timestamps for timeline display
    final startTimeStr = '${result.startTime.hour.toString().padLeft(2, '0')}:${result.startTime.minute.toString().padLeft(2, '0')}:${result.startTime.second.toString().padLeft(2, '0')}';
    final endTimeStr = '${result.endTime.hour.toString().padLeft(2, '0')}:${result.endTime.minute.toString().padLeft(2, '0')}:${result.endTime.second.toString().padLeft(2, '0')}';
    final durationStr = '${result.duration.inSeconds}s';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline timestamp
          Container(
            width: 80,
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              children: [
                Text(
                  startTimeStr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  durationStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          // Timeline connector
          Container(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: result.isFinal ? Colors.green : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          
          // Transcription content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: result.isFinal ? Colors.green[200]! : Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transcription text
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.transcription ?? 'Processing...',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        // Debug: Show full transcription in expandable section
                        if (result.transcription != null && result.transcription!.length > 100) ...[
                          const SizedBox(height: 8),
                          ExpansionTile(
                            title: Text(
                              'Show Full Transcription (${result.transcription!.length} chars)',
                              style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                            ),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: SelectableText(
                                  result.transcription!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Debug: Show transcription length
                  if (result.transcription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Length: ${result.transcription!.length} characters',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  // Audio playback button (only show if we have a file path)
                  if (result.audioFilePath != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        StreamBuilder<PlayerState>(
                          stream: context.read<CloudAudioProvider?>()?.audioPlayerStateStream,
                          builder: (context, snapshot) {
                            final isPlaying = snapshot.data == PlayerState.playing;
                            final provider = context.read<CloudAudioProvider?>();
                            final canPlayAudio = provider?.isAudioPlaybackAvailable ?? false;
                            
                            // debugPrint('HardwareRecordingPage: Audio playback status (current session) - canPlayAudio: $canPlayAudio, isPlaying: $isPlaying');
                            
                            return ElevatedButton.icon(
                              onPressed: canPlayAudio ? () {
                                if (isPlaying) {
                                  debugPrint('HardwareRecordingPage: Stopping audio playback (current session)');
                                  provider?.stopAudioPlayback();
                                } else {
                                  debugPrint('HardwareRecordingPage: Starting audio playback for (current session): ${result.audioFilePath}');
                                  provider?.playAudioFile(result.audioFilePath!);
                                }
                              } : null, // Disable button if audio playback not available
                              icon: Icon(
                                isPlaying ? Icons.stop : Icons.play_arrow,
                                size: 16,
                              ),
                              label: Text(
                                isPlaying ? 'Stop' : 'Play Audio',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: Size(0, 28),
                                backgroundColor: isPlaying ? Colors.red[100] : Colors.blue[100],
                                foregroundColor: isPlaying ? Colors.red[700] : Colors.blue[700],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build individual persistent transcription result item
  Widget _buildPersistentTranscriptionResultItem(CloudAsrResultStorage result) {
    // Format timestamps for display
    final startTime = DateTime.parse(result.startTimeIso);
    final endTime = DateTime.parse(result.endTimeIso);
    final processingTime = DateTime.parse(result.processingTimeIso);
    
    final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}';
    final dateStr = '${startTime.month}/${startTime.day}/${startTime.year}';
    final durationStr = '${result.durationMs ~/ 1000}s';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and time info
          Container(
            width: 90,
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  startTimeStr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  durationStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          // Status indicator
          Container(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: result.isFinal ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          
          // Transcription content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: result.isFinal ? Colors.green[200]! : Colors.orange[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transcription text
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.transcription ?? 'No transcription available',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        // Debug: Show full transcription in expandable section
                        if (result.transcription != null && result.transcription!.length > 100) ...[
                          const SizedBox(height: 8),
                          ExpansionTile(
                            title: Text(
                              'Show Full Transcription (${result.transcription!.length} chars)',
                              style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                            ),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: SelectableText(
                                  result.transcription!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Debug: Show transcription length
                  if (result.transcription != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Length: ${result.transcription!.length} characters',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  // Metadata row
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Language indicator
                      if (result.language != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: result.language == 'zh' ? Colors.orange[50] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: result.language == 'zh' ? Colors.orange[200]! : Colors.blue[200]!,
                            ),
                          ),
                          child: Text(
                            result.language == 'zh' ? '中文' : 'English',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: result.language == 'zh' ? Colors.orange[600] : Colors.blue[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      
                      // Confidence indicator
                      if (result.confidence != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            '${(result.confidence! * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      
                      // Audio file size
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          '${(result.audioDataSize / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Audio playback button (only show if we have a file path)
                  if (result.audioFilePath != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        StreamBuilder<PlayerState>(
                          stream: context.read<CloudAudioProvider?>()?.audioPlayerStateStream,
                          builder: (context, snapshot) {
                            final isPlaying = snapshot.data == PlayerState.playing;
                            return ElevatedButton.icon(
                              onPressed: () {
                                if (isPlaying) {
                                  context.read<CloudAudioProvider?>()?.stopAudioPlayback();
                                } else {
                                  context.read<CloudAudioProvider?>()?.playAudioFile(result.audioFilePath!);
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.stop : Icons.play_arrow,
                                size: 16,
                              ),
                              label: Text(
                                isPlaying ? 'Stop' : 'Play Audio',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: Size(0, 28),
                                backgroundColor: isPlaying ? Colors.red[100] : Colors.blue[100],
                                foregroundColor: isPlaying ? Colors.red[700] : Colors.blue[700],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, dynamic value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

}
