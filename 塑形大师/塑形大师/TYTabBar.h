//
//  TYTabBar.h
//  塑形大师
//
//  Created by yuqian on 2017/9/4.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    LayerPositionLeft,
    LayerPositionCenter,
    LayerPositionRight
    
} LayerPosition;

@interface TYTabBar : UIView

@property (nonatomic, assign) LayerPosition selectedPos;

@end
