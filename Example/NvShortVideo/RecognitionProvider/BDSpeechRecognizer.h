//
//  BDSpeechRecognizer.h
//  NvShortVideo
//
//  火山语音识别 
//
//  Created by meishe on 2024/5/10.
//

#if __has_include(<NvShortVideoCore/NvShortVideoCore.h>)
#import <NvShortVideoCore/NvShortVideoCore.h>
#else
#import "NvShortVideoCore.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BDSpeechRecognizer : NSObject <NvVoiceRecognizer>

@end

NS_ASSUME_NONNULL_END
