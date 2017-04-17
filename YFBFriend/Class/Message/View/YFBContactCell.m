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
@end

@implementation YFBContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = kWidth(50);
        _userImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImageView];
        
        self.unreadLabel = [[UILabel alloc] init];
        _unreadLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _unreadLabel.backgroundColor = [UIColor colorWithHexString:@"#FD698C"];
        [_userImageView addSubview:_unreadLabel];
        
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
            
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageView.mas_right).offset(kWidth(20));
                make.bottom.equalTo(_userImageView.mas_bottom).offset(-kWidth(14));
                make.height.mas_equalTo(kWidth(26));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_right).offset(-kWidth(120));
                make.top.equalTo(_userImageView.mas_top);
                make.height.mas_equalTo(kWidth(24));
            }];
        }
    }
    return self;
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setRecentTime:(NSString *)recentTime {
    NSDate *date = [YFBUtil dateFromString:recentTime WithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = [YFBUtil compareCurrentTime:[date timeIntervalSince1970]];
}

- (void)setContent:(NSString *)content {
    _content = content;
}

- (void)setMsgType:(NSInteger)msgType {
    if (msgType == 1) {
        _messageLabel.text = _content;
    } else if (msgType == 2) {
        _messageLabel.text = @"[图片]";
    }
}

- (void)setUnreadMsg:(NSInteger)unreadMsg {
    
}

@end
