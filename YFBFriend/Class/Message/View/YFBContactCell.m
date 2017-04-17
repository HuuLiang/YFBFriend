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
                make.top.equalTo(_userImageView.mas_bottom).offset(-kWidth(14));
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

@end
