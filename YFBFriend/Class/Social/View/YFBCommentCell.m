//
//  YFBCommentCell.m
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBCommentCell.h"

@interface YFBCommentCell ()
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *serverLabel;
@property (nonatomic) UILabel *commentLabel;
@end

@implementation YFBCommentCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self configCommentUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self configCommentUI];
    }
    return self;
}

- (void)configCommentUI {
    self.nickLabel = [[UILabel alloc] init];
    _nickLabel.textColor = kColor(@"#999999");
    _nickLabel.font = kFont(14);
    [self.contentView addSubview:_nickLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = kColor(@"#B3B3B3");
    _timeLabel.font = kFont(12);
    [self.contentView addSubview:_timeLabel];
    
    self.serverLabel = [[UILabel alloc] init];
    _serverLabel.textColor = kColor(@"#B3B3B3");
    _serverLabel.font = kFont(12);
    [self.contentView addSubview:_serverLabel];
    
    self.commentLabel = [[UILabel alloc] init];
    _commentLabel.textColor = kColor(@"#333333");
    _commentLabel.font = kFont(14);
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    {
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kWidth(30));
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.height.mas_equalTo(kWidth(28));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nickLabel);
            make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
            make.height.mas_equalTo(kWidth(24));
        }];
        
        [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_nickLabel.mas_bottom).offset(kWidth(10));
            make.height.mas_equalTo(kWidth(22));
        }];
        
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_serverLabel.mas_bottom).offset(kWidth(26));
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
        }];
    }
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = [nickName stringByReplacingCharactersInRange:NSMakeRange(1, nickName.length-1) withString:@"***"];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setServerOption:(NSString *)serverOption {
    _serverLabel.text = [NSString stringWithFormat:@"服务选项:%@",serverOption];
}

- (void)setCommentStr:(NSString *)commentStr {
    _commentLabel.text = commentStr;
}

@end
