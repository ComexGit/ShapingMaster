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
@property(nonatomic) CADisplayLink *waveDisplayLink;

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
        [self initTimer];
    }
    return self;
}

-(void)configWaveProperties
{
//    [UIColor colorWithRed:186/255.0 green:206/255.0 blue:0 alpha:1.0];
//    [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
//    [UIColor colorWithRed:32/255.0 green:35/255.0 blue:36/255.0 alpha:1.0];
//    [UIColor colorWithRed:57/255.0 green:61/255.0 blue:63/255.0 alpha:1.0];
    _frontColor    = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    _insideColor   = [UIColor colorWithRed:32/255.0 green:35/255.0 blue:36/255.0 alpha:1.0];
    _frontSpeed    = 0.02;
    _insideSpeed   = 0.02 * 1.2;
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

- (void) initTimer {

    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshCurrentWave:)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
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

-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offsetF += waveSpeedF * direction; //direction为枚举值，正向为-1，逆向为1，通过改变符号改变曲线的移动方向
    offsetS += waveSpeedS * direction;
    
    [self drawWaveWithLayer:_frontWaveLayer offset:offsetF];
    [self drawWaveWithLayer:_insideWaveLayer offset:offsetS];
}

@end
