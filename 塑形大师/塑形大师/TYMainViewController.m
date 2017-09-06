//
//  TYMainViewController.m
//  塑形大师
//
//  Created by yuqian on 2017/9/4.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "TYMainViewController.h"
#import "TYItemCollectionViewCell.h"
#import "TYTabBar.h"
#import "TYWaveView.h"
#import "TYNavigationBar.h"
#import "TYRoofView.h"


#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

#define CELL_COUNT 4
#define LINE_SPACE 15
#define ITEM_SPACE 15

static NSString *reusedStr = @"itemReusedCell";

@interface TYMainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, weak) IBOutlet TYTabBar         *mTabBar;
@property (nonatomic, weak) IBOutlet TYNavigationBar  *mNavBar;
@property (nonatomic)                TYWaveView       *mWaveViewNav;
@property (nonatomic)                TYRoofView       *mRoofView;

@end

@implementation TYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpWaveView];
    [self setUpRoofView];
}

-(void)setUpWaveView
{
    self.mWaveViewNav = [[TYWaveView alloc] initWithFrame:CGRectMake(0, _mNavBar.frame.size.height-10, SCREEN_WIDTH, 10)];
    [_mNavBar addSubview:_mWaveViewNav];
}

- (void)setUpRoofView {

    self.mRoofView = [[TYRoofView alloc]initWithFrame:CGRectMake(0, -15, SCREEN_WIDTH, 15)];
    [_mTabBar addSubview:_mRoofView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TYItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedStr forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - ITEM_SPACE * 3) / 2;
    CGFloat height = width * 1.3;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(LINE_SPACE+5, ITEM_SPACE, LINE_SPACE, ITEM_SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return LINE_SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ITEM_SPACE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
