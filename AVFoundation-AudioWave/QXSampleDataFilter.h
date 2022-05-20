//
//  QXSampleDataFilter.h
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/18.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXSampleDataFilter : NSObject

- (instancetype)initWithData:(NSData *)sampleData;

- (NSArray *)filteredSamplesForSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
