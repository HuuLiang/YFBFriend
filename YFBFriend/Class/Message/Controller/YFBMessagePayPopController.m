//
//  YFBMessagePayPopController.m
//  YFBFriend
//
//  Created by ylz on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayPopController.h"
#import "YFBMessageTopUpView.h"

@interface YFBMessagePayPopController ()
@property (nonatomic,retain) YFBMessageTopUpView *popView;

@end

@implementation YFBMessagePayPopController

- (YFBMessageTopUpView *)popView {
    if (_popView) {
        return _popView;
    }
    _popView = [[YFBMessageTopUpView alloc] init];
    
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:self.popView];
    {
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
        make.height.mas_equalTo(kWidth(670));
        make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMessageTopUpPopViewWithCurrentVC:(UIViewController *)currentVC {
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
    
}


- (void)hide {
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end
