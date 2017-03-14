//
//  YFBMineViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineViewController.h"
#import "YFBMineHeaderCell.h"
#import "YFBMineCell.h"
#import "YFBVerifyViewController.h"

static NSString *const YFBMineHeaderCellIdentifier = @"yfb_mine_header_cell_identifier";
static NSString *const YFBMineCellIdentifier = @"yfb_mine_cell_identifier";

typedef NS_ENUM(NSUInteger, YFBMineSectionType) {
    YFBMineSectionTypeHeader,
    YFBMineSectionTypeRecord,
    YFBMineSectionTypeWallet,
    YFBMineSectionTypeInfo,
    YFBMineSectionTypeSetting,
    YFBMineSectionTypeCount
};

typedef NS_ENUM(NSUInteger, YFBRecordRowType) {
    //    YFBRecordRowTypeLootRecord,//抢夺记录
    YFBRecordRowTypeAttention,//谁关注我
    YFBRecordRowTypeCount,
};

typedef NS_ENUM(NSUInteger, YFBWlletRowType) {
    //    YFBWlletRowTypeWllet,//我的钱包
    YFBWlletRowTypeYmoney,//我的Y币
    YFBWlletRowTypeDiamond,//我的钻石
    YFBWlletRowTypeGift,//我的礼物
    YFBWlletRowTypeCount
};

typedef NS_ENUM(NSUInteger, YFBMineInfoType) {
    YFBMineInfoTypeInfo,//个人资料
    YFBMineInfoTypePhoto,//我的相册
    YFBMineInfoTypeCount,
};

@interface YFBMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    
}
@end

@implementation YFBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = kColor(@"#efeff4");
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[YFBMineHeaderCell class] forCellReuseIdentifier:YFBMineHeaderCellIdentifier];
    [_layoutTableView registerClass:[YFBMineCell class] forCellReuseIdentifier:YFBMineCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return YFBMineSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBMineSectionTypeHeader) {
        return 1;
    }else if (section == YFBMineSectionTypeRecord){
        return YFBRecordRowTypeCount;
    }else if (section == YFBMineSectionTypeWallet){
        return YFBWlletRowTypeCount;
    }else if (section == YFBMineSectionTypeInfo){
        return YFBMineInfoTypeCount;
    }else if (section == YFBMineSectionTypeSetting){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMineSectionTypeHeader) {
        YFBMineHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:YFBMineHeaderCellIdentifier forIndexPath:indexPath];
        headerCell.headerUrl = @"http://cdn.duitang.com/uploads/item/201507/22/20150722145119_hJnyP.jpeg";
        headerCell.name = @"李涛";
        headerCell.idNumber = @"23346677";
        headerCell.invite = @"RC456";
        @weakify(self);
        headerCell.ktVipAction = ^(id sender){
//            @strongify(self);
            
        };
        headerCell.attestationAction = ^(id sender){
            @strongify(self);
            YFBVerifyViewController *verifyVC = [[YFBVerifyViewController alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        };
        
        return headerCell;
    }else if (indexPath.section == YFBMineSectionTypeRecord){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        //        if (indexPath.row == YFBRecordRowTypeLootRecord) {
        //            cell.title = @"抢夺记录";
        //            cell.iconImage = @"mine_duobao_record_icon";
        //        }else
        if (indexPath.row == YFBRecordRowTypeAttention){
            cell.subTitle = nil;
            cell.title = @"谁关注我";
            cell.iconImage = @"mine_attention_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeWallet){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        //        if (indexPath.row == YFBWlletRowTypeWllet) {
        //            cell.title = @"我的钱包";
        //            cell.iconImage = @"mine_my_wallet_icon";
        //        }else
        if (indexPath.row == YFBWlletRowTypeYmoney){
            cell.title = @"我的Y币";
            cell.subTitle = @"10";
            cell.iconImage = @"mine_my_Ymoney_icon";
        }else if (indexPath.row == YFBWlletRowTypeDiamond){
            cell.title = @"我的钻石";
            cell.subTitle = @"200";
            cell.iconImage = @"mine_my_diamond_icon";
        }else if (indexPath.row == YFBWlletRowTypeGift){
            cell.title = @"我的礼物";
            cell.iconImage = @"mine_my_gift_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeInfo){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        if (indexPath.row == YFBMineInfoTypeInfo) {
            cell.title = @"个人资料";
            cell.iconImage = @"mine_my_info_icon";
        }else if (indexPath.row == YFBMineInfoTypePhoto){
            cell.title = @"我的相册";
            cell.iconImage = @"mine_my_photo_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeSetting){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        cell.title = @"设置";
        cell.iconImage = @"mine_setting_icon";
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMineSectionTypeHeader) {
        return kWidth(286);
    }
    else if (indexPath.section == YFBMineSectionTypeRecord){
        if (indexPath.row == YFBRecordRowTypeAttention) {
            return kWidth(120);
        }
    }
    return kWidth(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(24);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = kColor(@"#efeff4");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == YFBMineSectionTypeRecord){
        
        if (indexPath.row == YFBRecordRowTypeAttention){
            
        }
        
    }else if (indexPath.section == YFBMineSectionTypeWallet){
        
        if (indexPath.row == YFBWlletRowTypeYmoney){
            
            
        }else if (indexPath.row == YFBWlletRowTypeDiamond){
            
            
        }else if (indexPath.row == YFBWlletRowTypeGift){
            
        }
    }else if (indexPath.section == YFBMineSectionTypeInfo){
        
        if (indexPath.row == YFBMineInfoTypeInfo) {
            
            
        }else if (indexPath.row == YFBMineInfoTypePhoto){
            
            
        }
    }else if (indexPath.section == YFBMineSectionTypeSetting){
        
    }
    
}


@end