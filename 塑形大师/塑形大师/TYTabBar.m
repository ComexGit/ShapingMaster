//
//  TYTabBar.m
//  塑形大师
//
//  Created by yuqian on 2017/9/4.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYTabBar.h"
#import "UIResponder+Event.h"

#define SLIDER_HIGHLIGHT_COLOR [UIColor colorWithRed:48/255.0 green:56/255.0 blue:58/255.0 alpha:1.0]
#define SLIDER_NORMAL_COLOR [UIColor colorWithRed:104/255.0 green:118/255.0 blue:126/255.0 alpha:1.0]

@interface TYTabBar () {

    CAShapeLayer *swooshLayer;
    
    CGFloat layerWidth;
    CGFloat layerHeight;
    CGFloat layerCapPad;
    CGFloat btnPadLeft;
    CGFloat btnPadRight;
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
    btnPadLeft = self.btn2.center.x - self.btn1.center.x;
    btnPadRight = self.btn3.center.x - self.btn2.center.x;
    
    swooshLayer = [CAShapeLayer layer];
    swooshLayer.fillColor = [UIColor colorWithRed:186/255.0 green:206/255.0 blue:0 alpha:1.0].CGColor;
    [self.layer insertSublayer:swooshLayer below:self.btn2.layer];
    
    self.selectedPos = LayerPositionCenter;
    [self drawSwooshLayerWithPosition:_selectedPos];
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
    
    switch (position) {
        case LayerPositionLeft:
            
            swooshLayer.position = CGPointMake(-btnPadLeft, 0);
            
            [self highlightBtn1Color];
            
            break;
            
        case LayerPositionCenter:
            
            swooshLayer.position = CGPointMake(0, 0);
            
            [self highlightBtn2Color];
            
            break;
            
        case LayerPositionRight:
            
            swooshLayer.position = CGPointMake(btnPadRight, 0);
            
            [self highlightBtn3Color];
            break;
            
        default:
            break;
    }
}

- (void) highlightBtn1Color {

    [self.btn1 setTitleColor:SLIDER_HIGHLIGHT_COLOR forState:UIControlStateNormal];
    [self.btn2 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
    [self.btn3 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
}

- (void) highlightBtn2Color {
    
    [self.btn2 setTitleColor:SLIDER_HIGHLIGHT_COLOR forState:UIControlStateNormal];
    [self.btn1 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
    [self.btn3 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
}

- (void) highlightBtn3Color {
    
    [self.btn3 setTitleColor:SLIDER_HIGHLIGHT_COLOR forState:UIControlStateNormal];
    [self.btn1 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
    [self.btn2 setTitleColor:SLIDER_NORMAL_COLOR forState:UIControlStateNormal];
}

-(IBAction)btn1Click:(id)sender {

    if (self.selectedPos == LayerPositionLeft) {
        return;
    }
    
    [self swooshLayerTransition:LayerPositionLeft];
    [self.nextResponder passEventWithName:@"btn1" userInfo:nil];
    
    self.selectedPos = LayerPositionLeft;
}

-(IBAction)btn2Click:(id)sender {

    if (self.selectedPos == LayerPositionCenter) {
        return;
    }
    
    [self swooshLayerTransition:LayerPositionCenter];
    [self.nextResponder passEventWithName:@"btn2" userInfo:nil];
    
    self.selectedPos = LayerPositionCenter;
}

-(IBAction)btn3Click:(id)sender {

    if (self.selectedPos == LayerPositionRight) {
        return;
    }
    
    [self swooshLayerTransition:LayerPositionRight];
    [self.nextResponder passEventWithName:@"btn3" userInfo:nil];
    
    self.selectedPos = LayerPositionRight;
}

@end
