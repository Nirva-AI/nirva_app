import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  /// 设置笔记列表（用于初始化数据）
  void setupNotes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  /// 根据ID查找笔记
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 检查是否存在指定ID的笔记
  bool hasNote(String id) {
    return _notes.any((note) => note.id == id);
  }

  /// 添加新笔记
  void addNote(Note note) {
    if (!hasNote(note.id)) {
      _notes.add(note);
      notifyListeners();
    }
  }

  /// 更新笔记内容
  void updateNoteContent(String id, String content) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(id: id, content: content);
      notifyListeners();
    } else {
      // 如果不存在，则添加新笔记
      addNote(Note(id: id, content: content));
    }
  }

  /// 删除笔记
  void removeNote(String id) {
    final originalLength = _notes.length;
    _notes.removeWhere((note) => note.id == id);
    if (_notes.length != originalLength) {
      notifyListeners();
    }
  }

  /// 删除指定笔记对象
  void removeNoteObject(Note note) {
    if (_notes.remove(note)) {
      notifyListeners();
    }
  }

  /// 清空所有笔记
  void clearNotes() {
    _notes.clear();
    notifyListeners();
  }

  /// 迁移：更新事件相关的笔记（保持与原 RuntimeData 兼容）
  void updateNote(EventAnalysis event, String content) {
    updateNoteContent(event.event_id, content);
  }

  /// 获取笔记数量
  int get notesCount => _notes.length;

  /// 检查笔记列表是否为空
  bool get isEmpty => _notes.isEmpty;

  /// 检查笔记列表是否不为空
  bool get isNotEmpty => _notes.isNotEmpty;

  /// 根据内容搜索笔记
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return notes;
    return _notes
        .where(
          (note) => note.content.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
