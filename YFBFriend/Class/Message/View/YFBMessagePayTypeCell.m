//
//  YFBMessagePayTypeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayTypeCell.h"
#import "YFBPayButton.h"

@interface YFBMessagePayTypeCell ()
@property (nonatomic,strong) YFBPayButton *wxPayButton;
@property (nonatomic,strong) YFBPayButton *aliPayButton;
@end


@implementation YFBMessagePayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.wxPayButton = [[YFBPayButton alloc] init];
        _wxPayButton.title = @"微信支付";
        _wxPayButton.selected = YES;
        @weakify(self);
        [_wxPayButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self.wxPayButton.selected) {
                self.wxPayButton.selected = !self.wxPayButton.selected;
                self.aliPayButton.selected = !self.aliPayButton.selected;
                if (self.payTypeAction) {
                    self.payTypeAction(@(YFBPayTypeWeiXin));
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_wxPayButton];
        
        self.aliPayButton = [[YFBPayButton alloc] init];
        _aliPayButton.title = @"支付宝";
        _aliPayButton.selected = NO;
        [_aliPayButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (!self.aliPayButton.selected) {
                self.wxPayButton.selected = !self.wxPayButton.selected;
                self.aliPayButton.selected = !self.aliPayButton.selected;
                if (self.payTypeAction) {
                    self.payTypeAction(@(YFBPayTypeAliPay));
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_aliPayButton];
        
        {
            [_wxPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.bottom.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(248), kWidth(80)));
            }];
            
            
            [_aliPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(kWidth(-40));
                make.bottom.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(248), kWidth(80)));
            }];
        }
        
        
    }
    return self;
}

@end
