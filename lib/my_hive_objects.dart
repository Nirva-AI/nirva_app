// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/update_data_task.dart';
import 'package:nirva_app/analyze_task.dart';
import 'package:nirva_app/transcribe_file_name.dart';
part 'my_hive_objects.g.dart';

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class Favorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  Favorites({required this.favoriteIds});
}

// 本机存储UserToken
@HiveType(typeId: 2)
class UserToken extends HiveObject {
  @HiveField(0)
  String access_token;

  @HiveField(1)
  String token_type;

  @HiveField(2)
  String refresh_token; // 新增字段

  UserToken({
    required this.access_token,
    required this.token_type,
    required this.refresh_token,
  });
}

// ChatMessage 在 Hive 中的存储模型
@HiveType(typeId: 3)
class ChatMessageStorage {
  @HiveField(0)
  String id;

  @HiveField(1)
  int role;

  @HiveField(2)
  String content;

  @HiveField(3)
  String time_stamp;

  @HiveField(4)
  List<String>? tags;

  ChatMessageStorage({
    required this.id,
    required this.role,
    required this.content,
    required this.time_stamp,
    this.tags,
  });

  // 转换为 API 模型中的 ChatMessage
  ChatMessage toChatMessage() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      time_stamp: time_stamp,
      tags: tags,
    );
  }

  // 从 API 模型的 ChatMessage 创建 Hive 模型
  static ChatMessageStorage fromChatMessage(ChatMessage message) {
    return ChatMessageStorage(
      id: message.id,
      role: message.role,
      content: message.content,
      time_stamp: message.time_stamp,
      tags: message.tags,
    );
  }
}

// 存储聊天历史的容器
//如果聊天历史较大，可能需要考虑分页加载或按会话存储的优化策略!!!!!!!!
@HiveType(typeId: 4)
class ChatHistory extends HiveObject {
  @HiveField(0)
  List<ChatMessageStorage> messages;

  ChatHistory({required this.messages});
}

// 单个日记文件的元数据
@HiveType(typeId: 5)
class JournalFileMeta extends HiveObject {
  @HiveField(0)
  String fileName; // 文件名，用作唯一标识符

  JournalFileMeta({required this.fileName});
}

// 日记文件索引管理器
@HiveType(typeId: 6)
class JournalFileIndex extends HiveObject {
  @HiveField(0)
  List<JournalFileMeta> files;

  // 修改构造函数，确保创建可修改列表
  JournalFileIndex({List<JournalFileMeta>? files})
    : files = files != null ? List<JournalFileMeta>.from(files) : [];

  // 添加日记文件元数据
  void addFile(JournalFileMeta fileMeta) {
    // 检查是否已存在同名文件
    final index = files.indexWhere((f) => f.fileName == fileMeta.fileName);

    if (index >= 0) {
      // 更新已存在的文件元数据
      files[index] = fileMeta;
    } else {
      // 添加新文件元数据
      files.add(fileMeta);
    }

    // 按照某种条件排序，例如文件名
    // files.sort((a, b) => a.fileName.compareTo(b.fileName));
  }

  // 根据文件名删除元数据
  bool removeFile(String fileName) {
    final initialLength = files.length;
    files.removeWhere((file) => file.fileName == fileName);
    return files.length < initialLength;
  }

  // 更新文件元数据
  bool updateFile(String fileName, JournalFileMeta newMeta) {
    final index = files.indexWhere((f) => f.fileName == fileName);

    if (index >= 0) {
      files[index] = newMeta;
      return true;
    }
    return false;
  }

  // 根据文件名查找元数据
  JournalFileMeta? findFile(String fileName) {
    try {
      return files.firstWhere((file) => file.fileName == fileName);
    } catch (_) {
      return null;
    }
  }

  // 获取最近的n个日记文件
  List<JournalFileMeta> getRecentFiles({int limit = 10}) {
    // 已经按创建时间排序，所以直接返回前n个
    return files.length <= limit ? List.from(files) : files.sublist(0, limit);
  }
}

// 单个日记文件的完整内容
@HiveType(typeId: 7)
class JournalFileStorage extends HiveObject {
  @HiveField(0)
  String fileName; // 文件名，关联到元数据

  @HiveField(1)
  String content; // 日记内容的JSON字符串

  JournalFileStorage({required this.fileName, required this.content});

  // 更新内容并返回新的元数据
  JournalFileMeta updateContent(String newContent, JournalFileMeta meta) {
    content = newContent;
    return meta;
  }

