//
//  YFBRecommendVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRecommendVC.h"
#import "YFBRecommendCell.h"
#import "YFBRobot.h"

static NSString *const kYFBRecommendCellReusableIdentifier = @"kYFBRecommendCellReusableIdentifier";

@interface YFBRecommendVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YFBRecommendVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
    for (int i = 0; i < 30; i++) {
        YFBRobot * robot = [[YFBRobot alloc] init];
        robot.userId = @"123123";
        robot.nickName = @"气泡熊";
        robot.avatarUrl = @"http://hwimg.jtd51.com/wysy/video/imgcover/20160818dj53.jpg";
        robot.height = @"176cm";
        robot.age = @"23岁";
        robot.userSex = YFBUserSexFemale;
        [self.dataSource addObject:robot];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRecommendCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        cell.userNameStr = robot.nickName;
        cell.userImgUrl = robot.avatarUrl;
        cell.userAge  = robot.age;
        cell.userHeight = robot.height;
        cell.userSex = robot.userSex;
        cell.greeted = robot.greeted;
        @weakify(self);
        cell.greeting = ^(id sender) {
            @strongify(self);
            UIButton *thisButton = (UIButton *)sender;
            if (!thisButton.isSelected) {
                thisButton.selected = YES;
                //打招呼
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
