//
//  QXSampleDataProvider.m
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/17.
//

#import "QXSampleDataProvider.h"

@implementation QXSampleDataProvider

+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset completionBlock:(QXSampleDataCompletionBlock)completionBlock
{
    NSString *tracks = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{
       
        AVKeyValueStatus status = [asset statusOfValueForKey:tracks error:nil];
        
        NSData *sampleData = nil;
        if (status == AVKeyValueStatusLoaded) {
            sampleData = [self readAudioSampleFromAsset:asset];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sampleData);
        });
    }];
}

+ (NSData *)readAudioSampleFromAsset:(AVAsset *)asset
{
    NSError *error = nil;
    
    AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    if (!assetReader) {
        NSLog(@"Error creating asset reader: %@",error.localizedDescription);
        return nil;
    }
    
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSDictionary *outputSettings = @{
        AVFormatIDKey               : @(kAudioFormatLinearPCM),
        AVLinearPCMIsBigEndianKey   : @NO,//是否是大端，移动端是小端模式
        AVLinearPCMIsFloatKey       : @NO,//是否使用浮点采样
        AVLinearPCMBitDepthKey      : @(16)
    };
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:outputSettings];
    [assetReader addOutput:trackOutput];
    [assetReader startReading];
    
    NSMutableData *sampleData = [NSMutableData data];
    
    while (assetReader.status == AVAssetReaderStatusReading) {
        
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        
        if (sampleBuffer) {
            
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, sampleBytes);
            
            [sampleData appendBytes:sampleBytes length:length];
            
            CMSampleBufferInvalidate(sampleBuffer);
            CFRelease(sampleBuffer);
        }
    }
    
    if (assetReader.status == AVAssetReaderStatusCompleted) {
        return sampleData;
    } else {
        NSLog(@"readAudioSampleFromAsset error");
        return nil;
    }
    
}
@end
