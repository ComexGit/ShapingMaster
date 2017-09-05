//
//  TYWaveTabView.m
//  塑形大师
//
//  Created by yuqian on 2017/9/5.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYWaveView.h"


@interface TYWaveView ()

@property(nonatomic) CAShapeLayer *frontWaveLayer;
@property(nonatomic) CAShapeLayer *insideWaveLayer;

@end

@implementation TYWaveView {
    
    /*
     y = Asin(ωx+φ)+k
     A表示振幅，使用这个变量来调整波浪的高度
     ω表示频率，使用这个变量来调整波浪密集度
     φ表示初相，使用这个变量来调整波浪初始位置
     k表示高度，使用这个变量来调整波浪在屏幕中y轴的位置。
     */
    
    CGFloat waveWidth;
    CGFloat waveHeight;
    
    CGFloat waveA;      // A
    CGFloat waveW;      // ω
    CGFloat offsetF;    // φ firstLayer
    CGFloat offsetS;    // φ secondLayer
    CGFloat currentK;   // k
    CGFloat waveSpeedF; // 外层波形移动速度
    CGFloat waveSpeedS; // 内层波形移动速度
    
    WaveDirectionType direction; //移动方向
}

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        
        [self configWaveProperties];
        [self initWaves];
        
        [self drawWaveWithLayer:_frontWaveLayer offset:offsetF];
        [self drawWaveWithLayer:_insideWaveLayer offset:offsetS];
    }
    return self;
}

-(void)configWaveProperties
{
    _frontColor    = [UIColor blackColor];
    _insideColor   = [UIColor grayColor];
    _frontSpeed    = 0.01;
    _insideSpeed   = 0.01 * 1.2;
    _waveOffset    = M_PI;
    _directionType = WaveDirectionForward;
}

-(void)initWaves
{
    waveWidth   = self.frame.size.width;
    waveHeight  = self.frame.size.height;
    
    waveA       = waveHeight / 2;
    waveW       = (M_PI * 2 / waveWidth) / 1.5;
    offsetF     = 0;
    offsetS     = offsetF + _waveOffset;
    currentK    = waveHeight / 2;
    waveSpeedF  = _frontSpeed;
    waveSpeedS  = _insideSpeed;
    direction   = _directionType;
    
    _frontWaveLayer = [CAShapeLayer layer];
    _frontWaveLayer.fillColor = _frontColor.CGColor; //设置填充颜色
    [self.layer addSublayer:_frontWaveLayer];
    
    _insideWaveLayer = [CAShapeLayer layer];
    _insideWaveLayer.fillColor = _insideColor.CGColor;
    [self.layer insertSublayer:_insideWaveLayer below:_frontWaveLayer]; //将第二个放在第一个下面
}

- (void) drawWaveWithLayer:(CAShapeLayer*)layer offset:(CGFloat)offset {

    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = currentK;
    CGPathMoveToPoint(path, nil, 0, y); //将点移动到坐标（0,k）
    
    //以1个像素为单位，[0,视图宽度]为定义域，遍历函数中所有的点，将点连成线
    for (NSInteger i = 0; i <= waveWidth; i++) {
        
        y = waveA * sin(waveW * i + offset) + currentK;
        
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    CGPathAddLineToPoint(path, nil, waveWidth, waveHeight); //将函数末尾与视图右下角相连
    CGPathAddLineToPoint(path, nil, 0, waveHeight); //连线到视图左下角
    
    CGPathCloseSubpath(path); //将当前点与起点相连并关闭path
    
    layer.path = path; //设置path
    
    CGPathRelease(path);

}


@end
