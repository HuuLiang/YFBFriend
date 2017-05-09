//
//  YFBVipExampleCell.m
//  YFBFriend
//
//  Created by Liang on 2017/5/2.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVipExampleCell.h"

static NSString *const kYFBExampleCellReusableIdentifier = @"kYFBExampleCellReusableIdentifier";

@interface YFBVipExampleCell () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSInteger scrollIndex;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBVipExampleCell
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YFBScrollCell class] forCellReuseIdentifier:kYFBExampleCellReusableIdentifier];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.contentView addSubview:_tableView];
        
        {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
        
    }
    return self;
}

- (void)setUserList:(NSArray *)userList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:userList];
    [_tableView reloadData];
}

- (void)scrollTableView {
    QBLog(@"%ld",self.scrollIndex);
    if (self.scrollIndex >= self.dataSource.count - 3) {
        self.scrollIndex = 3;
    }
    [self->_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scrollIndex++ inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:self.scrollIndex != 4];
}

- (void)setScrollStart:(BOOL)scrollStart {
    if (scrollStart) {
        if (!_timer) {
            _timer =  [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scrollTableView) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        [_timer fire];
    } else {
        [_timer invalidate];
    }
}

- (void)dealloc {
    
}

#pragma mark -UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBExampleCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.title = self.dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(40);
}

@end



@interface YFBScrollCell ()
@property (nonatomic) UILabel *label;
@end

@implementation YFBScrollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label = [[UILabel alloc] init];
        _label.textColor = kColor(@"#999999");
        _label.font = kFont(13);
        [self.contentView addSubview:_label];
        
        {
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}
@end
