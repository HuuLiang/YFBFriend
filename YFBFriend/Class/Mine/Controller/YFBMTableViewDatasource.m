//
//  YFBMTableViewDatasource.m
//  YFBFriend
//
//  Created by ylz on 2017/3/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMTableViewDatasource.h"
#import "YFBPayUserModel.h"

@interface YFBMTableViewDatasource ()

@property (nonatomic, strong) NSMutableDictionary *nickColorDic;

@end

@implementation YFBMTableViewDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRow = YES;
        self.dataSourceArr = [[NSMutableArray alloc] init];
        self.nickColorDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    if (self.isRow) {
        return 1;
    } else {
        return self.dataSourceArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isRow) {
        return self.dataSourceArr.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headView) {
        return self.headView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YFBPayUserModel *model = self.dataSourceArr[indexPath.section];
    UITableViewCell *cell = nil;
    if (self.tableViewCell) {
        UIColor *color = self.nickColorDic[model.name];
        if (!color) {
            NSArray *colors = @[kColor(@"#ff4646"),kColor(@"#008aff"),kColor(@"#00dcd4")];
            color = (UIColor *)colors[arc4random_uniform(3)];
            [self.nickColorDic setObject:color forKey:model.name];
        }
        cell = self.tableViewCell( model);
    } else {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.headView) {
        return self.headView.bounds.size.height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}



@end
