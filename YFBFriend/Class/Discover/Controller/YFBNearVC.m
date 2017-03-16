//
//  YFBNearVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBNearVC.h"
#import "YFBRecommendCell.h"
#import "YFBRobot.h"

static NSString *const kYFBNearCellReusableIdentifier = @"kYFBNearCellReusableIdentifier";

@interface YFBNearVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton   *greetAllButton;
@end

@implementation YFBNearVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
    for (int i = 0; i < 30; i++) {
        YFBRobot * robot = [[YFBRobot alloc] init];
        robot.userId = @"123123";
        robot.nickName = @"气泡熊";
        robot.avatarUrl = @"http://hwimg.jtd51.com/wysy/video/imgcover/20160818dj53.jpg";
        robot.height = @"176cm";
        robot.age = @"23岁";
        robot.userSex = YFBUserSexFemale;
        robot.distance = @"1.13km";
        [self.dataSource addObject:robot];
    }
    
    _tableView.tableFooterView = [self tableFooterView];
    
    [_tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        YFBRobot *robot = self.dataSource[indexPath.row];
        cell.userNameStr = robot.nickName;
        cell.userImgUrl = robot.avatarUrl;
        cell.userAge  = robot.age;
        cell.userHeight = robot.height;
        cell.userSex = robot.userSex;
        cell.distance = robot.distance;
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
