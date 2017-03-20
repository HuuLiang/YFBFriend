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

typedef NS_ENUM(NSUInteger, YFBDredgeVipType) {
    YFBDredgeVipSectionPay = 0, //开通VIP
    YFBDredgeVipSectionPrivilege, //特权
    YFBDredgeVipSectionMorePrivilege, //更多特权
    YFBDredgeVipSectionExample, //已充值用户
    YFBDredgeVipSection
};

static NSString *const kYFBDredgeVipPayCellReusableIdentifier = @"DredgeVipPayCellReusableIdentifier";
static NSString *const kYFBDredgeVipPrivilegeReusableIdentifier = @"DredgeVipPrivilegeReusableIdentifier";

@interface YFBDredgeVipController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation YFBDredgeVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[YFBDredgeVipPayCell class] forCellReuseIdentifier:kYFBDredgeVipPayCellReusableIdentifier];
    [_tableView registerClass:[YFBDredgeVipPrivilegeCell class] forCellReuseIdentifier:kYFBDredgeVipPrivilegeReusableIdentifier];
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
    // Dispose of any resources that can be recreated.
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
        return 0;
    } else if (section == YFBDredgeVipSectionExample) {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.section == YFBDredgeVipSectionPay) {
        YFBDredgeVipPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDredgeVipPayCellReusableIdentifier forIndexPath:indexPath];
        cell.lessTime = @"30天";
        cell.lessPrice = @"¥50";
        cell.moreTime = @"90天";
        cell.morePrice = @"¥100";
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
        return nil;
    } else if (indexPath.section == YFBDredgeVipSectionExample) {
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDredgeVipSectionPay) {
        return kWidth(440);
    } else if (indexPath.section == YFBDredgeVipSectionPrivilege) {
        return kWidth(130);
    } else if (indexPath.section == YFBDredgeVipSectionMorePrivilege) {
        return 1;
    } else if (indexPath.section == YFBDredgeVipSectionExample) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBDredgeVipSectionPay) {
        return 10;
    } else if (section == YFBDredgeVipSectionPrivilege) {
        return 1;
    } else if (section == YFBDredgeVipSectionMorePrivilege) {
        return 1;
    } else if (section == YFBDredgeVipSectionExample) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

@end
