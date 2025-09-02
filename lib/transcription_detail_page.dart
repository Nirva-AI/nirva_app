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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
  
  Widget _buildKeyValue(String key, dynamic value, {bool copyable = false}) {
    final displayValue = value?.toString() ?? 'N/A';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$key:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'Georgia',
              ),
            ),
          ),
          Expanded(
            child: copyable
                ? GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: displayValue));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF0E3C26),
                          content: const Text(
                            'Copied to clipboard',
                            style: TextStyle(fontFamily: 'Georgia'),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayValue,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0E3C26),
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.copy, size: 16, color: Colors.grey.shade400),
                      ],
                    ),
                  )
                : Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0E3C26),
                      fontFamily: 'Georgia',
                    ),
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
        Text(
          'No data available',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontFamily: 'Georgia',
          ),
        ),
      );
    }
    
    final encoder = const JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(jsonData);
    
    return _buildSection(
      title,
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                prettyJson,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: prettyJson));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF0E3C26),
                        content: const Text(
                          'JSON copied to clipboard',
                          style: TextStyle(fontFamily: 'Georgia'),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
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
      return DateFormat('MMM d, yyyy • h:mm a').format(dt.toLocal());
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
      
      if (duration.inMinutes > 0) {
        return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')} minutes';
      } else {
        return '${duration.inSeconds}.${(duration.inMilliseconds % 1000 ~/ 100)} seconds';
      }
    } catch (e) {
      return 'N/A';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: const Color(0xFFfaf9f5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0E3C26)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Transcription Details',
            style: TextStyle(
              color: Color(0xFF0E3C26),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Georgia',
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                onPressed: _loadDetailedData,
                tooltip: 'Refresh data',
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFFe7bf57),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading details...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Error loading details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E3C26),
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'Georgia',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadDetailedData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFe7bf57),
                            foregroundColor: const Color(0xFF0E3C26),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transcription Text - Featured Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFe7bf57).withOpacity(0.1),
                              const Color(0xFFe7bf57).withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFe7bf57).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe7bf57).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mic,
                                    color: Color(0xFFe7bf57),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Transcription',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0E3C26),
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SelectableText(
                              widget.transcription.text,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0E3C26),
                                fontFamily: 'Georgia',
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
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
                      
                      // Detailed Data Sections
                      if (_detailedData != null) ...[
                        // Language Detection
                        if (_detailedData!['detected_language'] != null) ...[
                          const SizedBox(height: 24),
                          _buildSection(
                            'Language Detection',
                            Column(
                              children: [
                                _buildKeyValue('Detected Language', _detailedData!['detected_language']),
                                _buildKeyValue('Confidence', '${((_detailedData!['transcription_confidence'] ?? 0) * 100).toStringAsFixed(1)}%'),
                              ],
                            ),
                          ),
                        ],
                        
                        // Audio Files
                        if (_detailedData!['audio_files'] != null && (_detailedData!['audio_files'] as List).isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSection(
                            'Audio Files',
                            Column(
                              children: [
                                for (var file in (_detailedData!['audio_files'] as List? ?? []))
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.audio_file,
                                              size: 18,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                file['s3_key']?.toString().split('/').last ?? 'Audio File',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF0E3C26),
                                                  fontFamily: 'Georgia',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _buildKeyValue('Size', '${((file['file_size'] ?? 0) / 1024).toStringAsFixed(1)} KB'),
                                        _buildKeyValue('Duration', '${file['duration_seconds'] ?? 0} seconds'),
                                        _buildKeyValue('Speech Segments', file['num_speech_segments']),
                                        _buildKeyValue('Speech Ratio', '${((file['speech_ratio'] ?? 0) * 100).toStringAsFixed(1)}%'),
                                        _buildKeyValue('Status', file['status']),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Sentiment Analysis
                        if (_detailedData!['sentiment_data'] != null) ...[
                          const SizedBox(height: 24),
                          _buildJsonSection('Sentiment Analysis', _detailedData!['sentiment_data']),
                        ],
                        
                        // Topics
                        if (_detailedData!['topics_data'] != null) ...[
                          const SizedBox(height: 24),
                          _buildJsonSection('Topics Detection', _detailedData!['topics_data']),
                        ],
                        
                        // Intents
                        if (_detailedData!['intents_data'] != null) ...[
                          const SizedBox(height: 24),
                          _buildJsonSection('Intent Recognition', _detailedData!['intents_data']),
                        ],
                        
                        // Batch Information
                        if (_detailedData!['batch_id'] != null) ...[
                          const SizedBox(height: 24),
                          _buildSection(
                            'Batch Information',
                            Column(
                              children: [
                                _buildKeyValue('Batch ID', _detailedData!['batch_id'], copyable: true),
                                _buildKeyValue('Segments Count', _detailedData!['num_segments']),
                              ],
                            ),
                          ),
                        ],
                        
                        // Raw Deepgram Response (collapsed by default)
                        if (_detailedData!['raw_response'] != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.all(20),
                                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.code,
                                      size: 20,
                                      color: Colors.orange.shade600,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Raw Deepgram Response',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade600,
                                        fontFamily: 'Georgia',
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Stack(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SelectableText(
                                            const JsonEncoder.withIndent('  ').convert(_detailedData!['raw_response']),
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.copy,
                                                size: 18,
                                                color: Colors.grey.shade600,
                                              ),
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                  text: const JsonEncoder.withIndent('  ').convert(_detailedData!['raw_response']),
                                                ));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: const Color(0xFF0E3C26),
                                                    content: const Text(
                                                      'JSON copied to clipboard',
                                                      style: TextStyle(fontFamily: 'Georgia'),
                                                    ),
                                                    duration: const Duration(seconds: 1),
                                                  ),
                                                );
                                              },
                                            ),
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
                      ],
                      
                      // Bottom padding
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}