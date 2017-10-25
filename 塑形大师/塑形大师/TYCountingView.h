//
//  TYCountingView.h
//  塑形大师
//
//  Created by yuqian on 2017/10/24.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCountingView : UIView

- (instancetype)initWithFrame:(CGRect)frame times:(int)times countdown:(int)countdown;
- (void) updateCountLabel:(int)times;
- (void) updateUpperLayerStrokeEnd:(CGFloat)strokeEnd;

@end
