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
// DISABLED: Old Amplify flow - using native S3 upload instead
// import 'package:nirva_app/services/audio_streaming_service.dart';

import 'package:nirva_app/providers/cloud_audio_provider.dart';
import 'package:nirva_app/providers/transcription_sync_provider.dart';
import 'package:nirva_app/providers/events_provider.dart';
import 'package:nirva_app/providers/mental_state_provider.dart';
import 'package:nirva_app/services/app_settings_service.dart';
import 'package:nirva_app/services/ios_background_audio_manager.dart';
import 'package:nirva_app/services/app_lifecycle_logging_service.dart';
import 'package:nirva_app/services/native_s3_bridge.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart'; // Import sherpa_onnx for initBindings
import 'package:hive/hive.dart'; // Import hive for checking boxes
import 'package:nirva_app/my_hive_objects.dart'; // Import my_hive_objects for CloudAsrResultStorage and CloudAsrSessionStorage
import 'package:nirva_app/utils/timezone_utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成
  
  // Initialize timezone data
  TimezoneUtils.initialize();
  
  // Initialize sherpa_onnx native bindings before any VAD/ASR objects are created
  initBindings();

  // 这里必须一起调用。
  await _initializeApp(); // 执行异步操作，例如加载配置文件

  // Initialize HardwareService first
  final hardwareService = HardwareService();
  await hardwareService.initialize();
  
  // Initialize device persistence and attempt reconnection
  await hardwareService.initializeDevicePersistence();
  
  // Create HardwareAudioCapture immediately to enable automatic recording
  final hardwareAudioCapture = HardwareAudioCapture(
    hardwareService,
    null, // Cloud audio processor will be set later
    null, // Settings service will be set later
  );
  
  // Set the audio capture service in the hardware service for automatic recording
  hardwareService.setAudioCapture(hardwareAudioCapture);
  
  // Initialize AppSettingsService
  final appSettingsService = AppSettingsService();
  await appSettingsService.initialize();
  
  // Initialize AppLifecycleLoggingService
  final lifecycleLoggingService = AppLifecycleLoggingService();
  await lifecycleLoggingService.initialize();
  
  // Initialize NativeS3Bridge for S3 upload credentials
  try {
    await NativeS3Bridge.instance.initialize();
  } catch (e) {
    debugPrint('Main: Error initializing NativeS3Bridge: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => UserProvider(
                id: "", // Will be populated after login
                username: '',
                password: '',
                displayName: '',
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
        ChangeNotifierProvider<IosBackgroundAudioManager>(
          create: (_) => IosBackgroundAudioManager(),
        ),
        ChangeNotifierProvider<CloudAudioProvider>(
          create: (context) {
            // Get the OpusDecoderService from HardwareService to avoid multiple initialization
            final hardwareService = context.read<HardwareService>();
            final userProvider = context.read<UserProvider>();
            final cloudProvider = CloudAudioProvider(
              opusDecoderService: hardwareService.opusDecoder,
              userId: userProvider.id,
            );
            // Initialize immediately so it's ready when hardware connects
            cloudProvider.initialize();
            return cloudProvider;
          },
        ),
        ChangeNotifierProvider<HardwareAudioCapture>.value(
          value: hardwareAudioCapture,
        ),
        // DISABLED: Old Amplify flow - using native S3 upload instead
        // ChangeNotifierProvider<AudioStreamingService>(
        //   create: (context) => AudioStreamingService(
        //     context.read<HardwareAudioCapture>(),
        //     context.read<UserProvider>().id,
        //   ),
        // ),
        ChangeNotifierProvider<TranscriptionSyncProvider>(
          create: (context) => TranscriptionSyncProvider(),
        ),
        ChangeNotifierProvider<EventsProvider>(
          create: (context) => EventsProvider(),
        ),
        ChangeNotifierProvider<MentalStateProvider>(
          create: (context) => MentalStateProvider(),
        ),
              ],
        child: Builder(
          builder: (context) {
            // Update HardwareAudioCapture with providers when they become available
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final settingsService = context.read<AppSettingsService>();
              final cloudProvider = context.read<CloudAudioProvider>();
              final syncProvider = context.read<TranscriptionSyncProvider>();

              // Initialize the sync provider
              await syncProvider.initialize();

              // Connect sync provider to cloud audio processor
              cloudProvider.cloudProcessor.setSyncProvider(syncProvider);

              hardwareAudioCapture.updateProviders(
                cloudProvider.cloudProcessor,
                settingsService,
              );
            });
            
            return const MainApp();
          },
        ),
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
  } catch (e) {
    debugPrint('Main: Warning - Could not load .env file: $e');
    // Initialize with empty values to prevent NotInitializedError
    await dotenv.load(fileName: '.env', mergeWith: {'DEEPGRAM_API_KEY': ''});
  }

  // 正式步骤：初始化 Hive, 这个是必须调用的，因为本app会使用 Hive 来存储数据。
  await HiveHelper.initializeHive();
  // await HiveHelper.deleteFromDisk(); // 这句是测试用的。 COMMENTED OUT TO PRESERVE DATA
  await HiveHelper.initializeAdapters();
  
  try {
    final cloudAsrResultsBox = Hive.box<CloudAsrResultStorage>('cloudAsrResultsBox');
    final cloudAsrSessionsBox = Hive.box<CloudAsrSessionStorage>('cloudAsrSessionsBox');
  } catch (e) {
    debugPrint('Main: Error checking Cloud ASR boxes: $e');
  }
}
