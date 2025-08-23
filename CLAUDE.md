# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# Generate code for Freezed/Hive models (required after model changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for automatic code generation during development
flutter pub run build_runner watch
```

### Running the Application
```bash
# Run the app (will auto-select connected device)
flutter run

# Run with specific device
flutter run -d [device_id]
```

### Building
```bash
# Build for iOS (primary platform)
flutter build ios

# Build for Android
flutter build apk

# Build for other platforms
flutter build web
flutter build macos
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

## Architecture

### Layered Architecture
The app follows a clean layered architecture:
- **UI Layer** (`lib/pages/`, `lib/widgets/`) - Flutter UI components
- **Provider Layer** (`lib/providers/`) - State management using Provider pattern
- **Service Layer** (`lib/services/`) - Business logic and hardware integration
- **Data Layer** (`lib/models/`, `lib/api_models.dart`) - Data models and persistence

### Key Services

**Hardware & Audio Processing:**
- (Building the new flow right now, don't over indexed on existing files)

**Data Services:**
- `AppSettingsService` - Application configuration management
- `TranscriptionSyncService` - Syncs transcriptions between local and cloud storage

### iOS Native Integration
The iOS Runner contains critical native code:
- `AppDelegate.swift` - Manages background processing and Bluetooth wake events
- `BleAudioService.swift` - Native BLE audio handling
- `BleAudioPlugin.swift` - Flutter method channel bridge

Background audio processing is handled through iOS background modes and continues when the app is backgrounded.

### Data Storage
- **Local Storage:** Hive database for user data, chat history, tasks, notes
- **Cloud Storage:** AWS S3 for audio files and large assets
- **Settings:** SharedPreferences for simple key-value configuration

### Audio Processing Pipeline
1. BLE device streams Opus-encoded audio packets
2. `BleAudioService` receives and decodes audio
3. Audio is processed in parallel:
   - Local ASR (Sherpa ONNX) for immediate feedback
   - Cloud ASR (AWS/Deepgram) for higher accuracy
4. Results stored in Hive and synced to cloud
5. UI updates via Provider state management

### Model Generation
Models use Freezed for immutability and JSON serialization. After modifying any model files with `@freezed` or `@HiveType` annotations, regenerate code using build_runner.

### AWS Integration
The app uses AWS Amplify for backend services:
- Authentication via Cognito
- Storage via S3
- APIs via API Gateway and Lambda
- Requires proper AWS credentials configuration