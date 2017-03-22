//
//  YFBRankVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRankVC.h"
#import "YFBSliderView.h"

@interface YFBRankVC ()
@property (nonatomic,strong) YFBSliderView *sliderView;
@end

@implementation YFBRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sliderView = [[YFBSliderView alloc] init];
    _sliderView.tabbarHeight = 49;
    _sliderView.backgroundColor = kColor(@"#efefef");
    _sliderView.titlesArr = @[@"土豪榜",@"魅力榜"];
    [self.view addSubview:_sliderView];
    
    YFBRankDetailVC *rankSendVC = [[YFBRankDetailVC alloc] initWithRankType:YFBRankTypeSend];
    [_sliderView addChildViewController:rankSendVC title:_sliderView.titlesArr.firstObject];
    
    YFBRankDetailVC *rankReceiveVC = [[YFBRankDetailVC alloc] initWithRankType:YFBRankTypereceived];
    [_sliderView addChildViewController:rankReceiveVC title:_sliderView.titlesArr.lastObject];
    
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    _sliderView.titleScrollView.backgroundColor = kColor(@"#efefef");
}

@end

#pragma mark - ---------------榜单详情------------------

#import "YFBRankDetailCell.h"
#import "YFBRobot.h"

static NSString *const kYFBRankDetailCellReusableIdentifier = @"YFBRankDetailCellReusableIdentifier";

@interface YFBRankDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) YFBRankType rankType;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton       *rankButton;
@end

@implementation YFBRankDetailVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithRankType:(YFBRankType)type
{
    self = [super init];
    if (self) {
        _rankType = type;
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = kColor(@"#ffffff");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBRankDetailCell class] forCellReuseIdentifier:kYFBRankDetailCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    _tableView.tableHeaderView = [self tableHeaderView];
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    for (int i = 0; i < 30; i++) {
        YFBRobot * robot = [[YFBRobot alloc] init];
        robot.userId = @"123123";
        robot.nickName = @"气泡熊";
        robot.avatarUrl = @"http://hwimg.jtd51.com/wysy/video/imgcover/20160818dj53.jpg";
        robot.height = @"176cm";
        robot.age = @"23岁";
        robot.distance = @" 1.13km ";
        robot.userSex = (long)_rankType;
        [self.dataSource addObject:robot];
    }
    [_tableView reloadData];

}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] init];
    self.rankButton = [[UIButton alloc] init];
    [_rankButton setTitle:@"本周排名" forState:UIControlStateNormal];
    [_rankButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _rankButton.titleLabel.font = kFont(14);
    [_rankButton setImage:[UIImage imageNamed:@"login_choose"] forState:UIControlStateNormal];
    [headerView addSubview:_rankButton];
    
    NSString *typeStr;
    if (_rankType == YFBRankTypeSend) {
        typeStr = @"送出多少：";
    } else {
        typeStr = @"收到多少：";
    }
    NSInteger count = arc4random() % 1000 + 300;
    NSString *rankStr = [NSString stringWithFormat:@"%@%ld",typeStr,count];
    UILabel *rankTypeLabel = [[UILabel alloc] init];
    rankTypeLabel.font = kFont(12);
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:rankStr attributes:@{NSForegroundColorAttributeName:kColor(@"#97BCF0")}];
    NSRange range = [rankStr rangeOfString:typeStr];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:kColor(@"#999999")} range:range];
    rankTypeLabel.attributedText = attriStr;
    [headerView addSubview:rankTypeLabel];
    
    {
        [_rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView.mas_left).offset(kWidth(40));
            make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(30)));
        }];
        
        [rankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView.mas_right).offset(-kWidth(200));
            make.height.mas_equalTo(kWidth(30));
        }];
    }
    headerView.size = CGSizeMake(kScreenWidth, kWidth(72));
    return headerView;
}

- (void)viewDidLayoutSubviews {
    UIEdgeInsets imageEdge = _rankButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = _rankButton.titleEdgeInsets;
    
    _rankButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left + kWidth(120), imageEdge.bottom, imageEdge.right-kWidth(120));
    _rankButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left - kWidth(20) , titleEdge.bottom, titleEdge.right + kWidth(20));
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRankDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRankDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        
        cell.index = indexPath.row;
        cell.userImageUrl = robot.avatarUrl;
        cell.nickName = robot.nickName;
        cell.userSex = robot.userSex;
        cell.age = robot.age;
        cell.distance = robot.distance;
        cell.rankType = _rankType;
        cell.giftCount = [NSString stringWithFormat:@"%ld",(long)arc4random() % 30 + 5];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(138);
}
@end
