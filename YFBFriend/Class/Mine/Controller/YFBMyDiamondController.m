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

static NSString *const kYFBDiamondCellIdentifier = @"kyfb_diamond_cell_identifier";

@interface YFBMyDiamondController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    UITableViewCell *_headerCell;
    UILabel *_headerLabel;
}
@end

@implementation YFBMyDiamondController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.backgroundColor = kColor(@"#f7f7f7");
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_diamond_icon"]];
            [_headerCell addSubview:imageView];
            {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_headerCell);
                    make.centerX.mas_equalTo(_headerCell).mas_offset(-kScreenWidth *0.135);
                    make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(40)));
                }];
            }
            _headerLabel = [[UILabel alloc] init];
            _headerLabel.textColor = kColor(@"#999999");
            _headerLabel.font = kFont(14);
            [_headerCell addSubview:_headerLabel];
            {
                [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).mas_offset(kWidth(5));
                    make.centerY.mas_equalTo(imageView);
                    make.right.mas_equalTo(_headerCell).mas_offset(kWidth(-30));
                    make.height.mas_equalTo(kWidth(32));
                }];
            }
        }
        _headerLabel.text = @"可用钻石:  100";
        return _headerCell;
    }
    YFBDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDiamondCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.price = @10;
        cell.title = @100;
    }else if (indexPath.row == 2){
        cell.price = @60;
        cell.title = @600;
    }else if (indexPath.row == 3){
        cell.price = @100;
        cell.title = @1000;
    }else if (indexPath.row == 4){
        cell.price = @300;
        cell.title = @3000;
    }else if (indexPath.row == 5){
        cell.price = @500;
        cell.title = @5000;
    }else if (indexPath.row == 6){
        cell.price = @1000;
        cell.title = @10000;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kWidth(100);
    }
    return kWidth(140);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row > 0 && indexPath.row < 7) {
        YFBDiamondCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        YFBDiamondVoucherController *voucherVC = [[YFBDiamondVoucherController alloc] initWithPrce:cell.price.floatValue diamond:cell.title.integerValue];
        [self.navigationController pushViewController:voucherVC animated:YES];
    }
}


@end
