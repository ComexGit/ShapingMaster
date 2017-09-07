//
//  TYTabBar.m
//  塑形大师
//
//  Created by yuqian on 2017/9/4.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYTabBar.h"

typedef enum {

    LayerPositionLeft,
    LayerPositionCenter,
    LayerPositionRight

} LayerPosition;

@interface TYTabBar () {

    CAShapeLayer *swooshLayer;
    
    CGFloat layerWidth;
    CGFloat layerHeight;
    CGFloat layerCapPad;
    CGFloat btnPad;
    
    LayerPosition layerPosition;
}

@property (nonatomic, weak) IBOutlet UIButton *btn1;
@property (nonatomic, weak) IBOutlet UIButton *btn2;
@property (nonatomic, weak) IBOutlet UIButton *btn3;


@end

@implementation TYTabBar

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self setUpLayer];
}

- (void) setUpLayer {

    layerWidth = 40;
    layerHeight = 38;
    layerCapPad = 15;
    btnPad = self.btn2.center.x - self.btn1.center.x;
    
    swooshLayer = [CAShapeLayer layer];
    swooshLayer.fillColor = [UIColor colorWithRed:186/255.0 green:206/255.0 blue:0 alpha:1.0].CGColor;
    [self.layer insertSublayer:swooshLayer below:self.btn2.layer];
    
    layerPosition = LayerPositionCenter;
    [self drawSwooshLayerWithPosition:layerPosition];
}

- (void) drawSwooshLayerWithPosition:(LayerPosition)position {

    CGPoint center;
    
    switch (position) {
        case LayerPositionLeft:
            center = self.btn1.center;
            break;
            
        case LayerPositionCenter:
            center = self.btn2.center;
            break;
            
        case LayerPositionRight:
            center = self.btn3.center;
            break;
            
        default:
            center = self.btn2.center;
            break;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - layerWidth/2 - layerCapPad, center.y - layerHeight/2, layerWidth+layerCapPad*2, layerHeight) cornerRadius:layerHeight/2];
    
    swooshLayer.path = path.CGPath;
    NSLog(@"%f,%f", swooshLayer.position.x, swooshLayer.position.y);
}

- (void) swooshLayerTransition:(LayerPosition)position {

    if (layerPosition == position) {
        return;
    }
    
    switch (position) {
        case LayerPositionLeft:
            swooshLayer.position = CGPointMake(-btnPad, 0);
            [self.btn1 setTitleColor:[UIColor colorWithRed:48/255.0 green:56/255.0 blue:58/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn2 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn3 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            break;
            
        case LayerPositionCenter:
            swooshLayer.position = CGPointMake(0, 0);
            [self.btn2 setTitleColor:[UIColor colorWithRed:48/255.0 green:56/255.0 blue:58/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn1 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn3 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            break;
            
        case LayerPositionRight:
            swooshLayer.position = CGPointMake(btnPad, 0);
            [self.btn3 setTitleColor:[UIColor colorWithRed:48/255.0 green:56/255.0 blue:58/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn1 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.btn2 setTitleColor:[UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(IBAction)btn1Click:(id)sender {

    [self swooshLayerTransition:LayerPositionLeft];
    layerPosition = LayerPositionLeft;
}

-(IBAction)btn2Click:(id)sender {

    [self swooshLayerTransition:LayerPositionCenter];
    layerPosition = LayerPositionCenter;
}

-(IBAction)btn3Click:(id)sender {

    [self swooshLayerTransition:LayerPositionRight];
    layerPosition = LayerPositionRight;
}

@end
