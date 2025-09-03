import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  /// 设置收藏列表（用于初始化数据）
  void setupFavorites(List<String> ids) {
    _favoriteIds = ids;
    notifyListeners();
  }

  /// 检查是否收藏
  bool isFavorite(String eventId) {
    return _favoriteIds.contains(eventId);
  }

  /// 切换收藏状态
  void toggleFavorite(String eventId) {
    if (_favoriteIds.contains(eventId)) {
      _favoriteIds.remove(eventId);
    } else {
      _favoriteIds.add(eventId);
    }
    notifyListeners();
  }

  /// 添加收藏
  void addFavorite(String eventId) {
    if (!_favoriteIds.contains(eventId)) {
      _favoriteIds.add(eventId);
      notifyListeners();
    }
  }

  /// 移除收藏
  void removeFavorite(String eventId) {
    if (_favoriteIds.remove(eventId)) {
      notifyListeners();
    }
  }

  /// 清空收藏列表
  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }

  /// 迁移：切换事件收藏状态（保持与原 RuntimeData 兼容）
  void switchEventFavoriteStatus(EventAnalysis event) {
    toggleFavorite(event.event_id);
  }

  /// 迁移：检查事件是否收藏（保持与原 RuntimeData 兼容）
  bool checkFavorite(EventAnalysis event) {
    return isFavorite(event.event_id);
  }

  /// 获取收藏数量
  int get favoritesCount => _favoriteIds.length;

  /// 检查收藏列表是否为空
  bool get isEmpty => _favoriteIds.isEmpty;

  /// 检查收藏列表是否不为空
  bool get isNotEmpty => _favoriteIds.isNotEmpty;

  /// Clear all favorites data (used on logout)
  void clearData() {
    _favoriteIds = [];
    notifyListeners();
  }
}
