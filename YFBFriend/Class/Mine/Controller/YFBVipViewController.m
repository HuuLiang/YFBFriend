//
//  YFBVipViewController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVipViewController.h"
#import "YFBMyYMoneyController.h"
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
    _sliderView = [[YFBSliderView alloc] initWithIsGiftVC:NO];
    _sliderView.titlesArr = @[@"购买Y币",@"开通VIP"];
    [self.view addSubview:_sliderView];
    YFBMyYMoneyController *moneyVC = [[YFBMyYMoneyController alloc] init];
    YFBDredgeVipController *dredgeVC = [[YFBDredgeVipController alloc] init];
    [_sliderView addChildViewController:moneyVC title:_sliderView.titlesArr.firstObject];
    [_sliderView addChildViewController:dredgeVC title:_sliderView.titlesArr.lastObject];
    [_sliderView setSlideHeadView];
    [_sliderView currentVCWithIndex:_isDredgeVipVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
