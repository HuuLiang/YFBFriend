//
//  YFBLoginViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLoginViewController.h"
#import "YFBAccountManager.h"
#import "YFBUserLoginVC.h"
#import "YFBRegisterFirstVC.h"
#import "YFBWebViewController.h"

@interface YFBLoginViewController ()
@property (nonatomic,strong) UIButton       *WXButton;
@property (nonatomic,strong) UIButton     *accountButton;
@property (nonatomic,strong) UIButton     *registerButton;
@end

@implementation YFBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    
    [self configAppIconTitleContent];
    [self configAccountLogin];
    [self configTXLogin];
    [self configDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)alwaysHideNavigationBar {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configAppIconTitleContent {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon"]];
    imgV.layer.cornerRadius = 7;
    imgV.layer.masksToBounds = YES;
    [self.view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"乐趣交友";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kColor(@"#666666");
    label.font = kFont(15);
    [self.view addSubview:label];
    
    {
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(102));
            make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(imgV.mas_bottom).offset(kWidth(20));
            make.height.mas_equalTo(label.font.lineHeight);
        }];
    }
}

- (void)configAccountLogin {
    self.accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountButton setTitle:@"登录" forState:UIControlStateNormal];
    [_accountButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _accountButton.titleLabel.font = kFont(15);
    _accountButton.layer.cornerRadius = 3.0f;
    _accountButton.backgroundColor = kColor(@"#8558D0");
    [self.view addSubview:_accountButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kColor(@"#8558D0") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = kFont(15);
    _registerButton.layer.cornerRadius = 3.0f;
    _registerButton.layer.borderWidth = 1.0f;
    _registerButton.layer.borderColor = kColor(@"#8458D0").CGColor;
    _registerButton.backgroundColor = kColor(@"#ffffff");
    [self.view addSubview:_registerButton];
    
    @weakify(self);
    [_accountButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YFBUserLoginVC *userLoginVC = [[YFBUserLoginVC alloc] initWithTitle:@"用户登录"];
        [self.navigationController pushViewController:userLoginVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_registerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [YFBUser currentUser].loginType = YFBLoginTypeDefine;
        YFBRegisterFirstVC *registerVC = [[YFBRegisterFirstVC alloc] initWithTitle:@"填写用户信息"];
        [self.navigationController pushViewController:registerVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(kWidth(392));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(630), kWidth(80)));
        }];
        
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_accountButton.mas_bottom).offset(kWidth(30));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(630), kWidth(80)));
        }];
    }
}


- (void)configTXLogin {
    self.WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_WXButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [_WXButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _WXButton.titleLabel.font = kFont(15);
    _WXButton.layer.borderWidth = 1.0f;
    _WXButton.layer.borderColor = kColor(@"#dcdcdc").CGColor;
    _WXButton.layer.cornerRadius = 3.0f;
    _WXButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_WXButton];
    
    @weakify(self);
    [_WXButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[YFBAccountManager manager] loginWithWXhandler:^(BOOL success) {
            @strongify(self);
            if (success) {
                [YFBUser currentUser].loginType = YFBLoginTypeWX;
                YFBRegisterFirstVC *registerVC = [[YFBRegisterFirstVC alloc] initWithTitle:@"填写用户信息"];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        }];;
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        
        [_WXButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_registerButton.mas_bottom).offset(kWidth(30));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(630), kWidth(80)));
        }];
    }
}


- (void)configDescription {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表你同意本APP隐私协议" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(22)],
                                                                                                                                NSForegroundColorAttributeName:kColor(@"#999999")}];
    NSRange range = [attriString.string rangeOfString:@"APP隐私协议"];
    [attriString addAttribute:NSForegroundColorAttributeName value:kColor(@"#EB6987") range:range];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setAttributedTitle:attriString forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    @weakify(self);
    [button bk_addEventHandler:^(id sender) {
        @strongify(self);
        //APP隐私协议
        YFBWebViewController *webVC = [[YFBWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YFB_BASE_URL,YFB_APPLICENSE_URL]] standbyURL:nil];
        [self.navigationController pushViewController:webVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(38));
            make.size.mas_equalTo(CGSizeMake(kWidth(360), kWidth(22)));
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


@end
