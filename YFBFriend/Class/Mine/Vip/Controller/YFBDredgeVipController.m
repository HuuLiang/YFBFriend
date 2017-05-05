//
//  YFBDredgeVipController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDredgeVipController.h"
#import "YFBDredgeVipPayCell.h"
#import "YFBDredgeVipPrivilegeCell.h"
#import "YFBBuyDiamondPrivilegeCell.h"
#import "YFBVipExampleCell.h"
#import "YFBPayConfigManager.h"

#define MorePrivilegeArray            @[@"1.仅VIP用户可查看联系方式",@"2.仅VIP用户可查看访问列表"]



typedef NS_ENUM(NSUInteger, YFBDredgeVipType) {
    YFBDredgeVipSectionPay = 0, //开通VIP
    YFBDredgeVipSectionPrivilege, //特权
    YFBDredgeVipSectionMorePrivilege, //更多特权
    YFBDredgeVipSectionExample, //已充值用户
    YFBDredgeVipSection
};

static NSString *const kYFBDredgeVipPayCellReusableIdentifier = @"DredgeVipPayCellReusableIdentifier";
static NSString *const kYFBDredgeVipPrivilegeReusableIdentifier = @"DredgeVipPrivilegeReusableIdentifier";
static NSString *const kYFBDredgeVipMorePrivilegeReusableIdentifier = @"YFBDredgeVipMorePrivilegeReusableIdentifier";
static NSString *const kYFBFriendVipExampleCellReusableIdentifier = @"kYFBFriendVipExampleCellReusableIdentifier";

@interface YFBDredgeVipController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) YFBVipExampleCell *exampleCell;
@end

@implementation YFBDredgeVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[YFBDredgeVipPayCell class] forCellReuseIdentifier:kYFBDredgeVipPayCellReusableIdentifier];
    [_tableView registerClass:[YFBDredgeVipPrivilegeCell class] forCellReuseIdentifier:kYFBDredgeVipPrivilegeReusableIdentifier];
    [_tableView registerClass:[YFBBuyDiamondPrivilegeCell class] forCellReuseIdentifier:kYFBDredgeVipMorePrivilegeReusableIdentifier];
    [_tableView registerClass:[YFBVipExampleCell class] forCellReuseIdentifier:kYFBFriendVipExampleCellReusableIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
//    _tableView.tableHeaderView = [self configTableHeaderView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _exampleCell.scrollStart = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)configTableHeaderView {
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipheader.jpg"]];
    headerImageView.size = CGSizeMake(kScreenWidth, kScreenWidth*4/15);
    return headerImageView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBDredgeVipSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBDredgeVipSectionPay) {
        return 1;
    } else if (section == YFBDredgeVipSectionPrivilege) {
        return 4;
    } else if (section == YFBDredgeVipSectionMorePrivilege) {
        return 2;
    } else if (section == YFBDredgeVipSectionExample) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.section == YFBDredgeVipSectionPay) {
        YFBDredgeVipPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDredgeVipPayCellReusableIdentifier forIndexPath:indexPath];
        cell.lessTime = [NSString stringWithFormat:@"%ld天",[YFBPayConfigManager manager].vipInfo.firstInfo.amount];
        cell.lessPrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.firstInfo.price/100)];
        cell.lessTitle = [NSString stringWithFormat:@"(%.1f元/天)",(float)[YFBPayConfigManager manager].vipInfo.firstInfo.price/100/[YFBPayConfigManager manager].vipInfo.firstInfo.amount];
        cell.moreTime = [NSString stringWithFormat:@"%ld天",[YFBPayConfigManager manager].vipInfo.secondInfo.amount];
        cell.morePrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.secondInfo.price/100)];
        cell.moreTitle = [NSString stringWithFormat:@"(%.1f元/天)",(float)[YFBPayConfigManager manager].vipInfo.secondInfo.price/100/[YFBPayConfigManager manager].vipInfo.secondInfo.amount];
        cell.payAction = ^(id sender){
            @strongify(self);
            //支付
        };
        return cell;
    } else if (indexPath.section == YFBDredgeVipSectionPrivilege) {
        YFBDredgeVipPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDredgeVipPrivilegeReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row < 4) {
            cell.index = indexPath.row;
        }
        return cell;
    } else if (indexPath.section == YFBDredgeVipSectionMorePrivilege) {
        YFBBuyDiamondPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDredgeVipMorePrivilegeReusableIdentifier forIndexPath:indexPath];
        cell.title = MorePrivilegeArray[indexPath.row];
        return cell;
    } else if (indexPath.section == YFBDredgeVipSectionExample) {
        _exampleCell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendVipExampleCellReusableIdentifier forIndexPath:indexPath];
        _exampleCell.userList = @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888",@"999",@"101010",@"111111",@"121212",@"131313"];
        return _exampleCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDredgeVipSectionPay) {
        return kWidth(440);
    } else if (indexPath.section == YFBDredgeVipSectionPrivilege) {
        return kWidth(130);
    } else if (indexPath.section == YFBDredgeVipSectionMorePrivilege) {
        return kWidth(60);
    } else if (indexPath.section == YFBDredgeVipSectionExample) {
        return kWidth(280);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < YFBDredgeVipSection) {
        return kWidth(80);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == YFBDredgeVipSectionExample) {
        return 10;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == YFBDredgeVipSectionPay) {
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
        if (section == YFBDredgeVipSectionPrivilege) {
            titleLabel.text = @"热门特权";
        } else if (section == YFBDredgeVipSectionMorePrivilege) {
            titleLabel.text = @"更多特权";
        } else if (section == YFBDredgeVipSectionExample) {
            titleLabel.text = @"已充值VIP用户";
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDredgeVipSectionExample) {
        YFBVipExampleCell *exampleCell = (YFBVipExampleCell *)cell;
        exampleCell.scrollStart = YES;
    }
}
@end
