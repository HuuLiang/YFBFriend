//
//  YFBLaunchViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLaunchViewController.h"
#import "YFBTabBarController.h"

@interface YFBLaunchViewController ()
@property (nonatomic,strong) UIImageView    *backgroundImageView;
@property (nonatomic,strong) UIButton       *maleButton;
@property (nonatomic,strong) UIButton       *femaleButton;
@property (nonatomic,strong) UILabel        *titleLabel;
@end

@implementation YFBLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeBackground.jpg"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_backgroundImageView];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configMaleButton];
    [self configFemaleButton];
    [self configTitleLabel];
    
    if ([YFBUtil checkUserIsLogin]) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view beginLoading];
        //进入首页
        YFBTabBarController *tabbarController = [[YFBTabBarController alloc] init];
        [self presentViewController:tabbarController animated:YES completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushInToLoginViewControler {
    
}

- (void)configMaleButton {
    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maleButton setTitle:@"我是\n男生" forState:UIControlStateNormal];
    [_maleButton setTitleColor:kColor(@"") forState:UIControlStateNormal];
    _maleButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
    _maleButton.titleLabel.numberOfLines = 2;
    [self.view addSubview:_maleButton];
    {
        [_maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(163));
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(100));
            make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(82)));
        }];
    }
    
    @weakify(self);
    [_maleButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
        [self pushInToLoginViewControler];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)configFemaleButton {
    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_femaleButton setTitle:@"我是\n女生" forState:UIControlStateNormal];
    [_femaleButton setTitleColor:kColor(@"") forState:UIControlStateNormal];
    _femaleButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
    _femaleButton.titleLabel.numberOfLines = 2;
    [self.view addSubview:_femaleButton];
    {
        [_femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-kWidth(163));
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(100));
            make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(82)));
        }];
    }
    
    @weakify(self);
    [_femaleButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
        [self pushInToLoginViewControler];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)configTitleLabel {
    NSString *titleString = @"同城密爱-青年男女互动交流社区";
    NSRange rang = [titleString rangeOfString:@"同城密爱"];
    NSMutableAttributedString *mutableAttriString = [[NSMutableAttributedString alloc] initWithString:titleString
                                                                                           attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:kWidth(24)]}];
    [mutableAttriString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#8558CF"]} range:rang];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.attributedText = mutableAttriString;
    [self.view addSubview:_titleLabel];
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(28));
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
