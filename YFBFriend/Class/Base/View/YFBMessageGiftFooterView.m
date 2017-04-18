//
//  YFBMessageGiftFooterView.m
//  YFBFriend
//
//  Created by ylz on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageGiftFooterView.h"

@interface YFBMessageGiftFooterView ()

{
    UIPageControl *_pageControl;
    UIButton *_topUpBtn;//充值
    UIButton *_diamondBtn;
}

@end

@implementation YFBMessageGiftFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setImage:[UIImage imageNamed:@"message_gift_diamond_icon"] forState:UIControlStateNormal];
        _diamondBtn.titleLabel.font = kFont(14);
        [self addSubview:_diamondBtn];
        {
            [_diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self).mas_offset(kWidth(-8));
                make.left.mas_equalTo(self).mas_offset(kWidth(16));
            }];
        }
        _topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topUpBtn.titleLabel.font = kFont(12);
        [_topUpBtn setTitleColor:kColor(@"#fd4ca1") forState:UIControlStateNormal];
        [_topUpBtn setTitle:@"充值 >" forState:UIControlStateNormal];
        [self addSubview:_topUpBtn];
        {
            [_topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_diamondBtn);
                make.left.mas_equalTo(_diamondBtn.mas_right).mas_offset(kWidth(8));
                //            make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(24)));
                //            make.left.mas_lessThanOrEqualTo(_diamondBtn.mas_right).mas_offset(kWidth(8));
            }];
        }
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.layer.cornerRadius = kWidth(3);
        sendBtn.clipsToBounds = YES;
        sendBtn.titleLabel.font = kFont(13);
        [sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        sendBtn.backgroundColor = kColor(@"#ffffff");
        [sendBtn setTitleColor:kColor(@"#FD4CA1") forState:UIControlStateNormal];
        [self addSubview:sendBtn];
        {
            [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).mas_offset(kWidth(-20));
                make.bottom.mas_equalTo(_diamondBtn);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(52)));
                
            }];
        }
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        {
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.height.mas_equalTo(self);
                make.width.mas_equalTo(self).multipliedBy(0.45);
                //                make.left.mas_equalTo(_topUpBtn.mas_right);
                //                make.right.mas_equalTo(sendBtn.mas_left);
                
            }];
        }
        
        @weakify(self);
        [sendBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.sendAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_diamondBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.topUpAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        [_topUpBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.topUpAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
}

- (void)setPageNumbers:(NSInteger)pageNumbers {
    _pageNumbers = pageNumbers;
    _pageControl.numberOfPages = pageNumbers;
}

- (void)setDiamondCount:(NSInteger)diamondCount{
    _diamondCount = diamondCount;
    [_diamondBtn setTitle: [NSString stringWithFormat:@"%zd",diamondCount] forState:UIControlStateNormal];
}


@end
