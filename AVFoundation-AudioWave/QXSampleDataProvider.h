//
//  QXSampleDataProvider.h
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/17.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QXSampleDataCompletionBlock)(NSData *data);

@interface QXSampleDataProvider : NSObject

+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset completionBlock:(QXSampleDataCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
