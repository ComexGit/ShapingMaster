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

    normalModeView = [TYCountingNormalModeView new];
    normalModeView.backgroundColor = [UIColor redColor];
    [self addSubview:normalModeView];
    [normalModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    timeLimitedModeView = [TYCountingTimeLimitedModeView new];
    timeLimitedModeView.backgroundColor = [UIColor greenColor];
    [self addSubview:timeLimitedModeView];
    [timeLimitedModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    infiniteModeView = [TYCountingInfiniteModeView new];
    infiniteModeView.backgroundColor = [UIColor yellowColor];
    [self addSubview:infiniteModeView];
    [infiniteModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    subViewList = [NSMutableArray arrayWithArray:@[infiniteModeView,timeLimitedModeView,normalModeView]];
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

@implementation TYCountingNormalModeView {
    
    UILabel *titleLabel;
    UILabel *tipLabel;
    UIButton *addBtn;
    UIButton *reduceBtn;
    UIButton *countBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    titleLabel = [UILabel new];
    titleLabel.text = @"次数模式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(15);
        make.centerX.mas_equalTo(self);
    }];
    
    countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countBtn.titleLabel.font = [UIFont systemFontOfSize:55.0];
    [countBtn setTitle:@"21" forState:UIControlStateNormal];
    [self addSubview:countBtn];
    [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self);
    }];
    
    tipLabel = [UILabel new];
    tipLabel.text = @"次数";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(countBtn.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self);
    }];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:32.0];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(countBtn.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(countBtn);
    }];
    
    reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
    reduceBtn.titleLabel.font = [UIFont systemFontOfSize:32.0];
    [self addSubview:reduceBtn];
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(titleLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(countBtn);
    }];
}

@end

@implementation TYCountingTimeLimitedModeView {
    
    UILabel *titleLabel;
    UIPickerView *pickerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    titleLabel = [UILabel new];
    titleLabel.text = @"限时模式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(15);
        make.centerX.mas_equalTo(self);
    }];
    
    pickerView = [UIPickerView new];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
        make.right.bottom.mas_equalTo(self).mas_offset(-15);
        make.left.mas_equalTo(self).mas_offset(15);
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 60;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//
//
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//
//
//}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld min", row];
    }
    return [NSString stringWithFormat:@"%ld sec", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
}

@end

@implementation TYCountingInfiniteModeView {
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    
}

@end

@implementation TYCountingGroupModeView {
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    
}

@end
