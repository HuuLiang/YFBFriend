//
//  YFBContactCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactCell.h"

@interface YFBContactCell ()
@property (nonatomic) UIImageView *userImageView;
@property (nonatomic) UILabel *nickNameLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *unreadLabel;
@property (nonatomic) UIImageView *onlineImgV;
@end

@implementation YFBContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = kWidth(50);
        _userImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImageView];
        
        self.unreadLabel = [[UILabel alloc] init];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = kColor(@"#ffffff");
        _unreadLabel.font = kFont(14);
        _unreadLabel.layer.cornerRadius = kWidth(18);
        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_unreadLabel];
        
        self.onlineImgV = [[UIImageView alloc] init];
        _onlineImgV.backgroundColor = kColor(@"#2DD329");
        _onlineImgV.layer.cornerRadius = 2;
        [self.contentView addSubview:_onlineImgV];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_nickNameLabel];
        
        self.messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _messageLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self.contentView addSubview:_messageLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [self.contentView addSubview:_timeLabel];
        

        
        {
            [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageView.mas_right).offset(kWidth(20));
                make.top.equalTo(_userImageView.mas_top);
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_right).offset(-kWidth(120));
                make.top.equalTo(_userImageView.mas_top);
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageView.mas_right).offset(kWidth(20));
                make.bottom.equalTo(_userImageView.mas_bottom).offset(-kWidth(14));
                make.height.mas_equalTo(kWidth(26));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(60));
            }];
            
            [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_userImageView.mas_right).offset(-kWidth(10));
                make.centerY.equalTo(_userImageView.mas_top).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(36));
                make.width.mas_equalTo(20);
            }];

            [_onlineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_unreadLabel);
                make.bottom.equalTo(_userImageView.mas_bottom).offset(-kWidth(4));
                make.size.mas_equalTo(CGSizeMake(kWidth(20), kWidth(20)));
            }];
        }
    }
    return self;
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    _nickNameLabel.text = nickName;
}

- (void)setRecentTime:(NSInteger)recentTime {
    if (recentTime == 0) {
        _timeLabel.text = @"";
        return;
    }
    _timeLabel.text = [YFBUtil compareCurrentTime:recentTime];
}

- (void)setContent:(NSString *)content {
    _content = content;
}

- (void)setMsgType:(NSInteger)msgType {
    if (msgType == YFBMessageTypeText || msgType == YFBMessageTypeFaceTime) {
        _messageLabel.text = _content;
    } else if (msgType == YFBMessageTypePhoto) {
        _messageLabel.text = [NSString stringWithFormat:@"%@向您发送了一张图片",_nickName];;
    } else if (msgType == YFBMessageTypeGift) {
        _messageLabel.text = [NSString stringWithFormat:@"%@向您发送了一份礼物",_nickName];;
    } else if (msgType == YFBMessageTypeVoice) {
        _messageLabel.text = [NSString stringWithFormat:@"%@向您发送了一段语音",_nickName];;
    } else if (msgType == YFBMessageTypeVideo) {
        _messageLabel.text = [NSString stringWithFormat:@"%@向您发送了一段视频",_nickName];;
    }
//    else if (msgType == YFBMessageTypeFaceTime) {
//        _messageLabel.text = [NSString stringWithFormat:@"%@向发送视频邀请",_nickName];;
//    }
}

- (void)setIsOneline:(BOOL)isOneline {
    _onlineImgV.hidden = !isOneline;
}

- (void)setUnreadMsg:(NSInteger)unreadMsg {
    if (unreadMsg > 0) {
        _unreadLabel.hidden = NO;
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)unreadMsg];
    } else {
        _unreadLabel.hidden = YES;
    }
}

@end
