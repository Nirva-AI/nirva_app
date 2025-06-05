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
        title: const Text('Hive 数据管理'),
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
      return const Center(child: Text('没有存储的 Hive 数据'));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildDataCard('收藏夹数据', _hiveData['favorites']),
        const SizedBox(height: 16),
        _buildDataCard('用户令牌', _hiveData['userToken'], isToken: true),
      ],
    );
  }

  Widget _buildDataCard(String title, dynamic data, {bool isToken = false}) {
    if (data == null) {
      return Card(
        child: ListTile(title: Text(title), subtitle: const Text('暂无数据')),
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
          Text('收藏数量: ${data.favoriteIds.length}'),
          const SizedBox(height: 8),
          if (data.favoriteIds.isNotEmpty) ...[
            const Text('收藏 IDs:'),
            ...data.favoriteIds.map(
              (id) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(id),
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
                  child: const Text('清除数据'),
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
            title: const Text('确认删除'),
            content: Text('是否确定删除$dataType？此操作不可恢复。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (dataType == '收藏夹数据') {
                    await AppRuntimeContext().storage.saveFavorites(
                      Favorites(favoriteIds: []),
                    );
                    AppRuntimeContext().data.favorites.value = [];
                  } else if (dataType == '用户令牌') {
                    await AppRuntimeContext().storage.deleteUserToken();
                  }
                  // 重新加载数据
                  _loadHiveData();
                },
                child: const Text('删除'),
              ),
            ],
          ),
    );
  }
}
