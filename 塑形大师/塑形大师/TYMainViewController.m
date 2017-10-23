//
//  TYMainViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/9/4.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYMainViewController.h"
#import "TYItemCollectionViewCell.h"
#import "TYTabBar.h"
#import "TYWaveView.h"
#import "TYNavigationBar.h"
#import "UIResponder+Event.h"
#import <pop/POP.h>
#import "TYStatView.h"
#import "TYPlanView.h"

#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

#define CELL_COUNT 4
#define LINE_SPACE 15
#define ITEM_SPACE 15

#define DURATION 1.0

static NSString *reusedStr = @"itemReusedCell";

@interface TYMainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, POPAnimationDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, weak) IBOutlet TYTabBar         *mTabBar;
@property (nonatomic, weak) IBOutlet TYNavigationBar  *mNavBar;
@property (nonatomic)                TYWaveView       *mWaveViewNav;
@property (nonatomic)                TYStatView       *mStatView;
@property (nonatomic)                TYPlanView       *mPlanView;
@property (nonatomic, assign)        LayerPosition    lastDirection;

@end

@implementation TYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpPlanView];
    [self setUpStatView];
    [self setUpWaveView];
}

- (void)setUpPlanView {

    self.mPlanView = [[TYPlanView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, CGRectGetMaxY(_mNavBar.frame), SCREEN_WIDTH, _mCollectionView.frame.size.height)];
//    _mPlanView.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    _mPlanView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_mPlanView];
}

-(void)setUpWaveView
{
    self.mWaveViewNav = [[TYWaveView alloc] initWithFrame:CGRectMake(0, _mNavBar.frame.size.height-10, SCREEN_WIDTH, 10)];
    [_mNavBar addSubview:_mWaveViewNav];
}

- (void) setUpStatView {

    self.mStatView = [[TYStatView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, CGRectGetMaxY(_mNavBar.frame), SCREEN_WIDTH, _mCollectionView.frame.size.height)];
//    _mStatView.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    _mStatView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_mStatView];
    [self.view bringSubviewToFront:_mTabBar];
}

- (void)passEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    if ([eventName isEqualToString:@"btn1"]) {
        
        [self transitionToPlanView];
    }
    
    if ([eventName isEqualToString:@"btn2"]) {
        
        [self transitionIdentify];
    }
    
    if ([eventName isEqualToString:@"btn3"]) {
        
        [self transitionToStatView];
    }
}

#pragma mark - View Transtion

- (void) transitionToStatView {

    [_mStatView setHidden:NO];
    _lastDirection = LayerPositionRight;
    [self collectionViewAnimation:DURATION translationArray:@[@-300, @-200, @-600, @-600] angles:@[@(-15* M_PI/180), @(-30* M_PI/180), @(-15* M_PI/180), @(-60* M_PI/180)] scaleArray:@[@0, @0, @0, @-5] direction:LayerPositionRight];
}

- (void) transitionToPlanView {

    [_mPlanView setHidden:NO];
    _lastDirection = LayerPositionLeft;
    [self collectionViewAnimation:DURATION translationArray:@[@300, @200, @600, @600] angles:@[@(15* M_PI/180), @(30* M_PI/180), @(15* M_PI/180), @(60* M_PI/180)] scaleArray:@[@0, @0, @0, @5] direction:LayerPositionLeft];
}

- (void) transitionIdentify {

    [_mCollectionView setHidden:NO];
    
    if (_mTabBar.selectedPos == LayerPositionRight) {
        
        [self collectionViewBackAnimation:DURATION translationArray:@[@-5, @0, @-300, @-100] angles:@[@(-2* M_PI/180), @(-5* M_PI/180), @(-30* M_PI/180), @(-10* M_PI/180)] direction:LayerPositionRight];
        
    }else {
        
        [self collectionViewBackAnimation:DURATION translationArray:@[@5, @0, @300, @100] angles:@[@(2* M_PI/180), @(5* M_PI/180), @(30* M_PI/180), @(10* M_PI/180)] direction:LayerPositionLeft];
    }
}

- (void) collectionViewAnimation:(NSTimeInterval)duration
                translationArray:(NSArray *)translationArray
                          angles:(NSArray*)angles
                      scaleArray:(NSArray*)scaleArray
                       direction:(LayerPosition)direction {
    
    int i = 0;
    for (UICollectionViewCell *cell in _mCollectionView.visibleCells) {
        
        //未选中的可视cell的缩放
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        rotationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
        rotationAnimation.duration = duration;
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = angles[i];
        
        POPBasicAnimation *translationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        translationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
        translationAnimation.duration = duration;
        translationAnimation.fromValue = @(0);
        translationAnimation.toValue = translationArray[i];
        
        POPBasicAnimation *zPositionAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        zPositionAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerZPosition];
        zPositionAnimation.duration = duration;
        zPositionAnimation.toValue = scaleArray[i];
        
        [cell.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [cell.layer pop_addAnimation:translationAnimation forKey:@"translationAnimation"];
        [cell.layer pop_addAnimation:zPositionAnimation forKey:@"zPositionAnimation"];
        i++;
    }
    
    // collectionView 移动
    CGRect fromFrame = _mCollectionView.frame;
    CGRect toFrome = fromFrame;
    
    if (direction == LayerPositionRight) {
        fromFrame.origin.x -= fromFrame.size.width;
    }
    else if (direction == LayerPositionLeft){
        fromFrame.origin.x += fromFrame.size.width;
    }
    else {
        toFrome.origin.x = 0;
    }
    
    _mCollectionView.frame = fromFrame;
    
    POPBasicAnimation *frameAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation.name = @"showEdgeAnimation";
    frameAnimation.duration = duration;
    frameAnimation.fromValue = [NSValue valueWithCGRect:toFrome];
    frameAnimation.toValue = [NSValue valueWithCGRect:fromFrame];
    frameAnimation.delegate = self;
    
    [_mCollectionView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
    
    [frameAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        if (finished) {
            [_mCollectionView setHidden:YES];
        }
        
    }];
}

