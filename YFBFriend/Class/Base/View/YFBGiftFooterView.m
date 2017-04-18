//
//  YFBGiftReusableView.m
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftFooterView.h"

@interface YFBGiftFooterView ()
{
    UIPageControl *_pageControl;
    //    UIButton *_diamondBtn;
}

@property (nonatomic) UILabel *diamondLabel;

@end

@implementation YFBGiftFooterView

- (UILabel *)diamondLabel {
    if (_diamondLabel) {
        return _diamondLabel;
    }
    _diamondLabel = [[UILabel alloc] init];
    _diamondLabel.font = kFont(11);
    _diamondLabel.textColor = kColor(@"#ffffff");
    [self addSubview:_diamondLabel];
    {
        [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(16));
            make.centerY.mas_equalTo(self);
        }];
    }
    return _diamondLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        {
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.height.mas_equalTo(self);
                make.width.mas_equalTo(self).multipliedBy(0.5);
            }];
        }
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
    self.diamondLabel.text = [NSString stringWithFormat:@"钻石:  %zd",diamondCount];
}

@end
