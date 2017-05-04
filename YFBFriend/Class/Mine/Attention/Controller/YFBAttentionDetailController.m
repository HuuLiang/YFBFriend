//
//  YFBAttentionDetailController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionDetailController.h"
#import "YFBAttentionTableViewCell.h"
#import "YFBAttentionListModel.h"

static NSString *const kAttentionOtherCellIdentifier = @"yfb_attention_other_identifier";
static NSString *const kAttentionMeCellIdentifier = @"yfb_attention_me_identifier";

@interface YFBAttentionDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    BOOL _isAttentionMe;
}
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) YFBAttentionListModel *attentionModel;
@end

@implementation YFBAttentionDetailController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBAttentionListModel, attentionModel)

- (instancetype)initWithIsAttentionMe:(BOOL)isAttentionMe
{
    self = [super init];
    if (self) {
        _isAttentionMe = isAttentionMe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorInset:UIEdgeInsetsZero];
    [_layoutTableView setSeparatorColor:kColor(@"#e6e6e6")];
    if (_isAttentionMe) {
        [_layoutTableView registerClass:[YFBAttentionTableViewCell class] forCellReuseIdentifier:kAttentionMeCellIdentifier];
    } else {
        [_layoutTableView registerClass:[YFBAttentionTableViewCell class] forCellReuseIdentifier:kAttentionOtherCellIdentifier];
    }
    [self.view addSubview:_layoutTableView];
    
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_layoutTableView YFB_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.attentionModel fetchAttentionListWithType:self->_isAttentionMe ? kYFBAttentionListConcernKeyName : kYFBAttentionListCOncernedKeyName
                                  CompletionHandler:^(BOOL success, NSArray <YFBAttentionInfo *>* userList)
    {
        @strongify(self);
        
        [self->_layoutTableView YFB_endPullToRefresh];
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:userList];
            [self->_layoutTableView reloadData];
        }
    }];
}

#pragma mark  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_isAttentionMe ? kAttentionMeCellIdentifier : kAttentionOtherCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBAttentionInfo *info = self.dataSource[indexPath.row];
        cell.name = info.nickName;
        cell.headerUrl = info.protraitUrl;
        cell.age = [NSString stringWithFormat:@"%ld岁",info.age];
        cell.photoCount = info.photoCount;
        if (_isAttentionMe) {
            @weakify(self);
            cell.attentionAction = ^(id obj) {
                @strongify(self);
                
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(140);
}

@end