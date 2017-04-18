//
//  YFBGiftPopViewController.m
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopViewController.h"
#import "YFBBlagGiftView.h"
#import "YFBGiftPopView.h"

@interface YFBGiftPopViewController ()

//@property (nonatomic,retain) YFBGiftPopView *popView;
@property (nonatomic,retain) YFBBlagGiftView *popView;

@end

@implementation YFBGiftPopViewController

//- (YFBGiftPopView *)popView {
//    if (_popView) {
//        return _popView;
//    }
//    _popView = [[YFBGiftPopView alloc] initWithContenInset:UIEdgeInsetsMake(2, 2, 2, 2)];
////    _popView.
//    return _popView;
//}

- (YFBBlagGiftView *)popView {
    if (_popView) {
        return _popView;
    }
    _popView = [[YFBBlagGiftView alloc] init];
    _popView.sendTitle = @"乔乔";
    _popView.sendSubTitle = @"来个礼物呀";
    _popView.headerImageUrl = @"http://wx.qlogo.cn/mmopen/HJaMb8lIRuK64l3yOf6OO1FAkvMjXuaicMfmJXkthIsW6AQTrFoRaG0aibAcrshUmQJoDeLs9dcAQccF0aHqHSibQ/0";
    @weakify(self);
    _popView.closeAction = ^(id obj) {
        @strongify(self);
        [self hide];
    };
    _popView.giftAction = ^(id obj) {
//        @storngify(self);
        QBLog(@"打赏礼物")
    };
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [self.view addSubview:self.popView];
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).mas_offset(kWidth(40));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-16));
            make.centerY.mas_equalTo(self.view).mas_offset(kWidth(-20));
            make.height.mas_equalTo(kWidth(800));
        }];
    }
}

- (void)showGiftPopViewWithCurrentVC:(UIViewController *)currentVC {
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
