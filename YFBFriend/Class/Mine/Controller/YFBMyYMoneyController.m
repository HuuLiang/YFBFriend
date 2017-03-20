//
//  YFBMyYMoneyController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyYMoneyController.h"
#import "YFBMyYMoneyCell.h"
#import "YFBMyYMoneyPayCell.h"
#import "YFBPayUsersCell.h"

static NSString *const kYFBMyMoneyPayCellIdentifier = @"k_yfb_mymoney_pay_cell_identifier";
static NSString *const kYFBMyMoneyPayUserCellIdentifier = @"k_yfb_mymoney_pay_user_identifier";

typedef NS_ENUM(NSUInteger, YFBYMoneySectionType) {
    YFBYMoneySectionTypeTitle,
    YFBYMoneySectionTypePrivilege,
    YFBYMoneySectionTypeUser,
    YFBYMoneySectionTypeCoutn
};

static NSString *const kYFBYMoneyCellIdentifier = @"yfb_ymoney_cell_identifier_kye";

@interface YFBMyYMoneyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    UITableViewCell *_privilegeCell;
}
@end

@implementation YFBMyYMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#ffffff");
    self.hidesBottomBarWhenPushed = YES;
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = kColor(@"#efeff4");
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[YFBMyYMoneyCell class] forCellReuseIdentifier:kYFBYMoneyCellIdentifier];
    [_layoutTableView registerClass:[YFBMyYMoneyPayCell class] forCellReuseIdentifier:kYFBMyMoneyPayCellIdentifier];
    [_layoutTableView registerClass:[YFBPayUsersCell class] forCellReuseIdentifier:kYFBMyMoneyPayUserCellIdentifier];
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
    return YFBYMoneySectionTypeCoutn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBYMoneySectionTypeTitle) {
        return 2;
    }else if (section == YFBYMoneySectionTypePrivilege){
        return 1;
    }else if (section == YFBYMoneySectionTypeUser){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBYMoneySectionTypeTitle) {
        if (indexPath.row == 0) {
            YFBMyYMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBYMoneyCellIdentifier forIndexPath:indexPath];
            return cell;
        }else if (indexPath.row == 1){
            YFBMyYMoneyPayCell *payCell = [tableView dequeueReusableCellWithIdentifier:kYFBMyMoneyPayCellIdentifier forIndexPath:indexPath];
            payCell.title = @"5000Y币";
            payCell.subTitle = @"¥ 50";
            payCell.detailTitle = @"可与MM发消息";
            payCell.moreTitle = @"11000Y币";
            payCell.moreSubTitle = @"¥ 100";
            payCell.moreDetailTitle = @"赠送100元话费";
            return payCell;
        }
    }else if (indexPath.section == YFBYMoneySectionTypePrivilege){
        if (!_privilegeCell) {
            _privilegeCell = [[UITableViewCell alloc] init];
            _privilegeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = kFont(13);
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"1、充值Y币可与MM无限制聊天\n2、购买宠物守护摇钱树\n3、购买体力值" ];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = kWidth(18.);
            [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
            [attribute addAttribute:NSForegroundColorAttributeName value:kColor(@"#999999") range:NSMakeRange(0, 15)];
            titleLabel.attributedText = attribute.copy;
            titleLabel.numberOfLines = 0;
            [_privilegeCell addSubview:titleLabel];
            {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.right.mas_equalTo(_privilegeCell);
                    make.left.mas_equalTo(_privilegeCell).mas_offset(kWidth(20));
                }];
            }
            return _privilegeCell;
        }
    }else if (indexPath.section == YFBYMoneySectionTypeUser){
        YFBPayUsersCell *payUserCell = [tableView dequeueReusableCellWithIdentifier:kYFBMyMoneyPayUserCellIdentifier forIndexPath:indexPath];
        payUserCell.models = @[[YFBPayUserModel creatWithName:@"张胜男" text:@"两分钟前充值50元Y币" getCharge:NO],
                               [YFBPayUserModel creatWithName:@"张胜男1" text:@"两分钟前充值100元Y币,获得了100元话费" getCharge:YES],
                               [YFBPayUserModel creatWithName:@"张胜男2" text:@"两分钟前充值50元Y币" getCharge:NO],
                               [YFBPayUserModel creatWithName:@"张胜男3" text:@"两分钟前充值150元Y币,获得了100元话费" getCharge:YES],
                               [YFBPayUserModel creatWithName:@"张胜男4" text:@"两分钟前充值50元Y币" getCharge:NO]];
        return payUserCell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBYMoneySectionTypeTitle) {
        if (indexPath.row == 0) {
            return kWidth(280);
        }else if (indexPath.row == 1){
            return kWidth(440);
        }
    }else if (indexPath.section == YFBYMoneySectionTypePrivilege){
        return kWidth(200);
    }else if (indexPath.section == YFBYMoneySectionTypeUser){
        return kWidth(320);
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == YFBYMoneySectionTypePrivilege) {
        return @"Y币特权";
    }else if (section == YFBYMoneySectionTypeUser){
    return @"购买Y币用户";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBYMoneySectionTypeTitle) {
        return 2;
    }else if (section == YFBYMoneySectionTypePrivilege || section == YFBYMoneySectionTypeUser){
        return 40;
    }
    return 1;
}

@end
