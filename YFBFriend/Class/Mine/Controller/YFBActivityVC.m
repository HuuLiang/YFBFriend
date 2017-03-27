//
//  YFBActivityVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBActivityVC.h"

@interface YFBActivityVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@end

@implementation YFBActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configTitleLabel];
    [self configDescLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"活动详情介绍";
    _titleLabel.font = kFont(17);
    _titleLabel.textColor = kColor(@"#333333");
    [self.view addSubview:_titleLabel];
    
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(20));
            make.top.equalTo(self.view).offset(kWidth(30));
            make.height.mas_equalTo(kWidth(48));
        }];
    }
}

- (void)configDescLabel {
    self.descLabel = [[UILabel alloc] init];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = kColor(@"#666666");
    _descLabel.font = kFont(14);
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"1、购买Y币服务可获得100元话费，按10个月领取，每月10月\n2、充值30日后，可领取\n3、本活动最终解释权归本应用所有\n4、客户电话：0731-89746010     话费领取";
    [self.view addSubview:_descLabel];
    
    {
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(20));
            make.right.equalTo(self.view).offset(-kWidth(20));
            make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(70));
        }];
    }
}

@end
