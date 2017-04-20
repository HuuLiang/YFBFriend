//
//  YFBRecommendVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRecommendVC.h"
#import "YFBRecommendCell.h"
#import "YFBDiscoverModel.h"
#import "YFBGreetingInfoModel.h"
#import "YFBRobot.h"
#import "YFBInteractionManager.h"

static NSString *const kYFBRecommendCellReusableIdentifier = @"kYFBRecommendCellReusableIdentifier";

@interface YFBRecommendVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBDiscoverModel *discoverModel;
@property (nonatomic,strong) YFBRmdNearByDtoModel *response;
@end

@implementation YFBRecommendVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBDiscoverModel, discoverModel)
QBDefineLazyPropertyInitialization(YFBRmdNearByDtoModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:kColor(@"#E6E6E6")];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.rowHeight = kWidth(200);
    [_tableView registerClass:[YFBRecommendCell class] forCellReuseIdentifier:kYFBRecommendCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
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
}

- (void)loadDataWithPageCount:(NSInteger)pageNum refresh:(BOOL)isRefresh {
    @weakify(self);
    [self.discoverModel fetchUserInfoWithType:kYFBFriendDiscoverRecommendKeyName pageNum:pageNum CompletionHandler:^(BOOL success, YFBRmdNearByDtoModel * obj) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            self.response = obj;
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:obj.userList];
        }
        [self->_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRecommendCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *info = self.dataSource[indexPath.row];
        cell.userNameStr = info.nickName;
        cell.userImgUrl = info.portraitUrl;
        cell.userAge  = [NSString stringWithFormat:@"%ld岁",(long)info.age];
        cell.userHeight = info.height;
        cell.userSex = [info.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
        cell.greeted = [YFBRobot checkUserIsGreetedWithUserId:info.userId];
        @weakify(self);
        cell.greeting = ^(id sender) {
            @strongify(self);
            UIButton *thisButton = (UIButton *)sender;
            if (!thisButton.isSelected) {
                thisButton.selected = YES;
                //打招呼                
                [[YFBInteractionManager manager] greetWithUserInfoList:@[info] handler:^(BOOL success) {
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
