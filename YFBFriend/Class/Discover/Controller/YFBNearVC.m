//
//  YFBNearVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBNearVC.h"
#import "YFBRecommendCell.h"
#import "YFBDiscoverModel.h"
#import "YFBGreetingInfoModel.h"
#import "YFBRobot.h"
#import "YFBInteractionManager.h"

static NSString *const kYFBNearCellReusableIdentifier = @"kYFBNearCellReusableIdentifier";

@interface YFBNearVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBDiscoverModel *discoverModel;
@property (nonatomic,strong) YFBRmdNearByDtoModel *response;
@property (nonatomic,strong) UIButton   *greetAllButton;
@end

@implementation YFBNearVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBDiscoverModel, discoverModel)
QBDefineLazyPropertyInitialization(YFBRmdNearByDtoModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:kColor(@"#E6E6E6")];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.rowHeight = kWidth(200);
    [_tableView registerClass:[YFBRecommendCell class] forCellReuseIdentifier:kYFBNearCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

    
    _tableView.tableFooterView = [self tableFooterView];
    _tableView.tableFooterView.hidden = YES;
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithPageCount:1 refresh:YES];
    }];
    
    [_tableView YFB_addPagingRefreshWithHandler:^{
        @strongify(self);
        if (self.response.pageNum < self.response.pageCount) {
            self.response.pageNum++;
        } else if (self.response.pageNum) {
            [[YFBHudManager manager] showHudWithText:@"所有数据加载完成"];
            [self->_tableView YFB_endPullToRefresh];
            return ;
        }
        [self loadDataWithPageCount:self.response.pageNum refresh:NO];
    }];
    
    [_tableView YFB_triggerPullToRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithPageCount:(NSInteger)pageNum refresh:(BOOL)isRefresh {
    @weakify(self);
    [self.discoverModel fetchUserInfoWithType:kYFBFriendDiscoverNearbyKeyName pageNum:pageNum CompletionHandler:^(BOOL success, YFBRmdNearByDtoModel * obj) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            self->_tableView.tableFooterView.hidden = NO;
            self.response = obj;
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:obj.userList];
        }
        [self->_tableView reloadData];
    }];
}


- (void)viewDidLayoutSubviews {
    UIEdgeInsets imageEdge = _greetAllButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = _greetAllButton.titleEdgeInsets;
    
    _greetAllButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left - 5, imageEdge.bottom, imageEdge.right + 5);
    _greetAllButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left + 5 , titleEdge.bottom, titleEdge.right - 5);
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] init];
    self.greetAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_greetAllButton setTitle:@"群打招呼" forState:UIControlStateNormal];
    [_greetAllButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    [_greetAllButton setImage:[UIImage imageNamed:@"discover_allgreet"] forState:UIControlStateNormal];
    [_greetAllButton setBackgroundColor:kColor(@"#8458D0")];
    _greetAllButton.titleLabel.font = kFont(17);
    _greetAllButton.layer.cornerRadius = 4;
    _greetAllButton.layer.masksToBounds = YES;
    [footerView addSubview:_greetAllButton];
    @weakify(self);
    [_greetAllButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        //批量打招呼
        [[YFBInteractionManager manager] greetWithUserInfoList:self.dataSource toAllUsers:YES handler:^(BOOL success) {
            if (success) {
                [self->_tableView reloadData];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_greetAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kWidth(263*2), kWidth(72)));
    }];
    
    footerView.size = CGSizeMake(kScreenWidth, kWidth(108));
    return footerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBNearCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *info = self.dataSource[indexPath.row];
        cell.userNameStr = info.nickName;
        cell.userImgUrl = info.portraitUrl;
        cell.userAge  = [NSString stringWithFormat:@"%ld岁",(long)info.age];
        cell.userHeight = info.height;
        cell.distance = info.distance;
        cell.userSex = [info.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
        cell.greeted = [YFBRobot checkUserIsGreetedWithUserId:info.userId];
        @weakify(self);
        cell.greeting = ^(id sender) {
            @strongify(self);
            UIButton *thisButton = (UIButton *)sender;
            if (!thisButton.isSelected) {
                thisButton.selected = YES;
                //打招呼
                [[YFBInteractionManager manager] greetWithUserInfoList:@[info] toAllUsers:NO handler:^(BOOL success) {
                    if (success) {
                        YFBRecommendCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        cell.greeted  = YES;
                    }
                }];
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        [self pushIntoDetailVC:robot.userId];
    }
}

@end
