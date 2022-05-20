//
//  QXWaveFormView.h
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAsset;

@interface QXWaveFormView : UIView

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) UIColor *waveColor;

@end

NS_ASSUME_NONNULL_END
