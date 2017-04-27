//
//  YFBMyDiamondController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyDiamondController.h"
#import "YFBDiamondCell.h"
#import "YFBDiamondExplainController.h"
#import "YFBDiamondVoucherController.h"
#import "YFBDiamondManager.h"

static NSString *const kYFBDiamondCellIdentifier = @"kyfb_diamond_cell_identifier";

@interface YFBMyDiamondController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    UILabel *_headerLabel;
}
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation YFBMyDiamondController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钻石";
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorInset:UIEdgeInsetsZero];
    [_layoutTableView registerClass:[YFBDiamondCell class] forCellReuseIdentifier:kYFBDiamondCellIdentifier];
    _layoutTableView.tableHeaderView = [self configTableHeaderView];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"说明" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        YFBDiamondExplainController *explainVC = [[YFBDiamondExplainController alloc] init];
        [self.navigationController pushViewController:explainVC animated:YES];
    }];
    
    [self.dataSource addObjectsFromArray:[YFBDiamondManager manager].diamonList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _headerLabel.text = [NSString stringWithFormat:@"可用钻石：%ld",[YFBUser currentUser].diamondCount];
}

- (UIView *)configTableHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView = [[UITableViewCell alloc] init];
    headerView.backgroundColor = kColor(@"#f7f7f7");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_diamond_icon"]];
    [headerView addSubview:imageView];
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headerView);
            make.centerX.mas_equalTo(headerView).mas_offset(-kScreenWidth *0.135);
            make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(40)));
        }];
    }
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.textColor = kColor(@"#999999");
    _headerLabel.font = kFont(14);
    [headerView addSubview:_headerLabel];
    {
        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(kWidth(5));
            make.centerY.mas_equalTo(imageView);
            make.right.mas_equalTo(headerView).mas_offset(kWidth(-30));
            make.height.mas_equalTo(kWidth(32));
        }];
    }
    headerView.size = CGSizeMake(kScreenWidth, kWidth(100));
    
    return headerView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDiamondCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBDiamondInfo *diamondInfo = self.dataSource[indexPath.row];
        cell.title = @(diamondInfo.diamondAmount);
        cell.price = @(diamondInfo.price/100);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(140);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        YFBDiamondInfo *diamondInfo = self.dataSource[indexPath.row];
        YFBDiamondVoucherController *voucherVC = [[YFBDiamondVoucherController alloc] initWithPrice:diamondInfo.price diamond:diamondInfo.diamondAmount];
        [self.navigationController pushViewController:voucherVC animated:YES];
    }
}


@end
