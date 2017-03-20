//
//  YFBPayUsersCell.m
//  YFBFriend
//
//  Created by ylz on 2017/3/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayUsersCell.h"
#import "YFBMTableViewDatasource.h"

static const NSInteger maxCell = 7;
static NSString *const KYFBPayUsersCellIdentifier = @"kyfb_pay_users_cell_identifier";

@interface YFBPayUsersCell ()
{
    NSTimer *_timer;
    UITableView *_tableView;
}

@property (nonatomic, strong) YFBMTableViewDatasource *dataSource;
@end

@implementation YFBPayUsersCell

- (YFBMTableViewDatasource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[YFBMTableViewDatasource alloc] init];
        _dataSource.isRow = NO;
    }
    return _dataSource;
}

- (void)tableViewConfig {
    @weakify(self);
    self.dataSource.tableViewCell = ^UITableViewCell *(id model) {
        @strongify(self);
        YFBChatTableViewCell *cell = [YFBChatTableViewCell createChatTableViewCellWithTableView:self->_tableView];
        YFBPayUserModel *chatModel = model;
       NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]%@",chatModel.name,chatModel.text]];
        if (chatModel.getCharge) {
            [attribute setAttributes:@{NSForegroundColorAttributeName : kColor(@"#8458d0")} range:NSMakeRange(attribute.length -9, 9)];
        }
        [cell setCellAttributTitle:attribute];
        return cell;
    };
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self.dataSource;
        _tableView.delegate = self.dataSource;
        self.dataSource.rowHeight = kWidth(36);
        _tableView.transform = CGAffineTransformMakeScale(1, -1);
        [self addSubview:_tableView];
        {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(self);
            }];
        }
        [self tableViewConfig];
        @weakify(self);
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
            @strongify(self);
            [self scrollTitle];
        } repeats:YES];
    }
    return self;
}

- (void)scrollTitle{
    static NSInteger index = 0;
//    @weakify(self);
    YFBPayUserModel *model = self.models[index];
    [self.dataSource.dataSourceArr insertObject:model atIndex:0];
    [self->_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    if (self.dataSource.dataSourceArr.count > maxCell) {
        [self.dataSource.dataSourceArr removeLastObject];
        [self->_tableView deleteSections:[NSIndexSet indexSetWithIndex:self.dataSource.dataSourceArr.count] withRowAnimation:UITableViewRowAnimationNone];
    }
    index ++;
    if (index == self.models.count - 1) {
        index = 0;
    }
    
}

@end
