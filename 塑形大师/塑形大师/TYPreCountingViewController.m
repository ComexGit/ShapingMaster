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
    UIButton *backBtn;
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
    [countingSetupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo((SCREEN_WIDTH-60)*0.6);
    }];
    
    readyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [readyBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [self.view addSubview:readyBtn];
    [readyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(countingSetupView.mas_bottom).mas_offset(70);
    }];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    //    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(handleBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_equalTo(30);
        make.left.mas_equalTo(self.view).mas_equalTo(15);
    }];
}

- (void) handleBackBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
