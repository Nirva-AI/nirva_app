//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/data.dart';
import 'dart:convert';

class HiveStorage {
  // 现有的常量定义
  static const String _favoritesBox = 'favoritesBox';
  static const String _favoritesKey = 'favorites';

  // 新增 Token 相关的常量定义
  static const String _userTokenBox = 'userTokenBox';
  static const String _userTokenKey = 'userToken';

  // 添加新的常量
  static const String _chatHistoryBox = 'chatHistoryBox';
  static const String _chatHistoryKey = 'chatHistory';

  // 日记文件相关常量
  static const String _journalIndexBox = 'journalIndexBox';
  static const String _journalIndexKey = 'journalIndex';
  static const String _journalFilesBox = 'journalFilesBox';

  // 添加任务相关常量
  static const String _tasksBox = 'tasksBox';
  static const String _tasksKey = 'tasks';

  // 添加笔记相关常量
  static const String _notesBox = 'notesBox';
  static const String _notesKey = 'notes';

  // 更新数据任务相关常量
  static const String _updateDataTasksBox = 'updateDataTasksBox';
  static const String _updateDataTasksKey = 'updateDataTasks';

  Future<void> _initialize() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  //清空所有 Box 的数据并关闭所有 Box
  Future<void> deleteFromDisk() async {
    await _initialize(); // 确保 Hive 已经初始化

    // 并行删除所有 Box
    await Future.wait([
      Hive.deleteBoxFromDisk(_favoritesBox),
      Hive.deleteBoxFromDisk(_userTokenBox),
      Hive.deleteBoxFromDisk(_chatHistoryBox),
      Hive.deleteBoxFromDisk(_journalIndexBox),
      Hive.deleteBoxFromDisk(_journalFilesBox),
      Hive.deleteBoxFromDisk(_tasksBox),
      Hive.deleteBoxFromDisk(_notesBox),
      Hive.deleteBoxFromDisk(_updateDataTasksBox), // 添加这一行
    ]);

    // 这两个操作需要顺序执行，不能并行化
    await Hive.close();
    await Hive.deleteFromDisk();
  }

  // 初始化 Hive
  Future<void> initializeAdapters() async {
    await _initialize();
    await Future.wait([
      _initFavorites(),
      _initUserToken(),
      _initChatHistory(),
      _initJournalSystem(),
      _initTasks(), // 添加任务存储初始化
      _initNotes(), // 添加笔记存储初始化
      _initUpdateDataTasks(), // 添加更新数据任务存储初始化
    ]);
  }

