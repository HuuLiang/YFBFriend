//
//  YFBMyGiftController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyGiftController.h"
#import "YFBSliderView.h"
#import "YFBMyGiftDetailController.h"

@interface YFBMyGiftController ()
{
    YFBSliderView *_sliderView;
}
@end

@implementation YFBMyGiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的礼物";
    self.view.backgroundColor = [UIColor whiteColor];
    _sliderView = [[YFBSliderView alloc] initWithIsGiftVC:YES];
    _sliderView.titlesArr = @[@"收到的礼物",@"送出的礼物"];
    [self.view addSubview:_sliderView];
    YFBMyGiftDetailController *sendGiftVC = [[YFBMyGiftDetailController alloc] initWithIsSendGift:YES];
    YFBMyGiftDetailController *fetchGiftVC = [[YFBMyGiftDetailController alloc] initWithIsSendGift:NO];
    [_sliderView addChildViewController:fetchGiftVC title:_sliderView.titlesArr.firstObject];
    [_sliderView addChildViewController:sendGiftVC title:_sliderView.titlesArr.lastObject];
    [_sliderView setSlideHeadView];
    _sliderView.sendGift = @"4";
    _sliderView.receivedGift = @"12";
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
