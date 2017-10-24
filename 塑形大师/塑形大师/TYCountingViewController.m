//
//  TYCountingViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/10/23.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYCountingViewController.h"

@interface TYCountingViewController () {
    
    UIButton *backBtn;
    UIButton *helpBtn;
    
}



@end

@implementation TYCountingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    
}

- (void) setupBackBtn {
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view).mas_equalTo(15);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
