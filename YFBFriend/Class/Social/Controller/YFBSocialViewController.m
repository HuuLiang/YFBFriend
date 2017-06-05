//
//  YFBSocialViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/6/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSocialViewController.h"
#import "YFBSliderView.h"

@interface YFBSocialViewController ()
@property (nonatomic) YFBSliderView *sliderView;
@end

@implementation YFBSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的礼物";
    self.view.backgroundColor = [UIColor whiteColor];
    self.sliderView = [[YFBSliderView alloc] init];
    _sliderView.titlesArr = @[@"全部",@"聊天服务",@"线上游戏",@"虚拟女朋友"];
    
    [self.view addSubview:_sliderView];
    
    [_sliderView setSlideHeadView];
    
//    YFBMyGiftDetailController *sendGiftVC = [[YFBMyGiftDetailController alloc] initWithIsSendGift:YES];
//    YFBMyGiftDetailController *fetchGiftVC = [[YFBMyGiftDetailController alloc] initWithIsSendGift:NO];
//    [_sliderView addChildViewController:fetchGiftVC title:_sliderView.titlesArr.firstObject];
//    [_sliderView addChildViewController:sendGiftVC title:_sliderView.titlesArr.lastObject];
//    [_sliderView setSlideHeadView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@interface YFBSocialContentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) YFBSocialType socialType;
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBSocialContentViewController

- (instancetype)initWithSocialType:(YFBSocialType)socialType {
    self = [super init];
    if (self) {
        _socialType = socialType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#ffffff");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


