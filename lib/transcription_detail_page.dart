import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/nirva_api.dart';

class TranscriptionDetailPage extends StatefulWidget {
  final TranscriptionItem transcription;
  
  const TranscriptionDetailPage({
    Key? key,
    required this.transcription,
  }) : super(key: key);

  @override
  State<TranscriptionDetailPage> createState() => _TranscriptionDetailPageState();
}

class _TranscriptionDetailPageState extends State<TranscriptionDetailPage> {
  Map<String, dynamic>? _detailedData;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadDetailedData();
  }
  
  Future<void> _loadDetailedData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      if (widget.transcription.id == null) {
        throw Exception('Transcription ID is null');
      }
      
      // Use the NirvaAPI to get authenticated request
      final api = NirvaAPI();
      final detailedData = await api.getTranscriptionDetails(widget.transcription.id!);
      
      setState(() {
        _detailedData = detailedData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Widget _buildSection(String title, Widget content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildKeyValue(String key, dynamic value, {bool copyable = false}) {
    final displayValue = value?.toString() ?? 'N/A';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$key:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: copyable
                ? GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: displayValue));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayValue,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const Icon(Icons.copy, size: 14, color: Colors.grey),
                      ],
                    ),
                  )
                : Text(
                    displayValue,
                    style: const TextStyle(fontSize: 13),
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildJsonSection(String title, dynamic jsonData) {
    if (jsonData == null) {
      return _buildSection(
        title,
        const Text('No data available', style: TextStyle(color: Colors.grey)),
      );
    }
    
    final encoder = const JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(jsonData);
    
    return _buildSection(
      title,
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                prettyJson,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: prettyJson));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('JSON copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDateTime(String? isoString) {
    if (isoString == null) return 'N/A';
    try {
      final dt = DateTime.parse(isoString);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
    } catch (e) {
      return isoString;
    }
  }
  
  String _formatDuration(String? start, String? end) {
    if (start == null || end == null) return 'N/A';
    try {
      final startDt = DateTime.parse(start);
      final endDt = DateTime.parse(end);
      final duration = endDt.difference(startDt);
      return '${duration.inSeconds}.${duration.inMilliseconds % 1000} seconds';
    } catch (e) {
      return 'N/A';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcription Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDetailedData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDetailedData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildSection(
                        'Basic Information',
                        Column(
                          children: [
                            _buildKeyValue('ID', widget.transcription.id, copyable: true),
                            _buildKeyValue('Start Time', _formatDateTime(widget.transcription.start_time)),
                            _buildKeyValue('End Time', _formatDateTime(widget.transcription.end_time)),
                            _buildKeyValue('Duration', _formatDuration(widget.transcription.start_time, widget.transcription.end_time)),
                          ],
                        ),
                      ),
                      
                      // Transcription Text
                      _buildSection(
                        'Transcription Text',
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: SelectableText(
                            widget.transcription.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      
                      // Deepgram Analysis (if available)
                      if (_detailedData != null) ...[
                        // Language Detection
                        if (_detailedData!['detected_language'] != null)
                          _buildSection(
                            'Language Detection',
                            Column(
                              children: [
                                _buildKeyValue('Detected Language', _detailedData!['detected_language']),
                                _buildKeyValue('Confidence', _detailedData!['transcription_confidence']),
                              ],
                            ),
                          ),
                        
                        // Audio File Information
                        if (_detailedData!['audio_files'] != null)
                          _buildSection(
                            'Audio Files',
                            Column(
                              children: [
                                for (var file in (_detailedData!['audio_files'] as List? ?? []))
                                  Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildKeyValue('S3 Key', file['s3_key']),
                                          _buildKeyValue('Size', '${file['file_size'] ?? 0} bytes'),
                                          _buildKeyValue('Duration', '${file['duration_seconds'] ?? 0} seconds'),
                                          _buildKeyValue('Speech Segments', file['num_speech_segments']),
                                          _buildKeyValue('Speech Ratio', '${((file['speech_ratio'] ?? 0) * 100).toStringAsFixed(1)}%'),
                                          _buildKeyValue('Status', file['status']),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        
                        // Sentiment Analysis
                        if (_detailedData!['sentiment_data'] != null)
                          _buildJsonSection('Sentiment Analysis', _detailedData!['sentiment_data']),
                        
                        // Topics
                        if (_detailedData!['topics_data'] != null)
                          _buildJsonSection('Topics Detection', _detailedData!['topics_data']),
                        
                        // Intents
                        if (_detailedData!['intents_data'] != null)
                          _buildJsonSection('Intent Recognition', _detailedData!['intents_data']),
                        
                        // Batch Information
                        if (_detailedData!['batch_id'] != null)
                          _buildSection(
                            'Batch Information',
                            Column(
                              children: [
                                _buildKeyValue('Batch ID', _detailedData!['batch_id'], copyable: true),
                                _buildKeyValue('Segments Count', _detailedData!['num_segments']),
                              ],
                            ),
                          ),
                        
                        // Raw Deepgram Response (collapsed by default)
                        if (_detailedData!['raw_response'] != null)
                          ExpansionTile(
                            title: const Text(
                              'Raw Deepgram Response',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildJsonSection('', _detailedData!['raw_response']),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ),
    );
  }
}