- (void) collectionViewBackAnimation:(NSTimeInterval)duration
                    translationArray:(NSArray *)translationArray
                              angles:(NSArray*)angles
                           direction:(LayerPosition)direction {

    int i = 0;
    for (UICollectionViewCell *cell in _mCollectionView.visibleCells) {

        //未选中的可视cell的缩放
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        rotationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
        rotationAnimation.duration = duration;
        rotationAnimation.fromValue = angles[i];
        rotationAnimation.toValue = @(0);
        
        POPBasicAnimation *translationAnimation = [POPBasicAnimation easeInEaseOutAnimation];
        translationAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
        translationAnimation.duration = duration;
        translationAnimation.fromValue = translationArray[i];
        translationAnimation.toValue = @(0);
        
        [cell.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [cell.layer pop_addAnimation:translationAnimation forKey:@"translationAnimation"];
        i++;
    }
    
    // collectionView 移动
    CGRect fromFrame = _mCollectionView.frame;
    CGRect toFrome = fromFrame;
    toFrome.origin.x = 0;
    
    POPBasicAnimation *frameAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation.name = @"showHomeView";
    frameAnimation.duration = duration;
    frameAnimation.fromValue = [NSValue valueWithCGRect:fromFrame];
    frameAnimation.toValue = [NSValue valueWithCGRect:toFrome];
    frameAnimation.delegate = self;
    [_mCollectionView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
    
    [frameAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        if (finished) {
            
            if (direction == LayerPositionRight) {
                
                [_mStatView setHidden:YES];
            }
            if (direction == LayerPositionLeft) {
                
                [_mPlanView setHidden:YES];
            }
        }
    }];
}

#pragma mark - pop delegete

- (void)pop_animationDidApply:(POPAnimation *)anim
{
    //    NSLog(@"%@",anim.name );
    CGRect currentValue = [[anim valueForKey:@"currentValue"] CGRectValue];
    
    if ([anim.name isEqualToString:@"showEdgeAnimation"]) {
        
        [self edgeViewAnimation:_mTabBar.selectedPos currentRect:currentValue];
    }
    else if([anim.name isEqualToString:@"showHomeView"]){
        
        [self edgeViewBackAnimation:_lastDirection currentRect:currentValue];
    }
}

- (void) edgeViewAnimation:(LayerPosition)direction currentRect:(CGRect)currentValue {

    if (direction == LayerPositionLeft) {
        
        CGRect frame = _mPlanView.frame;
        CGFloat distanceY = 30 *(1 -fabs(currentValue.origin.x /_mPlanView.frame.size.width));
        
        frame.origin.x = -_mPlanView.frame.size.width  + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_mNavBar.frame) + distanceY;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _mPlanView.frame = frame;
        
        [UIView commitAnimations];
    }
    if (direction == LayerPositionRight) {
        
        CGRect frame = _mStatView.frame;
        CGFloat distanceY = 30 *(1 -fabs(currentValue.origin.x /_mStatView.frame.size.width));
        
        frame.origin.x = _mStatView.frame.size.width + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_mNavBar.frame) + distanceY;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _mStatView.frame = frame;
        
        [UIView commitAnimations];
    }
}

- (void) edgeViewBackAnimation:(LayerPosition)direction currentRect:(CGRect)currentValue {
    
    if (direction == LayerPositionLeft) {
        
        CGRect frame = _mPlanView.frame;
        CGFloat distanceY = 30 * (1 -  fabs(currentValue.origin.x /_mPlanView.frame.size.width));
        
        frame.origin.x = -_mPlanView.frame.size.width  + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_mNavBar.frame) + distanceY;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _mPlanView.frame = frame;
        
        [UIView commitAnimations];
    }
    if (direction == LayerPositionRight) {
        
        CGRect frame = _mStatView.frame;
        CGFloat distanceY = 30 * (1 -  fabs(currentValue.origin.x /_mStatView.frame.size.width));
        
        frame.origin.x = _mStatView.frame.size.width  + currentValue.origin.x;
        frame.origin.y =  CGRectGetMaxY(_mNavBar.frame) + distanceY;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.0];
        _mStatView.frame = frame;
        
        [UIView commitAnimations];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TYItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedStr forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *selectedCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self scaleAnimationWithCollectionView:collectionView selectedCell:selectedCell];
    
    
}

- (void) scaleAnimationWithCollectionView:(UICollectionView *)collectionView selectedCell:(UICollectionViewCell *)selectedCell {
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        
        if ([cell isEqual:selectedCell]) {
            
            //选中的cell的放大
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.05, 1.05)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @1.0;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
            [alphaAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                
                if (finished) {

                }
            }];
        }
        else{
            
            //未选中的可视cell的缩放
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @0.7;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - ITEM_SPACE * 3) / 2;
    CGFloat height = width * 1.3;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(LINE_SPACE+5, ITEM_SPACE, LINE_SPACE, ITEM_SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return LINE_SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ITEM_SPACE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
