//
//  TYCountingViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/10/23.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYCountingViewController.h"
#import "TYCountingView.h"


@interface TYCountingViewController () {
    
    UIButton *backBtn;
    UIButton *helpBtn;
    TYCountingView *countingView;
    
    int mTimes;
    int mCountdown;
    int currentTimes;
}
@end

@implementation TYCountingViewController

- (instancetype)initWithTimes:(int)times countdown:(int)countdown
{
    self = [super init];
    if (self) {
        mTimes = times;
        mCountdown = countdown;
        currentTimes = times;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    
    [self setupBackBtn];
    [self setupCountingView];
    
    [self openProximityMonitor];
}

- (void) setupBackBtn {
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(handleBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_equalTo(30);
        make.left.mas_equalTo(self.view).mas_equalTo(15);
    }];
}

- (void) handleBackBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setupCountingView {
    
    CGFloat edgeWidth = SCREEN_WIDTH - 100;
    countingView = [[TYCountingView alloc]initWithFrame:CGRectMake(0, 0, edgeWidth, edgeWidth) times:mTimes countdown:mCountdown];
    countingView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
    countingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:countingView];
}

#pragma mark - 距离传感器

- (void) openProximityMonitor {
    
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)proximityStateDidChange:(NSNotification *)note
{
    if ([UIDevice currentDevice].proximityState) {
        
        NSLog(@"有物品靠近");

        
    } else {
        
        NSLog(@"有物品离开");
    
        CGFloat percent = 1-currentTimes*1.0/mTimes;
        [countingView updateUpperLayerStrokeEnd:percent];
        [countingView updateCountLabel:--currentTimes];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
