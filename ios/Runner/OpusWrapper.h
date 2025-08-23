//
//  OpusWrapper.h
//  Runner
//

#ifndef OpusWrapper_h
#define OpusWrapper_h

#import <Foundation/Foundation.h>

@interface OpusWrapper : NSObject

+ (void*)createDecoderWithSampleRate:(int32_t)sampleRate channels:(int32_t)channels error:(int32_t*)error;
+ (void)destroyDecoder:(void*)decoder;
+ (int32_t)decode:(void*)decoder input:(const unsigned char*)input inputLength:(int32_t)inputLength output:(int16_t*)output outputLength:(int32_t)outputLength decodeFec:(int)decodeFec;
+ (int32_t)decoderCtl:(void*)decoder request:(int)request;

@end

#endif /* OpusWrapper_h */