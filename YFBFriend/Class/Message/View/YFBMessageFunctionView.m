//
//  YFBMessageFunctionView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageFunctionView.h"

@interface YFBMessageFunctionView ()
@property (nonatomic) UIButton *attentionButton;
@property (nonatomic) UIButton *yBiButton;
@property (nonatomic) UIButton *phoneButton;
@property (nonatomic) UIButton *wxButton;
@end

@implementation YFBMessageFunctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#E9CBBD"];
        
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionButton setTitle:@"关注TA" forState:UIControlStateNormal];
        [_attentionButton setTitleColor:[UIColor colorWithHexString:@"#8458D0"] forState:UIControlStateNormal];
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_attentionButton];
        
        self.yBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yBiButton setTitle:@"钻石:" forState:UIControlStateNormal];
        [_yBiButton setTitleColor:[UIColor colorWithHexString:@"#8458D0"] forState:UIControlStateNormal];
        _yBiButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_yBiButton];

        self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setTitle:@"查看手机" forState:UIControlStateNormal];
        [_phoneButton setTitleColor:[UIColor colorWithHexString:@"#8458D0"] forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_phoneButton];

        self.wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxButton setTitle:@"查看微信" forState:UIControlStateNormal];
        [_wxButton setTitleColor:[UIColor colorWithHexString:@"#8458D0"] forState:UIControlStateNormal];
        _wxButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_wxButton];
        
        [_attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.25);
        }];
        
        [_yBiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_attentionButton.mas_right);
            make.width.equalTo(self.mas_width).multipliedBy(0.25);
        }];
        
        [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_yBiButton.mas_right);
            make.width.equalTo(self.mas_width).multipliedBy(0.25);
        }];
        
        [_wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_phoneButton.mas_right);
            make.width.equalTo(self.mas_width).multipliedBy(0.25);
        }];
        
        @weakify(self);
        [_attentionButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.functionType) {
                self.functionType(YFBMessageFunciontTypeAttention);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_yBiButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.functionType) {
                self.functionType(YFBMessageFunciontTypeDiamon);
            }
        } forControlEvents:UIControlEventTouchUpInside];

        [_phoneButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.functionType) {
                self.functionType(YFBMessageFunciontTypePhone);
            }
        } forControlEvents:UIControlEventTouchUpInside];

        [_wxButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.functionType) {
                self.functionType(YFBMessageFunciontTypeWX);
            }            
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (int i = 1; i <= 3; i++) {
        CAShapeLayer *lineA = [CAShapeLayer layer];
        CGMutablePathRef linePathA = CGPathCreateMutable();
        [lineA setFillColor:[[UIColor clearColor] CGColor]];
        [lineA setStrokeColor:[[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:1.0f] CGColor]];
        lineA.lineWidth = 1.0f;
        CGPathMoveToPoint(linePathA, NULL, self.frame.size.width/4*i , kWidth(16));
        CGPathAddLineToPoint(linePathA, NULL, self.frame.size.width/4*i , kWidth(56));
        [lineA setPath:linePathA];
        CGPathRelease(linePathA);
        [self.layer addSublayer:lineA];
    }
}

@end
