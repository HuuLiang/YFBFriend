//
//  YFBBuyVipCell.m
//  YFBFriend
//
//  Created by Liang on 2017/6/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBuyVipCell.h"

@interface YFBBuyVipCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBBuyVipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#EB6894");
        _priceLabel.font = kFont(14);
        [self.contentView addSubview:_priceLabel];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFont(12);
        _descLabel.textColor = kColor(@"#EB6894");
        [self.contentView addSubview:_descLabel];
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFont(14);
        _payButton.layer.cornerRadius = 3;
        _payButton.backgroundColor = kColor(@"#EB6894");
        [self.contentView addSubview:_payButton];
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setVipType:(YFBBuyVipType)vipType {
    if (vipType == YFBBuyVipTypeGold) {
        _imgV.image = [UIImage imageNamed:@""];
        _titleLabel.text = @"";
        _priceLabel.text = [NSString stringWithFormat:@""];
        _descLabel.text = [NSString stringWithFormat:@""];
    } else if (vipType == YFBBuyVipTypeSliver) {
        _imgV.image = [UIImage imageNamed:@""];
        _titleLabel.text = @"";
        _priceLabel.text = [NSString stringWithFormat:@""];
        _descLabel.text = [NSString stringWithFormat:@""];
    }
}

@end
