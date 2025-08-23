// This file ensures all Swift files are compiled together
// It's a temporary workaround for Xcode project file issues

import Foundation
import Flutter

// Import all our custom classes to ensure they're compiled
// Note: These aren't actual imports but references to ensure compilation

@available(iOS 13.0, *)
internal class _CompileHelper {
    // Reference all our custom classes to ensure they're included in the build
    private let _1 = BleAudioService.self
    private let _2 = BleAudioPlugin.self
    private let _3 = BleAudioServiceV2.self
    private let _4 = BleAudioPluginV2.self
    private let _5 = ConnectionOrchestrator.self
    private let _6 = PacketReassembler.self
    private let _7 = OpusDecoder.self
    private let _8 = AudioProcessor.self
    private let _9 = VoiceActivityDetector.self
    private let _10 = DebugLogger.self
}