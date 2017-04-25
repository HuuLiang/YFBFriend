//
//  YFBMessageToPayCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageToPayCell.h"

@interface YFBMessageToPayCell ()

@property (nonatomic) UIButton *payButton;

@end


@implementation YFBMessageToPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[kColor(@"#ffffff") colorWithAlphaComponent:0.87] forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFont(16);
        _payButton.backgroundColor = kColor(@"#EB6894");
        _payButton.layer.cornerRadius = 6;
        [self.contentView addSubview:_payButton];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
            }];
        }
    }
    return self;
}

@end
