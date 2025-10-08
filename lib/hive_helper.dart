//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:nirva_app/my_hive_objects.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/data.dart';
// REMOVED: import 'package:nirva_app/update_data_task.dart'; (legacy Amplify code - deleted)
// UpdateDataTaskStatus enum is now in my_hive_objects.dart
import 'package:nirva_app/models/hardware_device.dart';
import 'dart:convert';

class HiveHelper {
  static bool _isInitialized = false;

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

  // 添加 UpdateDataTask 相关常量
  static const String _updateDataTaskBox = 'updateDataTaskBox';
  static const String _updateDataTaskKey = 'updateDataTask';

  // 添加硬件设备存储相关常量
  static const String _hardwareDevicesBox = 'hardwareDevicesBox';
  static const String _hardwareDevicesKey = 'hardwareDevices';
  static const String _lastConnectedDeviceKey = 'lastConnectedDevice';

  // 这句必须得调用！
  static Future<void> initializeHive() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    _isInitialized = true;
  }

  //清空所有 Box 的数据并关闭所有 Box
  static Future<void> deleteFromDisk() async {
    assert(
      _isInitialized,
      'Hive must be initialized before deleting from disk.',
    );
    // 并行删除所有 Box
    await Future.wait([
      Hive.deleteBoxFromDisk(_favoritesBox),
      Hive.deleteBoxFromDisk(_userTokenBox),
      Hive.deleteBoxFromDisk(_chatHistoryBox),
      Hive.deleteBoxFromDisk(_journalIndexBox),
      Hive.deleteBoxFromDisk(_journalFilesBox),
      Hive.deleteBoxFromDisk(_tasksBox),
      Hive.deleteBoxFromDisk(_notesBox),
      Hive.deleteBoxFromDisk(_updateDataTaskBox),
      Hive.deleteBoxFromDisk('cloudAsrResultsBox'), // Add Cloud ASR boxes
      Hive.deleteBoxFromDisk('cloudAsrSessionsBox'), // Add Cloud ASR boxes
      Hive.deleteBoxFromDisk(_hardwareDevicesBox), // Add hardware devices box
      Hive.deleteBoxFromDisk('mixedStorageBox'), // Add mixed storage box
    ]);

    // 这两个操作需要顺序执行，不能并行化
    await Hive.close();
    await Hive.deleteFromDisk();
  }

  // 初始化 Hive
  static Future<void> initializeAdapters() async {
    assert(
      _isInitialized,
      'Hive must be initialized before registering adapters.',
    );
    await Future.wait([
      _initFavorites(),
      _initUserToken(),
      _initChatHistory(),
      _initJournalSystem(),
      _initTasks(),
      _initNotes(),
      _initUpdateDataTask(),
      _initCloudAsrStorage(),
      _initHardwareDevices(),
    ]);
  }

  // 初始化 DiaryFavorites 的 Box
  static Future<void> _initFavorites() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoritesAdapter());
    }
    if (!Hive.isBoxOpen(_favoritesBox)) {
      await Hive.openBox<Favorites>(_favoritesBox);
    }
  }

  // 新增: 初始化 Token 的 Box
  static Future<void> _initUserToken() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserTokenAdapter());
    }
    if (!Hive.isBoxOpen(_userTokenBox)) {
      await Hive.openBox<UserToken>(_userTokenBox);
    }
  }

  // 初始化聊天历史 Box
  static Future<void> _initChatHistory() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ChatMessageStorageAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ChatHistoryAdapter());
    }
    if (!Hive.isBoxOpen(_chatHistoryBox)) {
      await Hive.openBox<ChatHistory>(_chatHistoryBox);
    }
  }

  // 初始化日记系统相关的 Box
  static Future<void> _initJournalSystem() async {
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
  static Future<void> _initTasks() async {
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(TasksStorageAdapter());
    }
    if (!Hive.isBoxOpen(_tasksBox)) {
      await Hive.openBox<TasksStorage>(_tasksBox);
    }
  }

  // 添加笔记存储的初始化方法
  static Future<void> _initNotes() async {
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(NotesStorageAdapter());
    }
    if (!Hive.isBoxOpen(_notesBox)) {
      await Hive.openBox<NotesStorage>(_notesBox);
    }
  }

  // 添加 UpdateDataTask 存储的初始化方法
  static Future<void> _initUpdateDataTask() async {
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(UploadAndTranscribeTaskStorageAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(AnalyzeTaskStorageAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(UpdateDataTaskStorageAdapter());
    }
    if (!Hive.isBoxOpen(_updateDataTaskBox)) {
      await Hive.openBox<UpdateDataTaskStorage>(_updateDataTaskBox);
    }
  }

  // 获取所有 Hive 数据的统计信息和内容
  static Map<String, dynamic> getAllData() {
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
      final tasksBox = Hive.box<TasksStorage>(_tasksBox);
      final tasks = tasksBox.get(_tasksKey);
      data['tasks'] = tasks;
      if (tasks != null) {
        data['tasksCount'] = tasks.taskJsonList.length;
      }
    }

    // 获取笔记数据
    if (Hive.isBoxOpen(_notesBox)) {
      final notesBox = Hive.box<NotesStorage>(_notesBox);
      final notes = notesBox.get(_notesKey);
      data['notes'] = notes;
    }

    // 获取 UpdateDataTask 数据
    if (Hive.isBoxOpen(_updateDataTaskBox)) {
      final updateDataTaskBox = Hive.box<UpdateDataTaskStorage>(
        _updateDataTaskBox,
      );
      final updateDataTask = updateDataTaskBox.get(_updateDataTaskKey);
      data['updateDataTask'] = updateDataTask;
    }

    return data;
  }

  //
  static Future<void> _saveFavorites(Favorites favorites) async {
    final box = Hive.box<Favorites>(_favoritesBox);
    await box.put(_favoritesKey, favorites);
  }

  static Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    final favorites = _getFavorites() ?? Favorites(favoriteIds: []);
    favorites.favoriteIds = favoriteIds;
    await _saveFavorites(favorites);
  }

  //
  static Favorites? _getFavorites() {
    final box = Hive.box<Favorites>(_favoritesBox);
    return box.get(_favoritesKey); // 使用固定的 key 获取
  }

  static List<String> getFavoritesIds() {
    final favorites = _getFavorites();
    if (favorites == null || favorites.favoriteIds.isEmpty) {
      return [];
    }
    return favorites.favoriteIds;
  }

  // 新增: 保存 Token 数据
  static Future<void> saveUserToken(UserToken token) async {
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.put(_userTokenKey, token); // 使用固定的 key 保存
  }

  // 新增: 获取 Token 数据
  static UserToken getUserToken() {
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
  static Future<void> deleteUserToken() async {
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.delete(_userTokenKey);
  }

  // 保存聊天历史
  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    final hiveMessages =
        messages.map((msg) => ChatMessageStorage.fromChatMessage(msg)).toList();
    await box.put(_chatHistoryKey, ChatHistory(messages: hiveMessages));
  }

  // 获取聊天历史
  static List<ChatMessage> getChatHistory() {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    final history = box.get(_chatHistoryKey);
    if (history == null) {
      return [];
    }
    return history.messages.map((msg) => msg.toChatMessage()).toList();
  }

  // 清除聊天历史
  static Future<void> clearChatHistory() async {
    final box = Hive.box<ChatHistory>(_chatHistoryBox);
    await box.delete(_chatHistoryKey);
  }

  // 获取日记文件索引
  static JournalFileIndex getJournalIndex() {
    final box = Hive.box<JournalFileIndex>(_journalIndexBox);
    final index = box.get(_journalIndexKey);
    if (index == null) {
      return JournalFileIndex(); // 返回空索引
    }
    return index;
  }

  // 保存日记文件索引
  static Future<void> saveJournalIndex(JournalFileIndex index) async {
    final box = Hive.box<JournalFileIndex>(_journalIndexBox);
    await box.put(_journalIndexKey, index);
  }

  // 获取单个日记文件
  static JournalFileStorage? getJournalFile(String fileName) {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    return box.get(fileName);
  }

  // 保存单个日记文件
  static Future<void> saveJournalFile(JournalFileStorage file) async {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    await box.put(file.fileName, file);
  }

  // 删除单个日记文件
  static Future<void> deleteJournalFile(String fileName) async {
    final box = Hive.box<JournalFileStorage>(_journalFilesBox);
    await box.delete(fileName);
  }

  // 创建新的日记文件并更新索引
  static Future<JournalFileMeta> createJournalFile({
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
  static Future<JournalFileMeta?> updateJournalFile(
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
  static Future<bool> deleteJournal(String fileName) async {
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

  static List<JournalFile> retrieveJournalFiles() {
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
  static List<Task> getAllTasks() {
    final box = Hive.box<TasksStorage>(_tasksBox);
    final hiveTasks = box.get(_tasksKey);
    if (hiveTasks == null) {
      return [];
    }
    return hiveTasks.toTasks();
  }

  // 保存任务列表
  static Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box<TasksStorage>(_tasksBox);
    final taskJsonList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await box.put(_tasksKey, TasksStorage(taskJsonList: taskJsonList));
  }

  // 获取所有笔记
  static List<Note> getAllNotes() {
    final box = Hive.box<NotesStorage>(_notesBox);
    final hiveNotes = box.get(_notesKey);
    if (hiveNotes == null) {
      return [];
    }
    return hiveNotes.toNotes();
  }

  // 保存笔记列表
  static Future<void> saveNotes(List<Note> notes) async {
    final box = Hive.box<NotesStorage>(_notesBox);
    final noteJsonList =
        notes.map((note) => jsonEncode(note.toJson())).toList();
    await box.put(_notesKey, NotesStorage(noteJsonList: noteJsonList));
  }

  // ===============================================================================
  // UpdateDataTask 相关管理方法
  // ===============================================================================

  /// 获取当前的 UpdateDataTask
  static UpdateDataTaskStorage? getUpdateDataTask() {
    final box = Hive.box<UpdateDataTaskStorage>(_updateDataTaskBox);
    return box.get(_updateDataTaskKey);
  }

  /// 保存 UpdateDataTask
  static Future<void> saveUpdateDataTask(
    UpdateDataTaskStorage updateDataTask,
  ) async {
    final box = Hive.box<UpdateDataTaskStorage>(_updateDataTaskBox);
    await box.put(_updateDataTaskKey, updateDataTask);
  }

  /// 删除 UpdateDataTask
  static Future<void> deleteUpdateDataTask() async {
    final box = Hive.box<UpdateDataTaskStorage>(_updateDataTaskBox);
    await box.delete(_updateDataTaskKey);
  }

  // ===============================================================================
  // Hardware Devices 相关管理方法
  // ===============================================================================

  /// 初始化硬件设备存储
  static Future<void> _initHardwareDevices() async {
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(HardwareDeviceStorageAdapter());
    }
    if (!Hive.isBoxOpen(_hardwareDevicesBox)) {
      await Hive.openBox<HardwareDeviceStorage>(_hardwareDevicesBox);
    }
    
    // Initialize the mixed storage box for storing device counts and last connected device
    if (!Hive.isBoxOpen('mixedStorageBox')) {
      await Hive.openBox('mixedStorageBox');
    }
  }

  /// 保存硬件设备列表
  static Future<void> saveHardwareDevices(List<HardwareDeviceStorage> devices) async {
    try {
      debugPrint('HiveHelper: Saving ${devices.length} hardware devices...');
      final box = Hive.box<HardwareDeviceStorage>(_hardwareDevicesBox);
      
      // Clear existing devices and add new ones
      await box.clear();
      debugPrint('HiveHelper: Cleared existing devices from storage');
      
      for (int i = 0; i < devices.length; i++) {
        await box.put('device_$i', devices[i]);
      }
      debugPrint('HiveHelper: Stored ${devices.length} devices in hardware box');
      
      // Store the count in a separate box for mixed types
      final mixedBox = Hive.box('mixedStorageBox');
      await mixedBox.put(_hardwareDevicesKey, devices.length);
      debugPrint('HiveHelper: Stored device count ${devices.length} in mixed storage box');
      
      debugPrint('HiveHelper: Successfully saved ${devices.length} hardware devices');
    } catch (e) {
      debugPrint('HiveHelper: Error saving hardware devices: $e');
      rethrow;
    }
  }

  /// 获取保存的硬件设备列表
  static List<HardwareDeviceStorage> getHardwareDevices() {
    try {
      debugPrint('HiveHelper: Retrieving hardware devices from storage...');
      final box = Hive.box<HardwareDeviceStorage>(_hardwareDevicesBox);
      final mixedBox = Hive.box('mixedStorageBox');
      
      final count = mixedBox.get(_hardwareDevicesKey) as int? ?? 0;
      debugPrint('HiveHelper: Found device count: $count');
      
      final devices = <HardwareDeviceStorage>[];
      
      for (int i = 0; i < count; i++) {
        final device = box.get('device_$i') as HardwareDeviceStorage?;
        if (device != null) {
          devices.add(device);
        }
      }
      
      debugPrint('HiveHelper: Retrieved ${devices.length} devices from storage');
      return devices;
    } catch (e) {
      debugPrint('HiveHelper: Error retrieving hardware devices: $e');
      return [];
    }
  }

  /// 保存最后连接的设备ID
  static Future<void> saveLastConnectedDevice(String deviceId) async {
    try {
      debugPrint('HiveHelper: Saving last connected device ID: $deviceId');
      final mixedBox = Hive.box('mixedStorageBox');
      await mixedBox.put(_lastConnectedDeviceKey, deviceId);
      debugPrint('HiveHelper: Successfully saved last connected device ID: $deviceId');
    } catch (e) {
      debugPrint('HiveHelper: Error saving last connected device ID: $e');
      rethrow;
    }
  }

  /// 获取最后连接的设备ID
  static String? getLastConnectedDevice() {
    try {
      debugPrint('HiveHelper: Retrieving last connected device ID...');
      final mixedBox = Hive.box('mixedStorageBox');
      final deviceId = mixedBox.get(_lastConnectedDeviceKey) as String?;
      debugPrint('HiveHelper: Retrieved last connected device ID: $deviceId');
      return deviceId;
    } catch (e) {
      debugPrint('HiveHelper: Error retrieving last connected device ID: $e');
      return null;
    }
  }

  /// 清除硬件设备存储
  static Future<void> clearHardwareDevices() async {
    final box = Hive.box<HardwareDeviceStorage>(_hardwareDevicesBox);
    await box.clear();
  }

  /// 检查是否存在保存的 UpdateDataTask
  static bool hasUpdateDataTask() {
    final box = Hive.box<UpdateDataTaskStorage>(_updateDataTaskBox);
    return box.containsKey(_updateDataTaskKey);
  }

  /// 从 UpdateDataTask 创建并保存存储对象 (便利方法)
  static Future<void> saveUpdateDataTaskFromData({
    required String id, // 添加 id 参数
    required String userId,
    required List<String> assetFileNames,
    required List<String> pickedFileNames,
    required DateTime creationTime,
    required UpdateDataTaskStatus status,
    String? errorMessage,
    String? transcriptFilePath,
    UploadAndTranscribeTaskStorage? uploadAndTranscribeTaskStorage,
    AnalyzeTaskStorage? analyzeTaskStorage,
  }) async {
    final storage = UpdateDataTaskStorage.create(
      id: id, // 添加 id 参数
      userId: userId,
      assetFileNames: assetFileNames,
      pickedFileNames: pickedFileNames,
      creationTime: creationTime,
      status: status,
      errorMessage: errorMessage,
      transcriptFilePath: transcriptFilePath,
      uploadAndTranscribeTaskStorage: uploadAndTranscribeTaskStorage,
      analyzeTaskStorage: analyzeTaskStorage,
    );
    await saveUpdateDataTask(storage);
  }

  /// 获取 UpdateDataTask 的构造数据 (便利方法)
  static Map<String, dynamic>? getUpdateDataTaskConstructorData() {
    final storage = getUpdateDataTask();
    return storage?.toConstructorData();
  }

  /// Clear all user-specific data from Hive boxes
  /// This should be called on logout to ensure data isolation between users
  static Future<void> clearUserData() async {
    try {
      debugPrint('HiveHelper: Clearing all user-specific data...');
      
      // Clear all user-specific boxes in parallel
      await Future.wait([
        // Clear journal files
        () async {
          if (Hive.isBoxOpen(_journalFilesBox)) {
            final box = Hive.box<JournalFileStorage>(_journalFilesBox);
            await box.clear();
            debugPrint('HiveHelper: Cleared journal files');
          }
        }(),
        
        // Clear tasks
        () async {
          if (Hive.isBoxOpen(_tasksBox)) {
            final box = Hive.box<TasksStorage>(_tasksBox);
            await box.clear();
            debugPrint('HiveHelper: Cleared tasks');
          }
        }(),
        
        // Clear notes
        () async {
          if (Hive.isBoxOpen(_notesBox)) {
            final box = Hive.box<NotesStorage>(_notesBox);
            await box.clear();
            debugPrint('HiveHelper: Cleared notes');
          }
        }(),
        
        // Clear chat history
        clearChatHistory(),
        
        // Clear favorites - save empty list
        saveFavoriteIds([]),
        
        // Clear cloud ASR results
        () async {
          if (Hive.isBoxOpen('cloudAsrResultsBox')) {
            final box = Hive.box<CloudAsrResultStorage>('cloudAsrResultsBox');
            await box.clear();
            debugPrint('HiveHelper: Cleared cloud ASR results');
          }
        }(),
        
        // Clear cloud ASR sessions
        () async {
          if (Hive.isBoxOpen('cloudAsrSessionsBox')) {
            final box = Hive.box<CloudAsrSessionStorage>('cloudAsrSessionsBox');
            await box.clear();
            debugPrint('HiveHelper: Cleared cloud ASR sessions');
          }
        }(),
        
        // Clear mixed storage box (transcriptions, etc.)
        () async {
          if (Hive.isBoxOpen('mixedStorageBox')) {
            final box = Hive.box('mixedStorageBox');
            await box.clear();
            debugPrint('HiveHelper: Cleared mixed storage');
          }
        }(),
        
        // Clear update data tasks
        deleteUpdateDataTask(),
        
        // Clear journal index
        () async {
          if (Hive.isBoxOpen(_journalIndexBox)) {
            final box = Hive.box<JournalFileIndex>(_journalIndexBox);
            await box.clear();
            debugPrint('HiveHelper: Cleared journal index');
          }
        }(),
      ]);
      
      debugPrint('HiveHelper: Successfully cleared all user-specific data');
    } catch (e) {
      debugPrint('HiveHelper: Error clearing user data: $e');
    }
  }

  // ===============================================================================
  // Cloud ASR Storage 相关管理方法
  // ===============================================================================

  /// 添加 Cloud ASR 存储的初始化方法
  static Future<void> _initCloudAsrStorage() async {
    debugPrint('HiveHelper: Starting Cloud ASR storage adapter registration... [${DateTime.now().toIso8601String()}]');
    
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(CloudAsrResultStorageAdapter());
      debugPrint('HiveHelper: CloudAsrResultStorageAdapter registered with typeId 13');
    } else {
      debugPrint('HiveHelper: CloudAsrResultStorageAdapter already registered with typeId 13');
    }
    
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(CloudAsrSessionStorageAdapter());
      debugPrint('HiveHelper: CloudAsrSessionStorageAdapter registered with typeId 14');
    } else {
      debugPrint('HiveHelper: CloudAsrSessionStorageAdapter already registered with typeId 14');
    }
    
    // Open the Cloud ASR boxes during app initialization
    await _openCloudAsrBoxes();
    
    debugPrint('HiveHelper: Cloud ASR storage adapters registration completed');
    
    // Verify registration
    debugPrint('HiveHelper: Verification - CloudAsrResultStorageAdapter registered: ${Hive.isAdapterRegistered(13)}');
    debugPrint('HiveHelper: Verification - CloudAsrSessionStorageAdapter registered: ${Hive.isAdapterRegistered(14)}');
  }

  /// Open Cloud ASR storage boxes
  static Future<void> _openCloudAsrBoxes() async {
    try {
      const String resultsBoxName = 'cloudAsrResultsBox';
      const String sessionsBoxName = 'cloudAsrSessionsBox';
      
      // Open boxes if not already open
      if (!Hive.isBoxOpen(resultsBoxName)) {
        await Hive.openBox<CloudAsrResultStorage>(resultsBoxName);
        debugPrint('HiveHelper: Opened cloudAsrResultsBox');
      } else {
        debugPrint('HiveHelper: cloudAsrResultsBox already open');
      }
      
      if (!Hive.isBoxOpen(sessionsBoxName)) {
        await Hive.openBox<CloudAsrSessionStorage>(sessionsBoxName);
        debugPrint('HiveHelper: Opened cloudAsrSessionsBox');
      } else {
        debugPrint('HiveHelper: cloudAsrSessionsBox already open');
      }
      
      // Log box contents for debugging
      final resultsBox = Hive.box<CloudAsrResultStorage>(resultsBoxName);
      final sessionsBox = Hive.box<CloudAsrSessionStorage>(sessionsBoxName);
      debugPrint('HiveHelper: Cloud ASR boxes opened - Results: ${resultsBox.length}, Sessions: ${sessionsBox.length}');
      
    } catch (e) {
      debugPrint('HiveHelper: Error opening Cloud ASR boxes: $e');
    }
  }

  /// Get Cloud ASR results box
  static Box<CloudAsrResultStorage> getCloudAsrResultsBox() {
    return Hive.box<CloudAsrResultStorage>('cloudAsrResultsBox');
  }

  /// Get Cloud ASR sessions box
  static Box<CloudAsrSessionStorage> getCloudAsrSessionsBox() {
    return Hive.box<CloudAsrSessionStorage>('cloudAsrSessionsBox');
  }

  /// Check Cloud ASR data status for debugging
  static void logCloudAsrStatus() {
    try {
      final resultsBox = getCloudAsrResultsBox();
      final sessionsBox = getCloudAsrSessionsBox();
      
      debugPrint('HiveHelper: Cloud ASR Data Status:');
      debugPrint('HiveHelper: - Results box length: ${resultsBox.length}');
      debugPrint('HiveHelper: - Sessions box length: ${sessionsBox.length}');
      
    } catch (e) {
      debugPrint('HiveHelper: Error logging Cloud ASR status: $e');
    }
  }
}
