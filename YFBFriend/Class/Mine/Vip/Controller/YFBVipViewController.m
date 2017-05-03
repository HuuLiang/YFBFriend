//
//  YFBVipViewController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVipViewController.h"
#import "YFBBuyDiamondViewController.h"
#import "YFBDredgeVipController.h"
#import "YFBSliderView.h"

@interface YFBVipViewController ()
{
    YFBSliderView *_sliderView;
    BOOL _isDredgeVipVC;
}
@end

@implementation YFBVipViewController

- (instancetype)initWithIsDredgeVipVC:(BOOL)isDredgeVipVC
{
    self = [super init];
    if (self) {
        _isDredgeVipVC = isDredgeVipVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"充值";
    _sliderView = [[YFBSliderView alloc] init];
    _sliderView.titlesArr = @[@"购买钻石",@"开通VIP"];
    [self.view addSubview:_sliderView];
    YFBBuyDiamondViewController *buyDiamondVC = [[YFBBuyDiamondViewController alloc] init];
    YFBDredgeVipController *dredgeVC = [[YFBDredgeVipController alloc] init];
    [_sliderView addChildViewController:buyDiamondVC title:_sliderView.titlesArr.firstObject];
    [_sliderView addChildViewController:dredgeVC title:_sliderView.titlesArr.lastObject];
    [_sliderView setSlideHeadView];
    [_sliderView currentVCWithIndex:_isDredgeVipVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
