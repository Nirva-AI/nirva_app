# Nirva App

A personal management application built with Flutter, supporting task management, note-taking, chat history storage, diary system, and more.

## Features

- **Chat History Management**: Store and manage chat history
- **Task Management**: Create, track, and manage personal tasks
- **Note System**: Write and organize personal notes
- **Diary System**: Create and manage diary files
- **Favorites**: Collect important content
- **User Authentication**: Integrated token management and user authentication
- **Chart Visualization**: Data visualization with FL Chart
- **Graph Visualization**: Display data relationships using GraphView
- **File Management**: Complete file operation features
- **AWS Amplify Integration**: Cloud backend with authentication, storage, and API Gateway

## Tech Stack

- **Flutter**: Cross-platform UI framework
- **Freezed**: For generating immutable objects and serialization
- **Hive**: High-performance NoSQL database
- **Dio**: HTTP networking library
- **Table Calendar**: Calendar functionality
- **FL Chart**: Data charting
- **GraphView**: Graph visualization
- **AWS Amplify**: Cloud backend services (Cognito, S3, API Gateway, Lambda)
- **Others**: UUID, Intl, Permission Handler, etc.

## Supported Platforms

- iOS

## Installation Guide

### Prerequisites

- Flutter SDK (version ^3.7.2)
- Dart SDK (latest version)
- Development IDE (VS Code)
- AWS CLI
- Amplify CLI

### Installation Steps

1. Clone the project locally:

   ```bash
   git clone https://github.com/yourusername/nirva_app.git
   cd nirva_app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate necessary code files:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Download Required ONNX Models** (Required for local speech recognition):

   The app requires ONNX models for local speech recognition and voice activity detection. These models are not included in the repository due to their large size.

   Create the following directory structure and download the required models:

   ```bash
   mkdir -p assets/onnx/whisper_small
   mkdir -p assets/onnx/vad
   ```

   **Whisper Small Model Files** (place in `assets/onnx/whisper_small/`):
   - `small-encoder.onnx` (~107MB) - Whisper encoder model
   - `small-decoder.onnx` (~250MB) - Whisper decoder model  
   - `small-tokens.txt` (~798KB) - Whisper token vocabulary

   **VAD Model File** (place in `assets/onnx/vad/`):
   - `silero_vad_v5.onnx` - Voice Activity Detection model

   **Download Sources:**
   - Whisper models: Convert from Hugging Face using `optimum-cli` or download pre-converted ONNX models
   - VAD model: Download from [Silero VAD releases](https://github.com/snakers4/silero-vad/releases)

   **Note:** These model files are excluded from git tracking via `.gitignore` to prevent repository bloat.

5. Run the app:

   ```bash
   flutter run
   ```

## AWS Amplify Setup

This project uses AWS Amplify for cloud backend services. Follow these steps to configure the Amplify connection:

### 1. Install Required Tools

```bash
# Install AWS CLI
brew install awscli

# Install Amplify CLI (if not already installed)
npm install -g @aws-amplify/cli
```

### 2. Configure AWS Credentials

The project includes AWS credentials in the `credentials/` folder. Configure them:

```bash
# Set AWS access key
aws configure set aws_access_key_id ...

# Set AWS secret key
aws configure set aws_secret_access_key ...

# Set AWS region
aws configure set region ...

# Set output format
aws configure set output json
```

### 3. Verify AWS Connection

```bash
# Test AWS connection
aws s3 ls
```

### 4. Connect to Amplify Backend

```bash
# Check Amplify status
amplify status
```

## Development Guide

### Using Freezed and Hive

This project uses Freezed for data model definition and serialization, and Hive for local data storage. Whenever you modify classes related to Freezed or Hive, you need to regenerate the code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

If you want to automatically generate code when files change, you can use the watch command:

```bash
flutter pub run build_runner watch
```

### Hive Data Storage

Nirva App uses Hive as the local database, mainly storing the following types of data:

- User tokens (`UserToken`)
- Favorites (`Favorites`)
- Chat history (`ChatHistory`, `HiveChatMessage`)
- Diary data (`JournalFileMeta`, `JournalFileIndex`, `JournalFileStorage`)
- Task list (`HiveTasks`)
- Note list (`HiveNotes`)
- Update data tasks (`UpdateDataTask`)

### ONNX Models for Local Speech Recognition

The app includes local speech recognition capabilities using ONNX models:

**Model Architecture:**
- **Whisper Small**: OpenAI's Whisper model converted to ONNX format for local inference
- **Silero VAD**: Voice Activity Detection for real-time audio processing

**Model Files Location:**
```
assets/onnx/
├── whisper_small/
│   ├── small-encoder.onnx    # Whisper encoder (107MB)
│   ├── small-decoder.onnx    # Whisper decoder (250MB)
│   └── small-tokens.txt      # Token vocabulary (798KB)
└── vad/
    └── silero_vad_v5.onnx    # Voice activity detection
```

**Integration:**
- Models are loaded by `SherpaASRService` for speech recognition
- `SherpaVADService` handles voice activity detection
- Models support multiple languages and real-time audio processing

**Note:** These models are excluded from version control. Developers must download them separately as described in the Installation Guide.

## Debugging & Testing

The project includes several test apps for isolated testing of different functional modules:

- `TestChatApp`: Test chat features
- `TestGraphViewApp`: Test graph view
- `TestCalendarApp`: Test calendar view
- `TestFileAccessApp`: Test file access
- `TestSlidingChartApp`: Test chart features
- `TestAWSAmplifyS3TranscribeApp`: Test AWS Amplify integration

To run these test apps, uncomment the corresponding section in [`lib/main.dart`](lib/main.dart).
