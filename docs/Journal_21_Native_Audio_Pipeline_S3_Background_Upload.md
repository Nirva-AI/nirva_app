# Journal 21: Native Audio Pipeline with S3 Background Upload

Date: August 25, 2025

## Overview

This journal documents the implementation of the native iOS audio processing pipeline with background S3 uploads, addressing critical issues with background execution and file uploads.

## Problem Statement

The app needed to:
1. Process audio from BLE devices in the background continuously
2. Upload audio segments to S3 while app is backgrounded
3. Handle iOS background execution limitations
4. Ensure uploads complete even when app is suspended

## Key Issues Discovered

### 1. Background URLSession Behavior
- iOS queues background upload tasks but doesn't immediately transmit data
- Tasks show state=running but are actually suspended until optimal conditions
- Even with `isDiscretionary = false`, iOS delays actual network transmission

### 2. Session Recreation Problem
When iOS wakes the app for background URLSession events:
- The session MUST be recreated with the same identifier BEFORE storing completion handler
- Without this, iOS cannot deliver task completion events
- This was causing orphaned tasks that never completed

### 3. Rate Limiting Issue
- Initial 2-minute rate limiter prevented background uploads
- iOS suspends apps after ~30 seconds of background execution
- Delayed uploads never executed until app returned to foreground

## Solution Implemented

### 1. Core Architecture Changes

#### S3BackgroundUploader.swift
- Made `backgroundSession` optional to handle recreation
- Added `recreateSessionIfNeeded()` method for background wake events
- Removed rate limiting in background mode entirely
- Added infinite retry with exponential backoff (never gives up)
- Force immediate upload execution with:
  - `task.priority = URLSessionTask.highPriority`
  - `session.flush()` to force immediate processing
  - `networkServiceType = .responsiveData` for higher priority

#### AppDelegate.swift
```swift
// Critical fix in handleEventsForBackgroundURLSession
if identifier == "com.nirva.s3upload" {
    // MUST recreate session FIRST
    S3BackgroundUploader.shared.recreateSessionIfNeeded()
    // THEN store completion handler
    S3BackgroundUploader.shared.backgroundCompletionHandler = completionHandler
}
```

### 2. Configuration Settings

#### URLSessionConfiguration
```swift
config.isDiscretionary = false  // Must be false for immediate uploads
config.sessionSendsLaunchEvents = true  // Required for background callbacks
config.waitsForConnectivity = false  // Don't wait - start immediately
config.networkServiceType = .responsiveData  // Higher priority
config.allowsConstrainedNetworkAccess = true
config.allowsExpensiveNetworkAccess = true
```

### 3. Background Processing Flow

1. **Audio Segment Created** (BleAudioServiceV2)
   - Saves WAV file locally
   - Queues upload with S3BackgroundUploader

2. **Upload Queued** (S3BackgroundUploader)
   - If credentials available: process immediately
   - If not: wait for credentials, then process

3. **Background Upload**
   - No rate limiting applied
   - High priority task created
   - Session flushed to force immediate execution
   - Background task requested for extra time

4. **Completion Handling**
   - Success: Delete local file, remove from queue
   - Failure: Exponential backoff retry (2s, 4s, 8s, 16s, max 30s)
   - Never gives up - keeps retrying indefinitely

## Testing Results

### Before Fix
- Uploads queued but didn't execute in background
- Tasks suspended until app returned to foreground
- 2-minute delays prevented any background execution

### After Fix
- Uploads start immediately in background
- Complete successfully while app is backgrounded
- Reliable retry mechanism for failures
- No lost audio segments

## Key Learnings

1. **iOS Background URLSession is Complex**
   - Just creating tasks doesn't guarantee execution
   - Must use correct configuration and force processing
   - Session recreation is critical for wake events

2. **Rate Limiting Incompatible with iOS Background**
   - iOS gives limited background execution time (~30 seconds)
   - Any delays prevent uploads from completing
   - Must process immediately in background

3. **Logging is Critical**
   - DebugLogger essential for debugging background issues
   - Can't rely on console output when unplugged
   - Must log state transitions and error details

## Files Modified

1. **iOS Native**
   - `ios/Runner/S3BackgroundUploader.swift` - Complete rewrite for background reliability
   - `ios/Runner/AppDelegate.swift` - Fixed session recreation on wake
   - `ios/Runner/BleAudioServiceV2.swift` - Audio processing pipeline
   - `ios/Runner/ConnectionOrchestrator.swift` - BLE connection management
   - `ios/Runner/Info.plist` - Added background modes

2. **Flutter/Dart**
   - `lib/services/native_s3_bridge.dart` - Triggers uploads after credentials
   - Various UI updates for testing and monitoring

## Background Modes Required

```xml
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>  <!-- BLE wake events -->
    <string>fetch</string>              <!-- Background fetch -->
    <string>processing</string>         <!-- Background processing -->
    <string>remote-notification</string> <!-- Remote notifications -->
</array>
```

## Testing Procedure

1. Fresh app install
2. Connect to BLE device
3. Background the app
4. Monitor DebugLogger output for:
   - "⚡ BACKGROUND MODE - Processing uploads immediately"
   - "🔥 Forced session flush in BACKGROUND"
   - "✅ SUCCESS - HTTP 200"
5. Verify uploads complete without reopening app

## Known Limitations

1. iOS may still throttle after excessive background activity
2. Battery optimization may affect long-term background execution
3. Network conditions can delay uploads (but they will retry)

## Future Improvements

1. Consider implementing server-side push to trigger uploads
2. Add telemetry for upload success rates
3. Implement batch upload optimization
4. Add user-visible upload queue status

## Conclusion

The native audio pipeline with S3 background upload is now working reliably. The key was understanding iOS's background URLSession behavior and implementing proper session management, removing rate limiting, and forcing immediate execution. The system now successfully processes and uploads audio segments even when the app is completely backgrounded.