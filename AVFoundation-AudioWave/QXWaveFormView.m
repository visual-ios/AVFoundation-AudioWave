//
//  QXWaveFormView.m
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/18.
//

#import "QXWaveFormView.h"
#import "QXSampleDataFilter.h"
#import "QXSampleDataProvider.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat QXWidthScaling = 0.95;
static const CGFloat QXHeightScaling = 0.85;

@interface QXWaveFormView()
@property (nonatomic, strong) QXSampleDataFilter *filter;
@end

@implementation QXWaveFormView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.waveColor = [UIColor whiteColor];
}

- (void)setWaveColor:(UIColor *)waveColor
{
    _waveColor = waveColor;
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = waveColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setAsset:(AVAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
        [QXSampleDataProvider loadAudioSamplesFromAsset:self.asset completionBlock:^(NSData * _Nonnull data) {
            self.filter = [[QXSampleDataFilter alloc] initWithData:data];
            [self setNeedsDisplay];
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, QXWidthScaling, QXHeightScaling);
    
    CGFloat xOffset = self.bounds.size.width -
                     (self.bounds.size.width * QXWidthScaling);
    
    CGFloat yOffset = self.bounds.size.height -
                     (self.bounds.size.height * QXHeightScaling);
    
    CGContextTranslateCTM(context, xOffset / 2, yOffset / 2);

    NSArray *filteredSamples =                                              // 2
        [self.filter filteredSamplesForSize:self.bounds.size];
    
    CGFloat midY = CGRectGetMidY(rect);
    
    CGMutablePathRef halfPath = CGPathCreateMutable();                      // 3
    CGPathMoveToPoint(halfPath, NULL, 0.0f, midY);

    for (NSUInteger i = 0; i < filteredSamples.count; i++) {
        float sample = [filteredSamples[i] floatValue];
        CGPathAddLineToPoint(halfPath, NULL, i, midY - sample);
    }
    
    CGPathAddLineToPoint(halfPath, NULL, filteredSamples.count, midY);

    CGMutablePathRef fullPath = CGPathCreateMutable();                      // 4
    CGPathAddPath(fullPath, NULL, halfPath);

    CGAffineTransform transform = CGAffineTransformIdentity;                // 5
    transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(rect));
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGPathAddPath(fullPath, &transform, halfPath);

    CGContextAddPath(context, fullPath);                                    // 6
    CGContextSetFillColorWithColor(context, self.waveColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPathRelease(halfPath);                                                // 7
    CGPathRelease(fullPath);
}
@end
