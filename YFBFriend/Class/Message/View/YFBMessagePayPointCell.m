//
//  YFBMessagePayPointCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayPointCell.h"
#import "YFBPayButton.h"

@interface YFBMessagePayPointCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) YFBPayButton *payLessButton;
@property (nonatomic,strong) YFBPayButton *payMoreButton;
@property (nonatomic,strong) UIButton *payButton;
@end

@implementation YFBMessagePayPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.text = @"开通VIP后可无限制人数与MM聊天";
        [self.contentView addSubview:_titleLabel];
        
        self.payLessButton = [[YFBPayButton alloc] init];
        _payLessButton.selected = YES;
        @weakify(self);
        [_payLessButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self->_payLessButton.selected) {
                self->_payLessButton.selected = !self->_payLessButton.selected;
                self->_payMoreButton.selected = !self->_payMoreButton.selected;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payLessButton];
        
        self.payMoreButton = [[YFBPayButton alloc] init];
        _payMoreButton.selected = NO;
        [_payMoreButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self->_payMoreButton.selected) {
                self->_payLessButton.selected = !self->_payLessButton.selected;
                self->_payMoreButton.selected = !self->_payMoreButton.selected;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payMoreButton];
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFont(15);
        [_payButton setBackgroundColor:kColor(@"#8A64CC")];
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payButton];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(kWidth(40));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_payLessButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(330), kWidth(200)));
            }];
            
            [_payMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(20));
                make.centerY.equalTo(_payLessButton);
                make.size.mas_equalTo(CGSizeMake(kWidth(330), kWidth(200)));
            }];
            
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(24));
                make.size.mas_equalTo(CGSizeMake(kWidth(680), kWidth(88)));
            }];
        }
        
    }
    return self;
}

- (void)setLessTime:(NSString *)lessTime {
    _payLessButton.title = lessTime;
}

- (void)setLessPrice:(NSString *)lessPrice {
    _payLessButton.subTitle = lessPrice;
}

- (void)setLessTitle:(NSString *)lessTitle {
    _payLessButton.detailTitle = lessTitle;
}

- (void)setMoreTime:(NSString *)moreTime {
    _payMoreButton.title = moreTime;
}

- (void)setMorePrice:(NSString *)morePrice {
    _payMoreButton.subTitle = morePrice;
}

- (void)setMoreTitle:(NSString *)moreTitle {
    _payMoreButton.detailTitle = moreTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
