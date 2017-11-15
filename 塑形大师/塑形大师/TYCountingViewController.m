//
//  TYCountingViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/10/23.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYCountingViewController.h"
#import "TYCountingView.h"
#import <CoreMotion/CoreMotion.h>


@interface TYCountingViewController () {
    
    UIButton *backBtn;
    UIButton *helpBtn;
    TYCountingView *countingView;
    
    int mTimes;
    int mCountdown;
    int currentTimes;
    
    CMMotionManager  *motionManager;
    BOOL upStatusX;
    BOOL downStatusX;
    BOOL upStatusY;
    BOOL downStatusY;
    BOOL upStatusZ;
    BOOL downStatusZ;

}
@end

@implementation TYCountingViewController

- (instancetype)initWithTimes:(int)times countdown:(int)countdown
{
    self = [super init];
    if (self) {
        mTimes = times;
        mCountdown = countdown;
        currentTimes = times-1;
    }
    return self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [motionManager stopDeviceMotionUpdates];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_BG_COLOR;
    
    [self setupBackBtn];
    [self setupCountingView];
    
//    [self openProximityMonitor];
    [self startDeviceMotion];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        
        NSLog(@"something close");
        [countingView scaleAnimation];
        
    } else {
        
        NSLog(@"something away");
    
        CGFloat percent = 1-currentTimes*1.0/mTimes;
        [countingView updateUpperLayerStrokeEnd:percent];
        [countingView updateCountLabel:currentTimes--];
    }
}

#pragma mark - 加速计
- (void)startDeviceMotion {
    
    motionManager = [[CMMotionManager alloc] init];
    
    if ([motionManager isDeviceMotionAvailable]){
        
        motionManager.deviceMotionUpdateInterval = 1/90;

        [motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {

            
//            NSLog(@"motion.userAcceleration.x: %f", motion.userAcceleration.x);
//            NSLog(@"motion.userAcceleration.y: %f", motion.userAcceleration.y);
//            NSLog(@"motion.userAcceleration.z: %f", motion.userAcceleration.z);
//            if (motion.userAcceleration.x < -0.4) {
//                upStatusX = YES;
//            }
//
//            if (motion.userAcceleration.x > 0.4) {
//                downStatusX = upStatusX ? YES : NO;
//            }
            
            if (motion.userAcceleration.y + motion.userAcceleration.x + motion.userAcceleration.z < -0.4) {
                
                upStatusY = YES;
                
                
            }
            
            if (motion.userAcceleration.y + motion.userAcceleration.x + motion.userAcceleration.z > 0.4) {
                

                downStatusY = upStatusY ? YES : NO;
            }
            
//            if (motion.userAcceleration.z < -0.4) {
//                upStatusZ = YES;
//            }
//
//            if (motion.userAcceleration.z > 0.4) {
//                downStatusZ = upStatusZ ? YES : NO;
//            }
            
            NSLog(@"upStatus:%d  downStatus:%d  motion.userAcceleration.y: %f", upStatusY, downStatusY, motion.userAcceleration.y);
            
            if ((upStatusX && downStatusX) || (upStatusY && downStatusY) || (upStatusZ && downStatusZ)) {
                
                upStatusX = NO;
                downStatusX = NO;
                upStatusY = NO;
                downStatusY = NO;
                upStatusZ = NO;
                downStatusZ = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CGFloat percent = 1-currentTimes*1.0/mTimes;
                    [countingView updateUpperLayerStrokeEnd:percent];
                    [countingView updateCountLabel:currentTimes--];
                });
            }
        }];
    }
    else {
        NSLog(@"加速计不可用");
    }
}


@end