  // 初始化 DiaryFavorites 的 Box
  Future<void> _initFavorites() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoritesAdapter());
    }
    if (!Hive.isBoxOpen(_favoritesBox)) {
      await Hive.openBox<Favorites>(_favoritesBox);
    }
  }

  // 新增: 初始化 Token 的 Box
  Future<void> _initUserToken() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserTokenAdapter());
    }
    if (!Hive.isBoxOpen(_userTokenBox)) {
      await Hive.openBox<UserToken>(_userTokenBox);
    }
  }

  // 初始化聊天历史 Box
  Future<void> _initChatHistory() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(HiveChatMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ChatHistoryAdapter());
    }
    if (!Hive.isBoxOpen(_chatHistoryBox)) {
      await Hive.openBox<ChatHistory>(_chatHistoryBox);
    }
  }

  // 初始化日记系统相关的 Box
  Future<void> _initJournalSystem() async {
    // 注册适配器
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(JournalFileMetaAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(JournalFileIndexAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(JournalFileStorageAdapter());
    }

    // 打开Boxes
    if (!Hive.isBoxOpen(_journalIndexBox)) {
      await Hive.openBox<JournalFileIndex>(_journalIndexBox);
    }
    if (!Hive.isBoxOpen(_journalFilesBox)) {
      await Hive.openBox<JournalFileStorage>(_journalFilesBox);
    }
  }

  // 添加任务存储的初始化方法
  Future<void> _initTasks() async {
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(HiveTasksAdapter());
    }
    if (!Hive.isBoxOpen(_tasksBox)) {
      await Hive.openBox<HiveTasks>(_tasksBox);
    }
  }

  // 添加笔记存储的初始化方法
  Future<void> _initNotes() async {
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(HiveNotesAdapter());
    }
    if (!Hive.isBoxOpen(_notesBox)) {
      await Hive.openBox<HiveNotes>(_notesBox);
    }
  }

  // 初始化更新数据任务的 Box
  Future<void> _initUpdateDataTasks() async {
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(UpdateDataTaskAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(UpdateDataTaskListAdapter());
    }
    if (!Hive.isBoxOpen(_updateDataTasksBox)) {
      await Hive.openBox<UpdateDataTaskList>(_updateDataTasksBox);
    }
  }

  // 获取所有 Hive 数据的统计信息和内容
  Map<String, dynamic> getAllData() {
    final Map<String, dynamic> data = {};

    // 获取收藏夹数据
    if (Hive.isBoxOpen(_favoritesBox)) {
      final favBox = Hive.box<Favorites>(_favoritesBox);
      final favorites = favBox.get(_favoritesKey);
      data['favorites'] = favorites;
    }

    // 获取用户令牌数据
    if (Hive.isBoxOpen(_userTokenBox)) {
      final tokenBox = Hive.box<UserToken>(_userTokenBox);
      final token = tokenBox.get(_userTokenKey);
      data['userToken'] = token;
    }

    // 获取聊天历史数据
    if (Hive.isBoxOpen(_chatHistoryBox)) {
      final chatBox = Hive.box<ChatHistory>(_chatHistoryBox);
      final history = chatBox.get(_chatHistoryKey);
      data['chatHistory'] = history;
    }

    // 获取日记索引数据
    if (Hive.isBoxOpen(_journalIndexBox)) {
      final indexBox = Hive.box<JournalFileIndex>(_journalIndexBox);
      final index = indexBox.get(_journalIndexKey);
      data['journalIndex'] = index;

      // 添加日记文件计数
      if (index != null) {
        data['journalCount'] = index.files.length;
      }
    }

    // 添加日记文件存储统计
    if (Hive.isBoxOpen(_journalFilesBox)) {
      final filesBox = Hive.box<JournalFileStorage>(_journalFilesBox);
      data['journalFilesCount'] = filesBox.length;
    }

    // 获取任务数据
    if (Hive.isBoxOpen(_tasksBox)) {
      final tasksBox = Hive.box<HiveTasks>(_tasksBox);
      final tasks = tasksBox.get(_tasksKey);
      data['tasks'] = tasks;
      if (tasks != null) {
        data['tasksCount'] = tasks.taskJsonList.length;
      }
    }

    // 获取笔记数据
    if (Hive.isBoxOpen(_notesBox)) {
      final notesBox = Hive.box<HiveNotes>(_notesBox);
      final notes = notesBox.get(_notesKey);
      data['notes'] = notes;
    }

    // 获取更新数据任务数据
    if (Hive.isBoxOpen(_updateDataTasksBox)) {
      final updateDataTasksBox = Hive.box<UpdateDataTaskList>(
        _updateDataTasksBox,
      );
      final updateDataTasks = updateDataTasksBox.get(_updateDataTasksKey);
      data['updateDataTasks'] = updateDataTasks;
      if (updateDataTasks != null) {
        data['updateDataTasksCount'] = updateDataTasks.tasks.length;
      }
    }

    return data;
  }

  // 保存 DiaryFavorites 数据
  Future<void> saveFavorites(Favorites diaryFavorites) async {
    final box = Hive.box<Favorites>(_favoritesBox);
    await box.put(_favoritesKey, diaryFavorites); // 使用固定的 key 保存
  }

  // 获取 DiaryFavorites 数据
  Favorites? getFavorites() {
    final box = Hive.box<Favorites>(_favoritesBox);
    return box.get(_favoritesKey); // 使用固定的 key 获取
  }

  // 新增: 保存 Token 数据
  Future<void> saveUserToken(UserToken token) async {
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.put(_userTokenKey, token); // 使用固定的 key 保存
  }

  // 新增: 获取 Token 数据
  UserToken getUserToken() {
    final box = Hive.box<UserToken>(_userTokenBox);
    final res = box.get(_userTokenKey); // 使用固定的 key 获取
    if (res == null) {
      return UserToken(
        access_token: '',
        token_type: '',
        refresh_token: '',
      ); // 返回一个默认的 Token 对象
    }
    return res;
  }

  // 新增: 删除 Token 数据 (登出时使用)
  Future<void> deleteUserToken() async {
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.delete(_userTokenKey);
  }

  // 保存聊天历史
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    final hiveMessages =
        messages.map((msg) => HiveChatMessage.fromChatMessage(msg)).toList();
    await box.put(_chatHistoryKey, ChatHistory(messages: hiveMessages));
  }

  // 获取聊天历史
  List<ChatMessage> getChatHistory() {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    final history = box.get(_chatHistoryKey);
    if (history == null) {
      return [];
    }
    return history.messages.map((msg) => msg.toChatMessage()).toList();
  }

  // 清除聊天历史
  Future<void> clearChatHistory() async {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    await box.delete(_chatHistoryKey);
  }

  // 获取日记文件索引
  JournalFileIndex getJournalIndex() {
    final box = Hive.box<JournalFileIndex>(_journalIndexBox);
    final index = box.get(_journalIndexKey);
    if (index == null) {
      return JournalFileIndex(); // 返回空索引
    }
    return index;
  }

  // 保存日记文件索引
  Future<void> saveJournalIndex(JournalFileIndex index) async {
    final box = Hive.box<JournalFileIndex>(_journalIndexBox);
    await box.put(_journalIndexKey, index);
  }

  // 获取单个日记文件
  JournalFileStorage? getJournalFile(String fileName) {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    return box.get(fileName);
  }

  // 保存单个日记文件
  Future<void> saveJournalFile(JournalFileStorage file) async {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    await box.put(file.fileName, file);
  }

  // 删除单个日记文件
  Future<void> deleteJournalFile(String fileName) async {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    await box.delete(fileName);
  }

  // 创建新的日记文件并更新索引
  Future<JournalFileMeta> createJournalFile({
    required String fileName,
    required String content,
  }) async {
    // 创建文件和元数据
    final (file, meta) = JournalFileStorage.create(
      fileName: fileName,
      content: content,
    );

    // 保存文件
    await saveJournalFile(file);

    // 更新索引
    final index = getJournalIndex();
    index.addFile(meta);
    await saveJournalIndex(index);

    return meta;
  }

  // 更新日记文件内容
  Future<JournalFileMeta?> updateJournalFile(
    String fileName,
    String newContent,
  ) async {
    // 获取文件
    final file = getJournalFile(fileName);
    if (file == null) return null;

    // 获取索引
    final index = getJournalIndex();
    final meta = index.findFile(fileName);
    if (meta == null) return null;

    // 更新文件内容
    final updatedMeta = file.updateContent(newContent, meta);

    // 保存更新
    await saveJournalFile(file);
    index.updateFile(fileName, updatedMeta);
    await saveJournalIndex(index);

    return updatedMeta;
  }

  // 删除日记文件及其元数据
  Future<bool> deleteJournal(String fileName) async {
    // 获取索引
    final index = getJournalIndex();

    // 删除索引中的元数据
    final removed = index.removeFile(fileName);
    if (!removed) return false;

    // 删除文件
    await deleteJournalFile(fileName);

    // 保存索引
    await saveJournalIndex(index);

    return true;
  }

  List<JournalFile> retrieveJournalFiles() {
    final index = getJournalIndex();
    if (index.files.isEmpty) {
      return [];
    }

    List<JournalFile> ret = [];
    for (var fileMeta in index.files) {
      final journalFileStorage = getJournalFile(fileMeta.fileName);
      if (journalFileStorage == null) {
        continue;
      }
      final jsonDecode =
          json.decode(journalFileStorage.content) as Map<String, dynamic>;
      final journalFile = JournalFile.fromJson(jsonDecode);
      ret.add(journalFile);
    }

    return ret;
  }

  // 获取所有任务
  List<Task> getAllTasks() {
    final box = Hive.box<HiveTasks>(_tasksBox);
    final hiveTasks = box.get(_tasksKey);
    if (hiveTasks == null) {
      return [];
    }
    return hiveTasks.toTasks();
  }

  // 保存任务列表
  Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box<HiveTasks>(_tasksBox);
    final taskJsonList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await box.put(_tasksKey, HiveTasks(taskJsonList: taskJsonList));
  }

  // 获取所有笔记
  List<Note> getAllNotes() {
    final box = Hive.box<HiveNotes>(_notesBox);
    final hiveNotes = box.get(_notesKey);
    if (hiveNotes == null) {
      return [];
    }
    return hiveNotes.toNotes();
  }

  // 保存笔记列表
  Future<void> saveNotes(List<Note> notes) async {
    final box = Hive.box<HiveNotes>(_notesBox);
    final noteJsonList =
        notes.map((note) => jsonEncode(note.toJson())).toList();
    await box.put(_notesKey, HiveNotes(noteJsonList: noteJsonList));
  }

  // 获取所有更新数据任务
  List<UpdateDataTask> getAllUpdateDataTasks() {
    final box = Hive.box<UpdateDataTaskList>(_updateDataTasksBox);
    final updateDataTaskList = box.get(_updateDataTasksKey);
    if (updateDataTaskList == null) {
      return [];
    }
    return updateDataTaskList.tasks;
  }

  // 保存更新数据任务
  Future<void> saveUpdateDataTasks(List<UpdateDataTask> tasks) async {
    final box = Hive.box<UpdateDataTaskList>(_updateDataTasksBox);
    await box.put(_updateDataTasksKey, UpdateDataTaskList(tasks: tasks));
  }

  // 添加或更新更新数据任务
  Future<bool> addUpdateDataTask(UpdateDataTask task) async {
    final updateDataTaskList = getAllUpdateDataTasks();
    for (var existingTask in updateDataTaskList) {
      if (existingTask.id == task.id ||
          existingTask.fileName == task.fileName) {
        return false; // 重复的任务，返回 false
      }
    }
    updateDataTaskList.add(task);
    await saveUpdateDataTasks(updateDataTaskList);
    return true;
  }

  // 删除更新数据任务
  Future<void> deleteUpdateDataTask(String id, String fileName) async {
    final updateDataTaskList = getAllUpdateDataTasks();
    updateDataTaskList.removeWhere(
      (task) => task.id == id || task.fileName == fileName,
    );
    await saveUpdateDataTasks(updateDataTaskList);
  }
}
