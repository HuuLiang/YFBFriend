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
//@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) YFBPayButton *payLessButton;
@property (nonatomic,strong) YFBPayButton *payMoreButton;
//@property (nonatomic,strong) UIButton *payButton;
@end

@implementation YFBMessagePayPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.payMoreButton = [[YFBPayButton alloc] init];
        _payMoreButton.selected = YES;
        @weakify(self);
        [_payMoreButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self->_payMoreButton.selected) {
                self->_payLessButton.selected = !self->_payLessButton.selected;
                self->_payMoreButton.selected = !self->_payMoreButton.selected;
                if (self.payAction) {
                    self.payAction(@(1));
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payMoreButton];
        
        self.payLessButton = [[YFBPayButton alloc] init];
        _payLessButton.selected = NO;
        [_payLessButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self->_payLessButton.selected) {
                self->_payLessButton.selected = !self->_payLessButton.selected;
                self->_payMoreButton.selected = !self->_payMoreButton.selected;
                if (self.payAction) {
                    self.payAction(@(2));
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payLessButton];
        
        
        {
            [_payMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.bottom.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(248), kWidth(160)));
            }];

            
            [_payLessButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(kWidth(-40));
                make.bottom.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(248), kWidth(160)));
            }];
        }
        
    }
    return self;
}


- (void)setMorePrice:(NSString *)morePrice {
    _payMoreButton.title = morePrice;
}

- (void)setMoreTitle:(NSString *)moreTitle {
    _payMoreButton.detailTitle = moreTitle;
}

- (void)setLessPrice:(NSString *)lessPrice {
    _payLessButton.title = lessPrice;
}

- (void)setLessTitle:(NSString *)lessTitle {
    _payLessButton.detailTitle = lessTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
