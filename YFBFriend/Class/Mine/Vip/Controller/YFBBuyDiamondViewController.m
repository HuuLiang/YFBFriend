//
//  YFBBuyDiamondViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/4/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBuyDiamondViewController.h"
#import "YFBDredgeVipPayCell.h"
#import "YFBBuyDiamondPrivilegeCell.h"
#import "YFBVipExampleCell.h"
#import "YFBPayConfigManager.h"

#define MorePrivilegeArray            @[@"1.仅VIP用户可查看联系方式",@"2.仅VIP用户可查看访问列表",@"3.充值钻石聊天80钻石/条信息",@"4.钻石可购买礼物"]

static NSString *const kYFBFriendBuyDiamondCellReusableIdentifier = @"kYFBFriendBuyDiamondCellReusableIdentifier";
static NSString *const kYFBFriendBuyDiamondPrivilegeCellReusableIdentifier = @"kYFBFriendBuyDiamondPrivilegeCellReusableIdentifier";
static NSString *const kYFBFriendBuyDiamondExampleCellReusableIdentifier = @"kYFBFriendBuyDiamondExampleCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, YFBBuyDiamondSection) {
    YFBBuyDiamondSectionPay = 0, //开通VIP
    YFBBuyDiamondSectionPrivilege, //特权
    YFBBuyDiamondSectionExample, //已充值用户
    YFBDredgeVipSectionCount
};


@interface YFBBuyDiamondViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) YFBVipExampleCell *exampleCell;
@end

@implementation YFBBuyDiamondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");
    self.hidesBottomBarWhenPushed = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efeff4");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[YFBDredgeVipPayCell class] forCellReuseIdentifier:kYFBFriendBuyDiamondCellReusableIdentifier];
    [_tableView registerClass:[YFBBuyDiamondPrivilegeCell class] forCellReuseIdentifier:kYFBFriendBuyDiamondPrivilegeCellReusableIdentifier];
    [_tableView registerClass:[YFBVipExampleCell class] forCellReuseIdentifier:kYFBFriendBuyDiamondExampleCellReusableIdentifier];
    _tableView.tableHeaderView = [self configTableHeaderView];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    _exampleCell.scrollStart = YES;
//}
//
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _exampleCell.scrollStart = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)configTableHeaderView {
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipheader.jpg"]];
    headerImageView.size = CGSizeMake(kScreenWidth, kScreenWidth*4/15);
    return headerImageView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBDredgeVipSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBBuyDiamondSectionPay) {
        return 1;
    } else if (section == YFBBuyDiamondSectionPrivilege) {
        return 4;
    } else if (section == YFBBuyDiamondSectionExample) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.section == YFBBuyDiamondSectionPay) {
        YFBDredgeVipPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendBuyDiamondCellReusableIdentifier forIndexPath:indexPath];
        cell.lessTime = [NSString stringWithFormat:@"%ld钻石",[YFBPayConfigManager manager].diamondInfo.firstInfo.amount];
        cell.lessPrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.firstInfo.price/100)];
        cell.lessTitle = [YFBPayConfigManager manager].diamondInfo.firstInfo.detail;
        cell.moreTime = [NSString stringWithFormat:@"%ld钻石",[YFBPayConfigManager manager].diamondInfo.secondInfo.amount];
        cell.morePrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.secondInfo.price/100)];
        cell.moreTitle = [YFBPayConfigManager manager].diamondInfo.secondInfo.detail;
        cell.payAction = ^(id sender){
            @strongify(self);
            //支付
        };
        return cell;
    } else if (indexPath.section == YFBBuyDiamondSectionPrivilege) {
        YFBBuyDiamondPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendBuyDiamondPrivilegeCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row < MorePrivilegeArray.count) {
            cell.title = MorePrivilegeArray[indexPath.row];
        }
        return cell;
    } else if (indexPath.section == YFBBuyDiamondSectionExample) {
        _exampleCell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendBuyDiamondExampleCellReusableIdentifier forIndexPath:indexPath];
        _exampleCell.userList = @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888",@"999",@"101010",@"111111",@"121212",@"131313"];
        return _exampleCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBBuyDiamondSectionPay) {
        return kWidth(440);
    } else if (indexPath.section == YFBBuyDiamondSectionPrivilege) {
        return kWidth(60);
    } else if (indexPath.section == YFBBuyDiamondSectionExample) {
        return kWidth(280);
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < YFBDredgeVipSectionCount) {
        return kWidth(80);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == YFBBuyDiamondSectionExample) {
        return 10;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == YFBBuyDiamondSectionPay) {
        headerView.backgroundColor = kColor(@"#FFFBF0");
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor(@"#CDBE93");
        titleLabel.font = kFont(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"已开通VIP用户：11111人";
        [headerView addSubview:titleLabel];
        {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headerView);
                make.height.mas_equalTo(kWidth(34));
            }];
        }
    } else {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor(@"#666666");
        titleLabel.font = kFont(15);
        [headerView addSubview:titleLabel];
        {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(42));
            }];
        }
        if (section == YFBBuyDiamondSectionPrivilege) {
            titleLabel.text = @"热门特权";
        } else if (section == YFBBuyDiamondSectionExample) {
            titleLabel.text = @"已购买钻石用户";
        }
        headerView.backgroundColor = kColor(@"#efefef");
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBBuyDiamondSectionExample) {
        YFBVipExampleCell *exampleCell = (YFBVipExampleCell *)cell;
        exampleCell.scrollStart = YES;
    }
}

@end
