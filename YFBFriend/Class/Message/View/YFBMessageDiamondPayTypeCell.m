//
//  YFBMessageDiamondPayTypeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/25.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageDiamondPayTypeCell.h"

@interface YFBMessageDiamondPayTypeCell ()
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBMessageDiamondPayTypeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.borderWidth  = 1;
        self.contentView.layer.borderColor  = kColor(@"#C8C9CA").CGColor;
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = kFont(14);
        [self.contentView addSubview:_payButton];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setPayType:(YFBPayType)payType {
    if (payType == YFBPayTypeWeiXin) {
        [_payButton setImage:[UIImage imageNamed:@"mine_wechat_pay_icon"] forState:UIControlStateNormal];
        [_payButton setTitle:@"微信支付" forState:UIControlStateNormal];
    } else if (payType == YFBPayTypeAliPay) {
        [_payButton setImage:[UIImage imageNamed:@"mine_alipay_icon"] forState:UIControlStateNormal];
        [_payButton setTitle:@"支付宝" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = kColor(@"#FFFDE4");
        self.contentView.layer.borderColor  = kColor(@"#F64152").CGColor;
        [_payButton setTitleColor:kColor(@"#F63F50") forState:UIControlStateNormal];
        
    } else {
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.borderColor  = kColor(@"#C8C9CA").CGColor;
        [_payButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        
    }
}

@end
