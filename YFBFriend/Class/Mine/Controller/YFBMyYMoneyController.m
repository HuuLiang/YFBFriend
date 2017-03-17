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

static NSString *const kYFBMyMoneyPayCellIdentifier = @"k_yfb_mymoney_pay_cell_identifier";

typedef NS_ENUM(NSUInteger, YFBYMoneySectionType) {
    YFBYMoneySectionTypeTitle,
    //    YFBYMoneySectionTypePrivilege,
    //    YFBYMoneySectionTypeUser,
    YFBYMoneySectionTypeCoutn
};

static NSString *const kYFBYMoneyCellIdentifier = @"yfb_ymoney_cell_identifier_kye";

@interface YFBMyYMoneyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@end

@implementation YFBMyYMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#ffffff");
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = kColor(@"#efeff4");
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[YFBMyYMoneyCell class] forCellReuseIdentifier:kYFBYMoneyCellIdentifier];
    [_layoutTableView registerClass:[YFBMyYMoneyPayCell class] forCellReuseIdentifier:kYFBMyMoneyPayCellIdentifier];
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
    }
    //    else if (section == YFBYMoneySectionTypePrivilege){
    //        return 1;
    //    }else if (section == YFBYMoneySectionTypeUser){
    //        return 1;
    //    }
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
    }
    return 0;
}


@end
