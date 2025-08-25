//
//  OpusWrapper.m
//  Runner
//

#import "OpusWrapper.h"
#import <libopus-static/opus.h>

@implementation OpusWrapper

+ (void*)createDecoderWithSampleRate:(int32_t)sampleRate channels:(int32_t)channels error:(int32_t*)error {
    return opus_decoder_create(sampleRate, channels, error);
}

+ (void)destroyDecoder:(void*)decoder {
    if (decoder) {
        opus_decoder_destroy((OpusDecoder*)decoder);
    }
}

+ (int32_t)decode:(void*)decoder input:(const unsigned char*)input inputLength:(int32_t)inputLength output:(int16_t*)output outputLength:(int32_t)outputLength decodeFec:(int)decodeFec {
    if (!decoder) return -1;
    return opus_decode((OpusDecoder*)decoder, input, inputLength, output, outputLength, decodeFec);
}

+ (int32_t)decoderCtl:(void*)decoder request:(int)request {
    if (!decoder) return -1;
    return opus_decoder_ctl((OpusDecoder*)decoder, request);
}

@end