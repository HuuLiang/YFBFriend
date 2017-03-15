//
//  YFBAttentionDetailController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionDetailController.h"
#import "YFBAttentionTableViewCell.h"

static NSString *const kAttentionOtherCellIdentifier = @"yfb_attention_other_identifier";
static NSString *const kAttentionMeCellIdentifier = @"yfb_attention_me_identifier";

@interface YFBAttentionDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    BOOL _isAttentionMe;
}

@end

@implementation YFBAttentionDetailController

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
    }else {
        
        [_layoutTableView registerClass:[YFBAttentionTableViewCell class] forCellReuseIdentifier:kAttentionOtherCellIdentifier];
    }
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

#pragma mark  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isAttentionMe) {
        YFBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAttentionMeCellIdentifier forIndexPath:indexPath];
        cell.name = @"钱稍稍";
        cell.headerUrl = @"http://cdn.duitang.com/uploads/item/201507/22/20150722145119_hJnyP.jpeg";
        cell.age = @"25";
        cell.photoCount = 17;
        cell.attentionAction = ^(id sender){
        
        };
        return cell;
    }else {
    
    YFBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAttentionOtherCellIdentifier forIndexPath:indexPath];
    cell.name = @"钱多多";
    cell.headerUrl = @"http://cdn.duitang.com/uploads/item/201507/22/20150722145119_hJnyP.jpeg";
    cell.age = @"23";
    cell.photoCount = 20;
    return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kWidth(140);
}

@end
