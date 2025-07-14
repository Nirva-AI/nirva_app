import 'package:flutter/material.dart';
import 'package:nirva_app/my_hive_objects.dart';
import 'package:nirva_app/app_service.dart';
import 'package:nirva_app/update_data_task.dart';

class HiveDataViewerPage extends StatefulWidget {
  const HiveDataViewerPage({super.key});

  @override
  State<HiveDataViewerPage> createState() => _HiveDataViewerPageState();
}

class _HiveDataViewerPageState extends State<HiveDataViewerPage> {
  Map<String, dynamic> _hiveData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHiveData();
  }

  Future<void> _loadHiveData() async {
    setState(() {
      _isLoading = true;
    });

    final data = AppService().hiveManager.getAllData();

    setState(() {
      _hiveData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Data Manager'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHiveData),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildDataView(),
    );
  }

  Widget _buildDataView() {
    if (_hiveData.isEmpty) {
      return const Center(child: Text('No Hive data stored'));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildDataCard('Favorites Data', _hiveData['favorites']),
        const SizedBox(height: 16),
        _buildDataCard('User Token', _hiveData['userToken'], isToken: true),
        const SizedBox(height: 16),
        _buildDataCard(
          'Journal Index',
          _hiveData['journalIndex'],
          isJournalIndex: true,
        ),
        const SizedBox(height: 16),
        _buildDataCard(
          'Update Data Task',
          _hiveData['updateDataTask'],
          isUpdateDataTask: true,
        ),
      ],
    );
  }

  Widget _buildDataCard(
    String title,
    dynamic data, {
    bool isToken = false,
    bool isJournalIndex = false,
    bool isUpdateDataTask = false,
  }) {
    if (data == null) {
      return Card(
        child: ListTile(
          title: Text(title),
          subtitle: const Text('No data available'),
        ),
      );
    }

    Widget dataWidget;

    if (isToken) {
      // 用户令牌数据展示
      final token = data as UserToken;
      dataWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('access_token: ${_truncateText(token.access_token)}'),
          const SizedBox(height: 8),
          Text('token_type: ${token.token_type}'),
          const SizedBox(height: 8),
          Text('refresh_token: ${_truncateText(token.refresh_token)}'),
        ],
      );
    } else if (data is Favorites) {
      // 收藏夹数据展示
      dataWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Favorite count: ${data.favoriteIds.length}'),
          const SizedBox(height: 8),
          if (data.favoriteIds.isNotEmpty) ...[
            const Text('Favorite IDs:'),
            ...data.favoriteIds.map(
              (id) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(id),
              ),
            ),
          ],
        ],
      );
    } else if (isJournalIndex) {
      // 日记索引数据展示
      final journalIndex = data as JournalFileIndex;
      final journalCount = _hiveData['journalCount'] ?? 0;
      final filesCount = _hiveData['journalFilesCount'] ?? 0;

      dataWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal index count: $journalCount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Stored files count: $filesCount'),
          const SizedBox(height: 12),
          if (journalIndex.files.isNotEmpty) ...[
            const Text(
              'Journal files list:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...journalIndex.files.map(
              (file) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(file.fileName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteJournalFile(file.fileName),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    } else if (isUpdateDataTask) {
      // UpdateDataTask 数据展示
      final updateDataTask = data as UpdateDataTaskStorage;
      final status = UpdateDataTaskStatus.values[updateDataTask.statusValue];
      final creationTime = DateTime.parse(updateDataTask.creationTimeIso);

      dataWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User ID: ${updateDataTask.userId}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Task ID: ${updateDataTask.id}'),
          const SizedBox(height: 8),
          Text('Status: ${status.toString().split('.').last}'),
          const SizedBox(height: 8),
          Text('Creation Time: ${creationTime.toString()}'),
          const SizedBox(height: 8),
          Text('Asset Files: ${updateDataTask.assetFileNames.length}'),
          if (updateDataTask.assetFileNames.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...updateDataTask.assetFileNames.map(
              (fileName) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: Text('• $fileName'),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text('Picked Files: ${updateDataTask.pickedFileNames.length}'),
          if (updateDataTask.pickedFileNames.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...updateDataTask.pickedFileNames.map(
              (fileName) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: Text('• $fileName'),
              ),
            ),
          ],
          if (updateDataTask.transcriptFilePath != null) ...[
            const SizedBox(height: 8),
            Text('Transcript Path: ${updateDataTask.transcriptFilePath}'),
          ],
          if (updateDataTask.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              'Error: ${updateDataTask.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          ],
          if (updateDataTask.uploadAndTranscribeTaskStorage != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Upload & Transcribe Task:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildSubTaskWidget(updateDataTask.uploadAndTranscribeTaskStorage!),
          ],
          if (updateDataTask.analyzeTaskStorage != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Analyze Task:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildAnalyzeTaskWidget(updateDataTask.analyzeTaskStorage!),
          ],
        ],
      );
    } else {
      // 其他类型数据展示
      dataWidget = Text(data.toString());
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            dataWidget,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _deleteData(title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建 UploadAndTranscribeTaskStorage 的显示组件
  Widget _buildSubTaskWidget(UploadAndTranscribeTaskStorage task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task ID: ${task.taskId}'),
          const SizedBox(height: 4),
          Text('User ID: ${task.userId}'),
          const SizedBox(height: 4),
          Text('Created: ${DateTime.parse(task.creationTimeIso)}'),
          const SizedBox(height: 4),
          Text('Is Uploaded: ${task.isUploaded}'),
          const SizedBox(height: 4),
          Text('Is Transcribed: ${task.isTranscribed}'),
          const SizedBox(height: 4),
          Text('Asset Files: ${task.assetFileNames.length}'),
          const SizedBox(height: 4),
          Text('Uploaded Files: ${task.uploadedFileNames.length}'),
        ],
      ),
    );
  }

  // 构建 AnalyzeTaskStorage 的显示组件
  Widget _buildAnalyzeTaskWidget(AnalyzeTaskStorage task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task ID: ${task.id}'),
          const SizedBox(height: 4),
          Text('File Name: ${task.fileName}'),
          const SizedBox(height: 4),
          Text('Date Key: ${task.dateKey}'),
          const SizedBox(height: 4),
          Text('Status: ${task.statusValue}'),
          const SizedBox(height: 4),
          Text('Content Length: ${task.content.length} chars'),
          if (task.analyzeTaskId != null) ...[
            const SizedBox(height: 4),
            Text('Analyze Task ID: ${task.analyzeTaskId}'),
          ],
          if (task.errorMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error: ${task.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          ],
          if (task.uploadResponseMessage != null) ...[
            const SizedBox(height: 4),
            Text('Upload Response: ${task.uploadResponseMessage}'),
          ],
        ],
      ),
    );
  }

  // 截断文本以便更好地展示
  String _truncateText(String text, {int maxLength = 20}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  void _deleteData(String dataType) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete $dataType? This operation cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (dataType == 'Favorites Data') {
                    await AppService().hiveManager.saveFavoriteIds([]);
                    AppService().favoritesProvider.clearFavorites();
                  } else if (dataType == 'User Token') {
                    await AppService().hiveManager.deleteUserToken();
                  } else if (dataType == 'Journal Index') {
                    // 清空日记索引
                    final emptyIndex = JournalFileIndex();
                    await AppService().hiveManager.saveJournalIndex(emptyIndex);

                    // 获取所有文件名
                    final journalIndex =
                        _hiveData['journalIndex'] as JournalFileIndex?;
                    if (journalIndex != null) {
                      // 删除所有日记文件
                      for (var file in journalIndex.files) {
                        await AppService().hiveManager.deleteJournalFile(
                          file.fileName,
                        );
                      }
                    }
                  } else if (dataType == 'Update Data Task') {
                    await AppService().hiveManager.deleteUpdateDataTask();
                  }
                  // 重新加载数据
                  _loadHiveData();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // 删除单个日记文件
  void _deleteJournalFile(String fileName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete the journal file: $fileName? This operation cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await AppService().hiveManager.deleteJournal(fileName);
                  _loadHiveData();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
