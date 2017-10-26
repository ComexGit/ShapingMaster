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

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TYCountingViewController () <CLLocationManagerDelegate>{
    
    UIButton *backBtn;
    UIButton *helpBtn;
    TYCountingView *countingView;
    
    int mTimes;
    int mCountdown;
    int currentTimes;
    
    CMMotionManager  *motionManager;
    BOOL upStatus;
    BOOL downStatus;
    
    CLLocationManager *locationManager;
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
    
    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    
    [self setupBackBtn];
    [self setupCountingView];
    
//    [self openProximityMonitor];
//    [self startDeviceMotion];
    [self startLocation];
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
            
            
            if (motion.userAcceleration.y < -0.25) {
                upStatus = YES;
            }
            
            if (motion.userAcceleration.y > 0.25) {
                downStatus = upStatus ? YES : NO;
            }
            
            NSLog(@"upStatus:%d  downStatus:%d  motion.userAcceleration.y: %f", upStatus, downStatus, motion.userAcceleration.y);
            
            if (upStatus && downStatus) {
                
                upStatus = NO;
                downStatus = NO;
                
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

- (void)startLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    float altitude = newLocation.altitude;
    NSLog(@"海拔高度为：%.4fm", altitude);
    NSLog(@"垂直精度为：%.4fm", newLocation.verticalAccuracy);
}

@end