  // 创建新日记文件及其元数据
  static (JournalFileStorage, JournalFileMeta) create({
    required String fileName,
    required String content,
  }) {
    // 创建元数据
    final meta = JournalFileMeta(fileName: fileName);

    // 创建文件
    final file = JournalFileStorage(fileName: fileName, content: content);
    return (file, meta);
  }
}

// 任务列表的 Hive 存储结构
@HiveType(typeId: 8)
class TasksStorage extends HiveObject {
  @HiveField(0)
  List<String> taskJsonList;

  TasksStorage({required this.taskJsonList});

  // 获取所有任务
  List<Task> toTasks() {
    return taskJsonList
        .map((jsonString) => Task.fromJson(jsonDecode(jsonString)))
        .toList();
  }
}

// 笔记列表的 Hive 存储结构
@HiveType(typeId: 9)
class NotesStorage extends HiveObject {
  @HiveField(0)
  List<String> noteJsonList;

  NotesStorage({required this.noteJsonList});

  // 获取所有笔记
  List<Note> toNotes() {
    return noteJsonList
        .map((jsonString) => Note.fromJson(jsonDecode(jsonString)))
        .toList();
  }
}

// UploadAndTranscribeTask 的 Hive 存储结构
@HiveType(typeId: 10)
class UploadAndTranscribeTaskStorage extends HiveObject {
  @HiveField(0)
  String taskId;

  @HiveField(1)
  String userId;

  @HiveField(2)
  List<String> assetFileNames;

  @HiveField(3)
  List<String> pickedFileNames;

  @HiveField(4)
  String creationTimeIso; // DateTime 转为 ISO 字符串

  @HiveField(5)
  List<String> uploadedFileNames;

  @HiveField(6)
  bool isUploaded;

  @HiveField(7)
  bool isTranscribed;

  UploadAndTranscribeTaskStorage({
    required this.taskId,
    required this.userId,
    required this.assetFileNames,
    required this.pickedFileNames,
    required this.creationTimeIso,
    required this.uploadedFileNames,
    required this.isUploaded,
    required this.isTranscribed,
  });

  // 手动构造方法 - 需要在 UploadAndTranscribeTask 中添加相应的 getter 方法
  static UploadAndTranscribeTaskStorage create({
    required String taskId,
    required String userId,
    required List<String> assetFileNames,
    required List<String> pickedFileNames,
    required DateTime creationTime,
    required List<String> uploadedFileNames,
    required bool isUploaded,
    required bool isTranscribed,
  }) {
    return UploadAndTranscribeTaskStorage(
      taskId: taskId,
      userId: userId,
      assetFileNames: List.from(assetFileNames),
      pickedFileNames: List.from(pickedFileNames),
      creationTimeIso: creationTime.toIso8601String(),
      uploadedFileNames: List.from(uploadedFileNames),
      isUploaded: isUploaded,
      isTranscribed: isTranscribed,
    );
  }

  // 转换为构造数据 Map
  Map<String, dynamic> toConstructorData() {
    return {
      'taskId': taskId,
      'userId': userId,
      'assetFileNames': assetFileNames,
      'pickedFileNames': pickedFileNames,
      'creationTime': DateTime.parse(creationTimeIso),
      'uploadedFileNames': uploadedFileNames,
      'isUploaded': isUploaded,
      'isTranscribed': isTranscribed,
    };
  }
}

