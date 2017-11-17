//
//  TYCountingSetupView.m
//  塑形大师
//
//  Created by yuqian on 2017/11/15.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYCountingSetupView.h"

#define VIEW_COUNT  3

typedef enum {
    
    TYCountingSetupViewSwipeUp,
    TYCountingSetupViewSwipeLeft,
    TYCountingSetupViewSwipeDown,
    TYCountingSetupViewSwipeRight
    
} TYCountingSetupViewSwipeDirection;

@interface TYCountingSetupView () {
    
    TYCountingNormalModeView *normalModeView;
    TYCountingTimeLimitedModeView *timeLimitedModeView;
    TYCountingInfiniteModeView *infiniteModeView;
    TYCountingGroupModeView *groupModeView;
    
    NSMutableArray *subViewList;
    int currentIndex;
}
@end

@implementation TYCountingSetupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
        [self addGesture];
    }
    return self;
}

- (void) initUI {
/*
    view1 = [UIView new];
    view1.backgroundColor = [UIColor redColor];
    [self addSubview:view1];
    
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view1);
    }];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    view2 = [UIView new];
    view2.backgroundColor = [UIColor greenColor];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    view3 = [UIView new];
    view3.backgroundColor = [UIColor yellowColor];
    [self addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    subViewList = [NSMutableArray arrayWithArray:@[view3,view2,view1]];
 */
}

-(void) handleBtnClick {
    NSLog(@"what the fucking you");
}

- (void) addGesture {
    
    UISwipeGestureRecognizer *upSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipe:)];
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:upSwipeGesture];
    
    UISwipeGestureRecognizer *downSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipe:)];
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:downSwipeGesture];
}

-(void) upSwipe:(UISwipeGestureRecognizer *)gesture{
    
    [self transitionAnimation:TYCountingSetupViewSwipeUp];
}

-(void) downSwipe:(UISwipeGestureRecognizer *)gesture {
    
    [self transitionAnimation:TYCountingSetupViewSwipeDown];
}

-(void)transitionAnimation:(TYCountingSetupViewSwipeDirection)swipeDirection{
    
    CATransition *transition = [CATransition new];
    
    transition.type = @"cube";
    transition.duration = 0.75f;
    
    if (swipeDirection == TYCountingSetupViewSwipeUp) {
        transition.subtype = kCATransitionFromTop;
    }else{
        transition.subtype = kCATransitionFromBottom;
    }

    [self bringSubviewToFront:[self getCurrentSubView:swipeDirection]];
    [self.layer addAnimation:transition forKey:@"TYTransitionAnimation"];
}

- (BOOL) animationAvailable:(TYCountingSetupViewSwipeDirection)swipeDirection {
    
    if (swipeDirection == TYCountingSetupViewSwipeUp && currentIndex == (VIEW_COUNT-1)) {
        
        return NO;
    }
    else if (swipeDirection == TYCountingSetupViewSwipeDown && currentIndex == 0) {
        
        return NO;
    }
    return YES;
}

- (UIView*) getCurrentSubView:(TYCountingSetupViewSwipeDirection)swipeDirection{
    
    if (swipeDirection == TYCountingSetupViewSwipeUp) {
        currentIndex = (currentIndex + 1) % VIEW_COUNT;
    }else{
        currentIndex = (currentIndex - 1 + VIEW_COUNT) % VIEW_COUNT;
    }
   
    NSLog(@"currentIndex: %d", currentIndex);
    return subViewList[currentIndex];
}
@end

#pragma mark - subview

@implementation TYCountingNormalModeView


@end

@implementation TYCountingTimeLimitedModeView


@end

@implementation TYCountingInfiniteModeView


@end

@implementation TYCountingGroupModeView


@end
