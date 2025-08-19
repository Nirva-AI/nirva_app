import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nirva_app/services/app_lifecycle_logging_service.dart';

class LifecycleLogsPage extends StatefulWidget {
  const LifecycleLogsPage({super.key});

  @override
  State<LifecycleLogsPage> createState() => _LifecycleLogsPageState();
}

class _LifecycleLogsPageState extends State<LifecycleLogsPage> {
  final AppLifecycleLoggingService _loggingService = AppLifecycleLoggingService();
  String _logContent = '';
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _loggingService.initialize();
      await _refreshLogs();
      _stats = _loggingService.getCurrentStats();
    } catch (e) {
      debugPrint('Error loading logs: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshLogs() async {
    try {
      final logFilePath = _loggingService.logFilePath;
      if (logFilePath != null) {
        final file = File(logFilePath);
        if (await file.exists()) {
          final content = await file.readAsString(encoding: utf8);
          setState(() {
            _logContent = content;
          });
        } else {
          setState(() {
            _logContent = 'No log file found';
          });
        }
      } else {
        setState(() {
          _logContent = 'Log file path not available';
        });
      }
    } catch (e) {
      setState(() {
        _logContent = 'Error reading log file: $e';
      });
    }
  }

  Future<void> _clearLogs() async {
    try {
      await _loggingService.clearLog();
      await _refreshLogs();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logs cleared')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing logs: $e')),
      );
    }
  }

  Future<void> _exportLogs() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final exportPath = '${appDir.path}/lifecycle_logs_export.txt';
      final file = File(exportPath);
      await file.writeAsString(_logContent);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logs exported to: $exportPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting logs: $e')),
      );
    }
  }

  Future<void> _testLogging() async {
    try {
      await _loggingService.logCustomEvent('TEST_EVENT', {
        'description': 'This is a test event to verify logging is working',
        'testData': 'Sample data for testing',
      });
      
      await _loggingService.logMemoryWarning();
      
      await _refreshLogs();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test events logged successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error testing logging: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Lifecycle Logs'),
        backgroundColor: const Color(0xFF0E3C26),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshLogs,
            tooltip: 'Refresh logs',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
            tooltip: 'Export logs',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _testLogging,
            tooltip: 'Test logging',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Stats section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App State Statistics',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatRow('Last Known State', _stats['lastKnownState'] ?? 'Unknown'),
                      _buildStatRow('State Changes', _stats['stateChangeCount']?.toString() ?? '0'),
                      _buildStatRow('Device', _stats['deviceInfo'] ?? 'Unknown'),
                      _buildStatRow('App Version', _stats['appVersion'] ?? 'Unknown'),
                      if (_stats['logFilePath'] != null)
                        _buildStatRow('Log File', _stats['logFilePath']),
                    ],
                  ),
                ),
                // Logs section
                Expanded(
                  child: _logContent.isEmpty
                      ? const Center(
                          child: Text('No logs available'),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            _logContent,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
