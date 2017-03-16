//
//  YFBMyYMoneyPayCell.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyYMoneyPayCell.h"
#import "YFBPayButton.h"

@interface YFBMyYMoneyPayCell ()
{
    YFBPayButton *_lessBtn;
    YFBPayButton *_moreBtn;
}

@end

@implementation YFBMyYMoneyPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFont(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kColor(@"#999999");
        titleLabel.text = @"充值Y币可与MM无限制聊天";
        [self addSubview:titleLabel];
        {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self).mas_offset(kWidth(40));
            make.height.mas_equalTo(kWidth(30));
        }];
        }
        _lessBtn = [[YFBPayButton alloc] init];
        _lessBtn.selected = YES;
        
        [_lessBtn bk_addEventHandler:^(UIButton* sender) {
            sender.selected = YES;
            _moreBtn.selected = NO;
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_lessBtn];
        {
        [_lessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(20));
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(330), kWidth(200)));
        }];
        }
        _moreBtn = [[YFBPayButton alloc] init];
        [_moreBtn bk_addEventHandler:^(UIButton *sender) {
            sender.selected = YES;
            _lessBtn.selected = NO;
            
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        {
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(kWidth(-20));
            make.size.top.mas_equalTo(_lessBtn);
        }];
        }
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setBackgroundColor:kColor(@"#8a64cc")];
        [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        payBtn.titleLabel.font = kFont(15);
        [self addSubview:payBtn];
        {
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(36));
            make.right.mas_equalTo(self).mas_offset(kWidth(-36));
            make.bottom.mas_equalTo(self).mas_offset(kWidth(-24));
            make.height.mas_equalTo(kWidth(88));
        }];
        }
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    _lessBtn.title = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _lessBtn.subTitle = subTitle;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    _lessBtn.detailTitle = detailTitle;
}

- (void)setMoreTitle:(NSString *)moreTitle {
    _moreTitle = moreTitle;
    _moreBtn.title = moreTitle;
}

- (void)setMoreSubTitle:(NSString *)moreSubTitle {
    _moreSubTitle = moreSubTitle;
    _moreBtn.subTitle = moreSubTitle;
}

- (void)setMoreDetailTitle:(NSString *)moreDetailTitle {
    _moreDetailTitle = moreDetailTitle;
    _moreBtn.detailTitle = moreDetailTitle;
}

@end
