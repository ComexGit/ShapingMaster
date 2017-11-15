//
//  TYPreCountingViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/11/15.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYPreCountingViewController.h"
#import "TYCountingSetupView.h"
#import "TYPreCountingViewController.h"


@interface TYPreCountingViewController () {
    
    TYCountingSetupView *countingSetupView;
    UIButton *readyBtn;
}

@end

@implementation TYPreCountingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI {
    
    self.view.backgroundColor = MAIN_BG_COLOR;
    
    countingSetupView = [TYCountingSetupView new];
    [self.view addSubview:countingSetupView];
    
    readyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:readyBtn];
    [readyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(countingSetupView.mas_bottom).mas_offset(70);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
