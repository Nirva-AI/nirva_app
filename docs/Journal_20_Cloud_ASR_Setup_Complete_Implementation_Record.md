# 日志20：Cloud ASR Setup Complete Implementation Record

This journal documents the complete implementation and setup of the Cloud ASR feature that combines local VAD with Deepgram transcription.

## Overview

The Cloud ASR feature adds a cloud-based audio processing pipeline alongside the existing local VAD+ASR flow:

1. **Local VAD**: Detects speech segments with a 3-second wait time before closing
2. **Cloud ASR**: Sends detected segments to Deepgram for transcription
3. **Dual Pipeline**: Both local and cloud processing run simultaneously

## Implementation Status: ✅ COMPLETE

The feature has been fully implemented and tested successfully.

## Setup Requirements

### 1. Deepgram API Key

You need a Deepgram API key to use the cloud transcription:

1. Sign up at [https://developers.deepgram.com/](https://developers.deepgram.com/)
2. Get your API key from the dashboard
3. Create a `.env` file in the `assets/` directory with:
   ```
   DEEPGRAM_API_KEY=your_actual_api_key_here
   ```
4. Ensure the `.env` file is listed in `pubspec.yaml` assets section

### 2. Dependencies

The following dependencies are already included in `pubspec.yaml`:
- `http: ^1.1.0` - For API calls
- `path_provider: ^2.0.14` - For temporary file management
- `flutter_dotenv: ^5.1.0` - For environment variable loading

## How It Works

### Audio Processing Flow

1. **Hardware Audio Capture**: Audio is captured from hardware devices via Bluetooth
2. **Opus Decoding**: Opus-encoded audio is decoded to 16-bit PCM format
3. **Local VAD Processing**: VAD detects speech segments with 3-second silence threshold
4. **Segment Creation**: When speech ends, a WAV file is created from the segment
5. **Cloud Transcription**: WAV file is sent to Deepgram API asynchronously
6. **Result Display**: Transcription results are shown in the Cloud ASR tab

### VAD Configuration

- **Sample Rate**: 16kHz (matches OMI firmware)
- **Channels**: Mono
- **Silence Threshold**: 3 seconds before closing a segment
- **Speech Duration**: Minimum 0.3 seconds
- **Model**: Silero VAD v5 (local processing)

### File Management

- Temporary WAV files are created in the app's temporary directory
- Files are automatically cleaned up after transcription
- WAV format: 16-bit PCM, 16kHz, mono, little-endian

## Technical Implementation

### Services Architecture

- **`DeepgramService`**: Handles API communication with Deepgram
  - Uses direct HTTP POST with WAV file in request body
  - Content-Type: audio/wav
  - Model: nova-2 with detect_language: true
  - Automatic language detection support

- **`CloudAudioProcessor`**: Combines VAD with cloud transcription
  - Integrates with SherpaVadService for speech detection
  - Creates WAV files using OpusDecoderService
  - Manages segment lifecycle and cleanup

- **`OpusDecoderService`**: Handles audio format conversion
  - Decodes Opus to 16-bit PCM
  - Creates proper WAV headers with correct file size calculations
  - Ensures little-endian byte order

### Integration Points

- **`HardwareAudioCapture`**: Now supports both local and cloud processors
- **`HardwareRecordingPage`**: UI shows both pipelines in tabs
- **`main.dart`**: Providers are configured for both pipelines
- **Environment Loading**: Automatic .env file loading for API keys

### API Configuration

```dart
// Deepgram API endpoint
static const String _baseUrl = 'https://api.deepgram.com/v1/listen';

// Request parameters
final uri = Uri.parse(_baseUrl).replace(queryParameters: {
  'model': 'nova-2', // Multi-language model
  'detect_language': 'true', // Enable auto-detection
});

// Request format
final request = http.Request('POST', uri);
request.headers['Authorization'] = 'Token $_apiKey';
request.headers['Content-Type'] = 'audio/wav';
request.bodyBytes = audioBytes; // WAV file data
```

## Usage

### 1. Start Recording

1. Connect your hardware device via Bluetooth
2. Navigate to the Audio Recording page
3. Click "Start Recording"
4. Speak into the device

### 2. View Results

The page now has two tabs:

- **Local ASR**: Shows local VAD+ASR results (existing functionality)
- **Cloud ASR**: Shows cloud-based transcription results with language detection

### 3. Monitor Status

The Cloud ASR tab shows:
- Processing status
- API key configuration status
- Number of results
- Individual transcription items with timestamps
- Detected language information

## Troubleshooting

### Common Issues & Solutions

1. **API Key Not Configured**
   - Error: "Cannot transcribe - API key not configured"
   - Solution: Create `.env` file in assets directory with DEEPGRAM_API_KEY

2. **400 Bad Request Errors**
   - Error: "Bad Request: Invalid data received"
   - Solution: WAV file format issues - now fixed with proper header calculation

3. **Model/Language Combination Errors**
   - Error: "No such model/language/tier combination found"
   - Solution: Use correct model names (nova-2) and valid parameters

4. **No Results Appearing**
   - Ensure cloud audio processing is enabled
   - Check that VAD is detecting speech
   - Verify Deepgram service is initialized
   - Check internet connectivity

### Debug Information

The system provides comprehensive logging:
- PCM data validation
- WAV file creation details
- API request/response information
- Error details with request IDs

## Performance Characteristics

- **Cloud transcription**: Asynchronous, doesn't block main thread
- **VAD processing**: Local, real-time responsiveness
- **File management**: Automatic cleanup of temporary files
- **Network timeout**: 5 minutes for API requests
- **Memory usage**: Efficient buffer management with size limits

## Language Support

- **Model**: nova-2 (supports 100+ languages)
- **Auto-detection**: Automatically identifies spoken language
- **Multi-language**: Handles mixed-language content
- **Accent support**: Better handling of various accents and dialects

## File Format Details

### WAV File Specification
- **Format**: 16-bit PCM, little-endian
- **Sample Rate**: 16kHz
- **Channels**: Mono
- **Header**: 44 bytes with correct file size calculations
- **Data**: Raw PCM samples in proper byte order

### PCM Data Processing
- **Source**: Opus-decoded audio from hardware
- **Validation**: Sample range clamping (-32768 to 32767)
- **Conversion**: Int16List to Uint8List with proper endianness

## Security Considerations

- API keys stored in .env file (not committed to git)
- Temporary files cleaned up automatically
- No persistent storage of audio data
- Network requests use HTTPS

## Future Enhancements

Potential improvements for production use:

1. **Audio Compression**: Compress audio before sending to reduce bandwidth
2. **Batch Processing**: Group multiple segments for batch transcription
3. **Caching**: Cache transcription results to avoid re-processing
4. **Fallback**: Fall back to local ASR if cloud service is unavailable
5. **Rate Limiting**: Implement API rate limiting and retry logic

## Testing Results

✅ **Hardware Integration**: Bluetooth audio capture working
✅ **VAD Processing**: Speech detection with 3-second delay working
✅ **WAV Creation**: Proper file format with correct headers
✅ **API Communication**: Deepgram API calls successful
✅ **Language Detection**: Multi-language support working
✅ **Error Handling**: Proper error messages and logging
✅ **File Cleanup**: Temporary file management working

## Support & Maintenance

For issues or questions:
1. Check the console logs for detailed error messages
2. Verify your Deepgram API key and quota
3. Ensure all dependencies are properly installed
4. Check network connectivity for API calls
5. Monitor Deepgram API status and billing

## Conclusion

The Cloud ASR feature is now fully functional and provides:
- High-quality transcription via Deepgram's nova-2 model
- Automatic language detection for 100+ languages
- Seamless integration with existing local VAD pipeline
- Robust error handling and logging
- Efficient file management and cleanup

The implementation successfully combines local speech detection with cloud-based transcription, providing users with both real-time VAD feedback and high-accuracy transcription results.
