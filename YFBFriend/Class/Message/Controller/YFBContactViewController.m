//
//  YFBContactViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactViewController.h"
#import "YFBContactCell.h"

static NSString *const kYFBContactCellReusableIdentifier = @"kYFBContactCellReusableIdentifier";

@interface YFBContactViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_tableView registerClass:[YFBContactCell class] forCellReuseIdentifier:kYFBContactCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)configHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.size = CGSizeMake(kScreenWidth, kWidth(84));
    
    UIImageView *eyeImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_eye"]];
    [headerView addSubview:eyeImageV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"谁看过我";
    titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [headerView addSubview:titleLabel];
    
    
    
    return headerView;
}

- (void)loadData {
    
}

@end
