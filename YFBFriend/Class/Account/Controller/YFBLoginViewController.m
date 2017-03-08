//
//  YFBLoginViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLoginViewController.h"
#import "YFBAccountManager.h"

@interface YFBLoginViewController ()

@property (nonatomic,strong) UIButton *QQButton;
@property (nonatomic,strong) UIButton *WXButton;

@end

@implementation YFBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTXLogin {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请选择您的登录方式：";
    label.textColor = kColor(@"#666666");
    label.font = [UIFont systemFontOfSize:kWidth(30)];
    [self.view addSubview:label];
    
    self.QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_QQButton setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    [_QQButton setTitle:@"QQ登录" forState:UIControlStateNormal];
    [_QQButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _QQButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    [self.view addSubview:_QQButton];
    
    self.WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_WXButton setImage:[UIImage imageNamed:@"login_wx"] forState:UIControlStateNormal];
    [_WXButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [_WXButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _WXButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    [self.view addSubview:_WXButton];

    @weakify(self);
    [_QQButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[YFBAccountManager manager] loginWithQQ];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_WXButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[YFBAccountManager manager] loginWithWX];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(76));
            make.top.equalTo(self.view).offset(kWidth(56));
            make.height.mas_equalTo(kWidth(30));
        }];
        
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
