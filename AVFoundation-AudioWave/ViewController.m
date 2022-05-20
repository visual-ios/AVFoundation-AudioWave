//
//  ViewController.m
//  AVFoundation-AudioWave
//
//  Created by 秦菥 on 2022/5/17.
//

#import "ViewController.h"
#import "QXWaveFormView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QXWaveFormView *waveFormView = [[QXWaveFormView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:waveFormView];
    waveFormView.waveColor = [UIColor blueColor];
    NSURL *beatURL  = [[NSBundle mainBundle] URLForResource:@"beat"
                                              withExtension:@"aiff"];
    waveFormView.asset = [AVURLAsset assetWithURL:beatURL];
}


@end
