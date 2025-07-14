import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
//import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/main_app.dart';
//import 'package:nirva_app/test_chat_app.dart';
//import 'package:nirva_app/test_graph_view_app.dart';
//import 'package:nirva_app/test_calendar_app.dart';
//import 'package:nirva_app/hive_data.dart';
//import 'package:nirva_app/test_file_access_app.dart'; // 添加这一行
//import 'package:nirva_app/test_sliding_chart_app.dart';
//import 'package:nirva_app/test_aws_amplify_s3_transcribe_app.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  // 这里必须一起调用。
  await _initializeApp(); // 执行异步操作，例如加载配置文件

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalFilesProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
      ],
      child: const MainApp(),
    ),
  );

  //如果需要测试应用，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(TestChatApp());
  //如果需要测试图形视图，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(TestGraphViewApp());
  //如果需要测试日历视图，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(const TestCalendarApp());
  //如果需要测试iOS文件应用访问，可以取消下面的注释
  //runApp(const TestFileAccessApp());
  //如果需要测试图表，可以取消下面的注释
  //runApp(const TestSlidingChartApp());
  //如果需要测试语音转文本，可以取消下面的注释
  //runApp(const TestAWSAmplifyS3TranscribeApp());
}

Future<void> _initializeApp() async {
  // 初始化 Amplify
  await _configureAmplify();

  // 正式步骤：初始化 Hive, 这个是必须调用的，因为本app会使用 Hive 来存储数据。
  await AppRuntimeContext().hiveManager.deleteFromDisk();
  await AppRuntimeContext().hiveManager.initializeAdapters();
}

Future<void> _configureAmplify() async {
  try {
    // 添加 Amplify 插件
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.addPlugin(AmplifyStorageS3());

    // 配置 Amplify
    await Amplify.configure(amplifyconfig);

    safePrint('Successfully configured Amplify');
  } on AmplifyException catch (e) {
    safePrint('Error configuring Amplify: ${e.message}');
  }
}
