//
//  TYCountingView.m
//  塑形大师
//
//  Created by yuqian on 2017/10/24.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYCountingView.h"
#import <POP.h>

@interface TYCountingView () <POPAnimationDelegate>

@end

@implementation TYCountingView {
    
    CAShapeLayer *bottomLayer;
    CAShapeLayer *upperLayer;
    
    UILabel *timeLabel;
    UILabel *countLabel;
}

- (instancetype)initWithFrame:(CGRect)frame times:(int)times countdown:(int)countdown
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initUIWithTimes:times countdown:countdown];
        [self countdownAnimation:countdown];
    }
    return self;
}

- (void) initUIWithTimes:(int)times countdown:(int)countdown {
    
    bottomLayer = [CAShapeLayer layer];
    bottomLayer.frame = self.bounds;
    [self.layer addSublayer:bottomLayer];
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    bottomLayer.path = bottomPath.CGPath;
    
    bottomLayer.fillColor = [UIColor clearColor].CGColor;
    bottomLayer.lineWidth = 5.0f;
    bottomLayer.strokeColor = [UIColor redColor].CGColor;
    
    
    upperLayer = [CAShapeLayer layer];
    upperLayer.frame = self.bounds;
    [self.layer insertSublayer:upperLayer above:bottomLayer];
    
    UIBezierPath *upperPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    upperLayer.path = upperPath.CGPath;
    
    upperLayer.fillColor = [UIColor clearColor].CGColor;
    upperLayer.lineWidth = 15.0f;
    upperLayer.strokeColor = [UIColor whiteColor].CGColor;
    upperLayer.strokeStart = 0;
    upperLayer.strokeEnd = 0;
    
    countLabel = [UILabel new];
    countLabel.text = [NSString stringWithFormat:@"%d", times];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont boldSystemFontOfSize:70.0];
    
    [self addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-50);
    }];
    
    timeLabel = [UILabel new];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)countdown/60, (int)countdown%60];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont boldSystemFontOfSize:45.0];
    
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(countLabel.mas_bottom).mas_offset(10);
    }];
}

- (void) updateUpperLayerStrokeEnd:(CGFloat)strokeEnd {
    
    upperLayer.strokeEnd = strokeEnd;
    [self setNeedsDisplay];
}

- (void) scaleAnimation {
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    animation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.85f, 0.85f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3;
    animation.delegate = self;
    [self.layer pop_addAnimation:animation forKey:@"scaleAnimation"];
}

- (void) scaleIdentifyAnimation {
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    animation.toValue  = [NSValue valueWithCGSize:CGSizeMake(0.85f, 0.85f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.8;
    animation.delegate = self;
    [self.layer pop_addAnimation:animation forKey:@"scaleIdentifyAnimation"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    if ([anim.name isEqualToString:@"scaleAnimation"]) {
        
        [self scaleIdentifyAnimation];
    }
}

- (void) updateCountLabel:(int)times {
    
    countLabel.text = [NSString stringWithFormat:@"%d", times];
}

- (void) countdownAnimation:(int)countdown {
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            //[NSString stringWithFormat:@"%02d:%02d:%02d",(int)values[0]/60,(int)values[0]%60,(int)(values[0]*100)%100]
            timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)values[0]/60,(int)values[0]%60];
        };
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = prop;
    anBasic.fromValue = @(countdown);
    anBasic.toValue = @(0);
    anBasic.duration = countdown;
    anBasic.beginTime = CACurrentMediaTime() + 1.0f;    //延迟1秒开始
    [timeLabel pop_addAnimation:anBasic forKey:@"countdown"];
}

@end
