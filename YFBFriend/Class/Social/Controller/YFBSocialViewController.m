//
//  YFBSocialViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/6/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSocialViewController.h"
#import "YFBSliderView.h"
#import "YFBSocialModel.h"

@interface YFBSocialViewController ()
@property (nonatomic) YFBSliderView *sliderView;
@end

@implementation YFBSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的礼物";
    self.view.backgroundColor = [UIColor whiteColor];
    self.sliderView = [[YFBSliderView alloc] init];
    NSArray *titles = @[@"全部",@"聊天服务",@"线上游戏",@"虚拟女朋友"];
    _sliderView.titlesArr = titles;
    
    YFBSocialContentViewController *allVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeAll];
    YFBSocialContentViewController *chatVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeChat];
    YFBSocialContentViewController *gameVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGame];
    YFBSocialContentViewController *gfVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGF];
    [_sliderView addChildViewController:allVC title:titles[0]];
    [_sliderView addChildViewController:chatVC title:titles[1]];
    [_sliderView addChildViewController:gameVC title:titles[2]];
    [_sliderView addChildViewController:gfVC title:titles[3]];
    
    [self.view addSubview:_sliderView];
    [_sliderView setTabbarHeight:49];
    [_sliderView setSlideHeadView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@interface YFBSocialContentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) YFBSocialType socialType;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) YFBSocialModel *socialModel;
@end

@implementation YFBSocialContentViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBSocialModel, socialModel)

- (instancetype)initWithSocialType:(YFBSocialType)socialType {
    self = [super init];
    if (self) {
        _socialType = socialType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
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

- (void)getSocialContent {
    @weakify(self);
    [self.socialModel fetchSocialContentWithType:_socialType CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

@end


