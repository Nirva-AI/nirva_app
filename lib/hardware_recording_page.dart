import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/hardware_service.dart';
import 'services/hardware_audio_recorder.dart';
import 'providers/local_audio_provider.dart';
import 'models/processed_audio_result.dart';

class HardwareAudioPage extends StatefulWidget {
  const HardwareAudioPage({super.key});

  @override
  State<HardwareAudioPage> createState() => _HardwareAudioPageState();
}

class _HardwareAudioPageState extends State<HardwareAudioPage> {

  

  

  
  @override
  void initState() {
    super.initState();
    
    // Ensure local audio processing is enabled when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LocalAudioProvider>();
      if (provider.isInitialized) {
        provider.enableProcessing();
      }
    });
  }
  
  @override
  void dispose() {
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
          
          // Local transcription results
          Expanded(
            child: _buildTranscriptionResults(),
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
  Widget _buildTranscriptionResults() {
    try {
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
    } catch (e) {
      debugPrint('Error building transcription results: $e');
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text('Error loading transcriptions: $e'),
        ),
      );
    }
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
                  
                  // End time (if different from start)
                  if (speechEndTime != null && speechEndTime != speechStartTime) ...[
                    const SizedBox(height: 8),
                    Text(
                      'End: $endTimeStr',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
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
