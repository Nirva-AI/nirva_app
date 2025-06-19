import 'package:flutter/material.dart';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/app_runtime_context.dart';

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

    final data = AppRuntimeContext().storage.getAllData();

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
      ],
    );
  }

  Widget _buildDataCard(
    String title,
    dynamic data, {
    bool isToken = false,
    bool isJournalIndex = false,
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
                  if (dataType == '收藏夹数据') {
                    await AppRuntimeContext().storage.saveFavoriteIds([]);
                    AppRuntimeContext().data.favorites.value = [];
                  } else if (dataType == '用户令牌') {
                    await AppRuntimeContext().storage.deleteUserToken();
                  } else if (dataType == '日记索引') {
                    // 清空日记索引
                    final emptyIndex = JournalFileIndex();
                    await AppRuntimeContext().storage.saveJournalIndex(
                      emptyIndex,
                    );

                    // 获取所有文件名
                    final journalIndex =
                        _hiveData['journalIndex'] as JournalFileIndex?;
                    if (journalIndex != null) {
                      // 删除所有日记文件
                      for (var file in journalIndex.files) {
                        await AppRuntimeContext().storage.deleteJournalFile(
                          file.fileName,
                        );
                      }
                    }
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
                  await AppRuntimeContext().storage.deleteJournal(fileName);
                  _loadHiveData();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
