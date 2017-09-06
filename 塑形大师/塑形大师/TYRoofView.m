//
//  TYRoofView.m
//  塑形大师
//
//  Created by yuqian on 2017/9/6.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYRoofView.h"

@implementation TYRoofView {

    CGPoint startPoint;
    CGPoint endPoint;
    CGPoint peakPoint;
    CGPoint controlPoint1;
    CGPoint controlPoint2;
    CGFloat arcRadius;
    
    UIColor *bgColor;
    
    CAShapeLayer *shapeLayer;
    
    CGFloat width;
    CGFloat heigth;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        
        [self configProperties];
        [self drawRoofLine];
    }
    return self;
}

- (void) configProperties {

    width = self.frame.size.width;
    heigth = self.frame.size.height;
    
    arcRadius = 50;
    
    startPoint = CGPointMake(0, heigth);
    endPoint = CGPointMake(width, heigth);
    peakPoint = CGPointMake(width/2, 0);
    controlPoint1 = CGPointMake(width/4, heigth);
    controlPoint2 = CGPointMake(width*3/4, heigth);
    
    bgColor = [UIColor colorWithRed:32/255.0 green:35/255.0 blue:36/255.0 alpha:1.0];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = bgColor.CGColor;
    [self.layer addSublayer:shapeLayer];
}

- (void) drawRoofLine {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:peakPoint controlPoint:controlPoint1];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint2];

    [path closePath];
    
    shapeLayer.path = path.CGPath;
}

@end
