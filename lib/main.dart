import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/providers/call_provider.dart';
import 'package:nirva_app/services/hardware_service.dart';
import 'package:nirva_app/services/hardware_audio_recorder.dart';
import 'package:nirva_app/services/audio_streaming_service.dart';
import 'package:nirva_app/providers/local_audio_provider.dart';
import 'package:nirva_app/providers/cloud_audio_provider.dart';
import 'package:nirva_app/services/app_settings_service.dart';
//import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/main_app.dart';
//import 'package:nirva_app/test_chat_app.dart';
//import 'package:nirva_app/test_graph_view_app.dart';
//import 'package:nirva_app/test_calendar_app.dart';
//import 'package:nirva_app/hive_data.dart';
//import 'package:nirva_app/test_file_access_app.dart'; // 添加这一行
//import 'package:nirva_app/test_sliding_chart_app.dart';
//import 'package:nirva_app/test_aws_amplify_s3_transcribe_app.dart';
//import 'package:nirva_app/test_hardware_integration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'amplifyconfiguration.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart'; // Import sherpa_onnx for initBindings


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成
  
  // Initialize sherpa_onnx native bindings before any VAD/ASR objects are created
  initBindings();
  debugPrint('Main: sherpa_onnx bindings initialized');

  // 这里必须一起调用。
  await _initializeApp(); // 执行异步操作，例如加载配置文件

  // Initialize HardwareService first
  final hardwareService = HardwareService();
  await hardwareService.initialize();
  debugPrint('Main: HardwareService initialized successfully');
  
  // Initialize AppSettingsService
  final appSettingsService = AppSettingsService();
  await appSettingsService.initialize();
  debugPrint('Main: AppSettingsService initialized successfully');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => UserProvider(
                id: "1eaade33-f351-461a-8f73-59a11cba04f9", // 这个ID是测试用的，必须和服务器对上。
                username: 'weilyupku@gmail.com',
                password: 'secret',
                displayName: 'wei',
              ),
        ),
        ChangeNotifierProvider(create: (_) => JournalFilesProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider.value(value: hardwareService),
        ChangeNotifierProvider.value(value: appSettingsService),
        // Only create providers based on ASR mode setting
        ChangeNotifierProxyProvider<AppSettingsService, LocalAudioProvider?>(
          create: (context) {
            final settings = context.read<AppSettingsService>();
            return settings.localAsrEnabled ? LocalAudioProvider() : null;
          },
          update: (_, settings, previous) {
            if (settings.localAsrEnabled) {
              return previous ?? LocalAudioProvider();
            } else {
              previous?.dispose();
              return null;
            }
          },
        ),
        ChangeNotifierProxyProvider<AppSettingsService, CloudAudioProvider?>(
          create: (context) {
            final settings = context.read<AppSettingsService>();
            if (settings.cloudAsrEnabled) {
              // Get the OpusDecoderService from HardwareService to avoid multiple initialization
              final hardwareService = context.read<HardwareService>();
              return CloudAudioProvider(opusDecoderService: hardwareService.opusDecoder);
            }
            return null;
          },
          update: (_, settings, previous) {
            if (settings.cloudAsrEnabled) {
              return previous; // Keep existing instance
            } else {
              previous?.dispose();
              return null;
            }
          },
        ),
        ChangeNotifierProxyProvider<HardwareService, HardwareAudioCapture>(
          create: (context) {
            final localAudioProvider = context.read<LocalAudioProvider?>();
            final cloudAudioProvider = context.read<CloudAudioProvider?>();
            final settingsService = context.read<AppSettingsService>();
            final audioCapture = HardwareAudioCapture(
              context.read<HardwareService>(),
              localAudioProvider?.localAudioProcessor,
              cloudAudioProvider?.cloudProcessor,
              settingsService,
            );
            
            // Set the local audio processor in the hardware service if available
            if (localAudioProvider != null) {
              context.read<HardwareService>().setLocalAudioProcessor(
                localAudioProvider.localAudioProcessor,
              );
            }
            
            // Enable audio processing when hardware connects
            context.read<HardwareService>().addListener(() async {
              if (context.read<HardwareService>().isConnected) {
                // Initialize cloud provider if needed (local initializes automatically)
                if (cloudAudioProvider != null && !cloudAudioProvider.isInitialized) {
                  await cloudAudioProvider.initialize();
                }
                
                // Now enable processing
                localAudioProvider?.enableProcessing();
                cloudAudioProvider?.enableProcessing();
              }
            });
            
            return audioCapture;
          },
          update: (_, hardwareService, previous) => 
              previous ?? HardwareAudioCapture(
                hardwareService,
                null, // We'll set this later when needed
                null, // Cloud processor will be set later
                null, // Settings service will be set later
              ),
        ),
        ChangeNotifierProvider<AudioStreamingService>(
          create: (context) => AudioStreamingService(
            context.read<HardwareAudioCapture>(),
            context.read<UserProvider>().id,
          ),
        ),
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
  //如果需要测试硬件集成，可以取消下面的注释
  //runApp(const TestHardwareIntegration());
}

Future<void> _initializeApp() async {
  // Load environment variables from assets
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('Main: Environment variables loaded successfully');
    debugPrint('Main: DEEPGRAM_API_KEY available: ${dotenv.env['DEEPGRAM_API_KEY'] != null ? 'Yes' : 'No'}');
  } catch (e) {
    debugPrint('Main: Warning - Could not load .env file: $e');
    debugPrint('Main: To use Deepgram API, ensure .env file is in assets and contains DEEPGRAM_API_KEY');
    // Initialize with empty values to prevent NotInitializedError
    await dotenv.load(fileName: '.env', mergeWith: {'DEEPGRAM_API_KEY': ''});
  }
  
  // 初始化 Amplify
  await _configureAmplify();

  // 正式步骤：初始化 Hive, 这个是必须调用的，因为本app会使用 Hive 来存储数据。
  await HiveHelper.initializeHive();
  await HiveHelper.deleteFromDisk(); // 这句是测试用的。
  await HiveHelper.initializeAdapters();
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
