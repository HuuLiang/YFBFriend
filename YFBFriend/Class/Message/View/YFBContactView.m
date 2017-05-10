//
//  YFBContactView.m
//  YFBFriend
//
//  Created by Liang on 2017/5/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactView.h"
#import "YFBAutoReplyManager.h"

@interface YFBContactView ()
@property (nonatomic) UIImageView *userImageV;
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UIButton *ageButton;
@property (nonatomic) UILabel *heightLabel;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UIButton *replyButton;
@end

@implementation YFBContactView

- (instancetype)initWithContactInfo:(YFBAutoReplyMessage *)contactModel replyHandler:(ReplyAction)handler{
    self = [super init];
    if (self) {
        self.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.89];
        
        self.userImageV = [[UIImageView alloc] init];
        [_userImageV sd_setImageWithURL:[NSURL URLWithString:contactModel.portraitUrl] placeholderImage:[UIImage imageNamed:@""]];
        _userImageV.layer.cornerRadius = kWidth(45);
        _userImageV.layer.masksToBounds = YES;
        [self addSubview:_userImageV];
        
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = contactModel.nickName;
        _nickLabel.font = kFont(14);
        _nickLabel.textColor = kColor(@"#ffffff");
        [self addSubview:_nickLabel];
        
        self.ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ageButton setTitle:[NSString stringWithFormat:@"%ld岁",contactModel.age] forState:UIControlStateNormal];
        [_ageButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [_ageButton setImage:[UIImage imageNamed:@"discover_female"] forState:UIControlStateNormal];
        _ageButton.titleLabel.font = kFont(11);
        _ageButton.backgroundColor = kColor(@"#4B8EE1");
        _ageButton.layer.cornerRadius = 2;
        _ageButton.layer.masksToBounds = YES;
        [self addSubview:_ageButton];
        
        self.heightLabel = [[UILabel alloc] init];
        _heightLabel.text = [NSString stringWithFormat:@"%ldcm",contactModel.height];
        _heightLabel.textColor = kColor(@"#ffffff");
        _heightLabel.font = kFont(11);
        _heightLabel.backgroundColor = kColor(@"#DDA13B");
        _heightLabel.textAlignment = NSTextAlignmentCenter;
        _heightLabel.layer.cornerRadius = 2;
        _heightLabel.layer.masksToBounds = YES;
        [self addSubview:_heightLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColor(@"#ffffff");
        _contentLabel.font = kFont(13);
        _contentLabel.numberOfLines = 0;
        if ([contactModel.msgType integerValue] == YFBMessageTypeText) {
            _contentLabel.text = contactModel.content;
        } else if ([contactModel.msgType integerValue] == YFBMessageTypePhoto) {
            _contentLabel.text = @"收到一条图片消息";
        }
        [self addSubview:_contentLabel];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setTitle:@"查看" forState:UIControlStateNormal];
        [_replyButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _replyButton.titleLabel.font = kFont(14);
        _replyButton.backgroundColor = kColor(@"#FF7474");
        _replyButton.layer.cornerRadius = 5;
        _replyButton.layer.masksToBounds = YES;
        [self addSubview:_replyButton];
        
        [_replyButton bk_addEventHandler:^(id sender) {
            QBSafelyCallBlock(handler,contactModel.userId,contactModel.nickName,contactModel.portraitUrl);
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        {
            [_userImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(34));
                make.left.equalTo(self).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(90), kWidth(90)));
            }];
            
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageV.mas_right).offset(kWidth(22));
                make.top.equalTo(_userImageV.mas_top).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickLabel);
                make.left.equalTo(_nickLabel.mas_right).offset(kWidth(14));
                make.size.mas_equalTo(CGSizeMake(kWidth(88), kWidth(30)));
            }];
            
            [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickLabel);
                make.left.equalTo(_ageButton.mas_right).offset(kWidth(14));
                make.size.mas_equalTo(CGSizeMake(kWidth(90), kWidth(30)));
            }];
            
            
            [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(50));
                make.right.equalTo(self.mas_right).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(60)));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageV.mas_right).offset(kWidth(22));
                make.top.equalTo(_ageButton.mas_bottom).offset(kWidth(16));
                make.right.equalTo(_replyButton.mas_left).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(60));
            }];

        }
    }
    return self;
}

@end