// AnalyzeTask 的 Hive 存储结构
@HiveType(typeId: 11)
class AnalyzeTaskStorage extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  String transcribeFileNameData; // 存储 TranscribeFileName 的原始数据

  @HiveField(2)
  String fileName;

  @HiveField(3)
  String dateKey;

  @HiveField(4)
  int statusValue; // AnalyzeTaskStatus.index

  @HiveField(5)
  String? errorMessage;

  @HiveField(6)
  String? uploadResponseMessage;

  @HiveField(7)
  String? analyzeTaskId;

  @HiveField(8)
  String? journalFileResultJson; // JournalFile 序列化为 JSON (可选)

  AnalyzeTaskStorage({
    required this.content,
    required this.transcribeFileNameData,
    required this.fileName,
    required this.dateKey,
    required this.statusValue,
    this.errorMessage,
    this.uploadResponseMessage,
    this.analyzeTaskId,
    this.journalFileResultJson,
  });

  // 手动构造方法
  static AnalyzeTaskStorage create({
    required String content,
    required TranscribeFileName transcribeFileName,
    required String fileName,
    required String dateKey,
    required AnalyzeTaskStatus status,
    String? errorMessage,
    String? uploadResponseMessage,
    String? analyzeTaskId,
    JournalFile? journalFileResult,
  }) {
    return AnalyzeTaskStorage(
      content: content,
      transcribeFileNameData: transcribeFileName.generateFilename(), // 存储文件名字符串
      fileName: fileName,
      dateKey: dateKey,
      statusValue: status.index,
      errorMessage: errorMessage,
      uploadResponseMessage: uploadResponseMessage,
      analyzeTaskId: analyzeTaskId,
      journalFileResultJson:
          journalFileResult != null
              ? jsonEncode(journalFileResult.toJson())
              : null,
    );
  }

  // 转换为构造数据 Map
  Map<String, dynamic> toConstructorData() {
    TranscribeFileName? transcribeFileName;
    try {
      transcribeFileName = TranscribeFileName.tryFromFilename(
        transcribeFileNameData,
      );
    } catch (e) {
      // 如果解析失败，创建一个默认的
      transcribeFileName = TranscribeFileName(
        dateTime: DateTime.now(),
        fileNumber: 0,
        fileSuffix: 'txt',
      );
    }

    return {
      'content': content,
      'transcribeFileName': transcribeFileName,
      'fileName': fileName,
      'dateKey': dateKey,
      'status': AnalyzeTaskStatus.values[statusValue],
      'errorMessage': errorMessage,
      'uploadResponseMessage': uploadResponseMessage,
      'analyzeTaskId': analyzeTaskId,
      'journalFileResult':
          journalFileResultJson != null
              ? JournalFile.fromJson(
                jsonDecode(journalFileResultJson!) as Map<String, dynamic>,
              )
              : null,
    };
  }
}

// UpdateDataTask 的 Hive 存储结构
@HiveType(typeId: 12)
class UpdateDataTaskStorage extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  List<String> assetFileNames;

  @HiveField(2)
  List<String> pickedFileNames;

  @HiveField(3)
  String creationTimeIso; // DateTime 转为 ISO 字符串

  @HiveField(4)
  int statusValue; // UpdateDataTaskStatus.index

  @HiveField(5)
  String? errorMessage;

  @HiveField(6)
  String? transcriptFilePath;

  @HiveField(7)
  UploadAndTranscribeTaskStorage? uploadAndTranscribeTaskStorage;

  @HiveField(8)
  AnalyzeTaskStorage? analyzeTaskStorage;

  UpdateDataTaskStorage({
    required this.userId,
    required this.assetFileNames,
    required this.pickedFileNames,
    required this.creationTimeIso,
    required this.statusValue,
    this.errorMessage,
    this.transcriptFilePath,
    this.uploadAndTranscribeTaskStorage,
    this.analyzeTaskStorage,
  });

  // 手动构造方法
  static UpdateDataTaskStorage create({
    required String userId,
    required List<String> assetFileNames,
    required List<String> pickedFileNames,
    required DateTime creationTime,
    required UpdateDataTaskStatus status,
    String? errorMessage,
    String? transcriptFilePath,
    UploadAndTranscribeTaskStorage? uploadAndTranscribeTaskStorage,
    AnalyzeTaskStorage? analyzeTaskStorage,
  }) {
    return UpdateDataTaskStorage(
      userId: userId,
      assetFileNames: List.from(assetFileNames),
      pickedFileNames: List.from(pickedFileNames),
      creationTimeIso: creationTime.toIso8601String(),
      statusValue: status.index,
      errorMessage: errorMessage,
      transcriptFilePath: transcriptFilePath,
      uploadAndTranscribeTaskStorage: uploadAndTranscribeTaskStorage,
      analyzeTaskStorage: analyzeTaskStorage,
    );
  }

  // 转换为构造数据 Map
  Map<String, dynamic> toConstructorData() {
    return {
      'userId': userId,
      'assetFileNames': assetFileNames,
      'pickedFileNames': pickedFileNames,
      'creationTime': DateTime.parse(creationTimeIso),
      'status': UpdateDataTaskStatus.values[statusValue],
      'errorMessage': errorMessage,
      'transcriptFilePath': transcriptFilePath,
      'uploadAndTranscribeTaskData':
          uploadAndTranscribeTaskStorage?.toConstructorData(),
      'analyzeTaskData': analyzeTaskStorage?.toConstructorData(),
    };
  }
}
