//
//  TYWaveTabView.h
//  塑形大师
//
//  Created by yuqian on 2017/9/5.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    WaveDirectionForward = -1,
    WaveDirectionTypeBack = 1
    
} WaveDirectionType;

@interface TYWaveView : UIView

@property (nonatomic) UIColor *frontColor;          //外层波形颜色，默认黑色
@property (nonatomic) UIColor *insideColor;         //内层波形颜色，默认灰色
@property (nonatomic, assign) CGFloat frontSpeed;           //外层波形移动速度，默认0.01;
@property (nonatomic, assign) CGFloat insideSpeed;          //内层波形移动速度，默认0.01 * 1.2;
@property (nonatomic, assign) CGFloat waveOffset;           //两层波形初相差值，默认M_PI;
@property (nonatomic, assign) WaveDirectionType directionType;  //移动方向，默认从右到左;

@end
