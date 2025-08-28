//
//  OpusWrapper.m
//  Runner
//

#import "OpusWrapper.h"

#if !TARGET_OS_SIMULATOR
#import <libopus-static/opus.h>
#endif

@implementation OpusWrapper

+ (void*)createDecoderWithSampleRate:(int32_t)sampleRate channels:(int32_t)channels error:(int32_t*)error {
#if TARGET_OS_SIMULATOR
    NSLog(@"OpusWrapper: Opus decoding is not available in simulator");
    if (error) *error = -1;
    return NULL;
#else
    return opus_decoder_create(sampleRate, channels, error);
#endif
}

+ (void)destroyDecoder:(void*)decoder {
#if !TARGET_OS_SIMULATOR
    if (decoder) {
        opus_decoder_destroy((OpusDecoder*)decoder);
    }
#endif
}

+ (int32_t)decode:(void*)decoder input:(const unsigned char*)input inputLength:(int32_t)inputLength output:(int16_t*)output outputLength:(int32_t)outputLength decodeFec:(int)decodeFec {
#if TARGET_OS_SIMULATOR
    return -1;
#else
    if (!decoder) return -1;
    return opus_decode((OpusDecoder*)decoder, input, inputLength, output, outputLength, decodeFec);
#endif
}

+ (int32_t)decoderCtl:(void*)decoder request:(int)request {
#if TARGET_OS_SIMULATOR
    return -1;
#else
    if (!decoder) return -1;
    return opus_decoder_ctl((OpusDecoder*)decoder, request);
#endif
}

@end