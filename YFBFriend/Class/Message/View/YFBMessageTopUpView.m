//
//  YFBMessageTopUpView.m
//  YFBFriend
//
//  Created by ylz on 2017/4/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageTopUpView.h"

typedef NS_ENUM(NSUInteger, YFBTopViewRow) {
    YFBTopViewRowPayPoint,
//    YFBTopViewRowPayTitle,
//    YFBTopViewRowPayType,
//    YFBTopViewRowGoToPay,
    YFBTopViewRowCount
};

@interface YFBMessageTopUpView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation YFBMessageTopUpView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_pay_pop_view"]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
        {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
    }
    return self;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return YFBTopViewRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (<#condition#>) {
//        <#statements#>
//    }
    return nil;
}

@end
