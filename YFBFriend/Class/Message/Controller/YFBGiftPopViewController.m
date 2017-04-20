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
@property (nonatomic,retain) YFBGiftPopView *messagePopView;
@property (nonatomic) BOOL isMessagePop;

@end

@implementation YFBGiftPopViewController

- (YFBGiftPopView *)messagePopView {
    if (_messagePopView) {
        return _messagePopView;
    }
    _messagePopView = [[YFBGiftPopView alloc] initWithGiftModels:nil edg:0 footerHeight:kWidth(88) backColor:kColor(@"#000000") isMessagePop:YES];
    
    
    return _messagePopView;
}


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
    
    if (self.isMessagePop) {
        [self.view addSubview:self.messagePopView];
        {
            [self.messagePopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(kWidth(464));
            }];
        }
    }else{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self.view addSubview:self.popView];
        {
            [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).mas_offset(kWidth(40));
                make.right.mas_equalTo(self.view).mas_offset(kWidth(-16));
                make.centerY.mas_equalTo(self.view).mas_offset(kWidth(-20));
                make.height.mas_equalTo(kWidth(780));
            }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isMessagePop) {
        [self hide];
    }
}

+ (void)showGiftViewInCurrentViewController:(UIViewController *)currentViewController isMessagePop:(BOOL)isMessagePop {
    YFBGiftPopViewController *giftPopVC = [[YFBGiftPopViewController alloc] init];
    [giftPopVC showGiftPopViewWithCurrentVC:currentViewController isMessagePop:isMessagePop];
}

- (void)showGiftPopViewWithCurrentVC:(UIViewController *)currentVC isMessagePop:(BOOL)isMessagePop{
    self.isMessagePop = isMessagePop;
    
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
