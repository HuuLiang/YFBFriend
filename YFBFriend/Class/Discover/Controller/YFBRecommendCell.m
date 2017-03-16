//
//  YFBRecommendCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRecommendCell.h"

@interface YFBRecommendCell ()
@property (nonatomic,strong) UIImageView *userImgV;
@property (nonatomic,strong) UIImageView *tagImgV;
@property (nonatomic,strong) UILabel     *userName;
@property (nonatomic,strong) UIButton    *sexButton;
@property (nonatomic,strong) UILabel     *userHeightLabel;
@property (nonatomic,strong) UILabel     *localCity;
@property (nonatomic,strong) UIButton    *greetButton;
@property (nonatomic,strong) UILabel     *distanceLabel;
@end

@implementation YFBRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        self.contentView.backgroundColor = kColor(@"#ffffff");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgV];
        
        self.tagImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_hot"]];
        [_userImgV addSubview:_tagImgV];
        
        self.userName = [[UILabel alloc] init];
        _userName.textColor = kColor(@"#333333");
        _userName.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_userName];
        
        self.sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sexButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [_sexButton setBackgroundColor:kColor(@"#FFB7B5")];
        _sexButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [self.contentView addSubview:_sexButton];
        
        self.userHeightLabel = [[UILabel alloc] init];
        _userHeightLabel.textColor = kColor(@"#ffffff");
        _userHeightLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _userHeightLabel.backgroundColor = kColor(@"#ABDBF5");
        _userHeightLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_userHeightLabel];
        
        self.localCity = [[UILabel alloc] init];
        _localCity.textColor = kColor(@"#999999");
        _localCity.font = [UIFont systemFontOfSize:kWidth(24)];
        [self.contentView addSubview:_localCity];
        
        self.greetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greetButton setImage:[UIImage imageNamed:@"discover_greet"] forState:UIControlStateNormal];
        [_greetButton setImage:[UIImage imageNamed:@"discover_greeted"] forState:UIControlStateSelected];
        [_greetButton setTitle:@"打招呼" forState:UIControlStateNormal];
        [_greetButton setTitle:@"已打招呼" forState:UIControlStateSelected];
        [_greetButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        _greetButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [self.contentView addSubview:_greetButton];
        
        self.distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = kColor(@"#999999");
        _distanceLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_distanceLabel];
        _distanceLabel.hidden = YES;
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(14));
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(172), kWidth(172)));
            }];
            
            [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(32));
                make.top.equalTo(_userImgV.mas_top).offset(kWidth(24));
                make.height.mas_equalTo(30);
            }];
            
            [_sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(32));
                make.top.equalTo(_userName.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(84), kWidth(36)));
            }];
            
            [_userHeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_sexButton);
                make.left.equalTo(_sexButton.mas_right).offset(kWidth(12));
                make.size.mas_equalTo(CGSizeMake(kWidth(84), kWidth(36)));
            }];
            
            [_localCity mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(32));
                make.bottom.equalTo(_userImgV.mas_bottom).offset(-kWidth(18));
                make.height.mas_equalTo(24);
            }];
            
            [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(60));
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(94)));
            }];
            
            [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_greetButton);
                make.right.equalTo(_greetButton.mas_left).offset(-kWidth(10));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _userName.text = userNameStr;
}

- (void)setUserAge:(NSString *)userAge {
    [_sexButton setTitle:userAge forState:UIControlStateNormal];
}

- (void)setUserSex:(YFBUserSex)userSex {
    if (userSex == YFBUserSexFemale) {
        [_sexButton setImage:[UIImage imageNamed:@"discover_female"] forState:UIControlStateNormal];
    } else {
        [_sexButton setImage:[UIImage imageNamed:@"discover_male"] forState:UIControlStateNormal];
    }
}

- (void)setUserHeight:(NSString *)userHeight {
    _userHeightLabel.text = userHeight;
}

- (void)setGreeted:(BOOL)greeted {
    _greetButton.selected = greeted;
    _greetButton.enabled = !greeted;
}

- (void)setDistance:(NSString *)distance {
    _distanceLabel.hidden = NO;
    _distanceLabel.text = distance;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect greetButtonFrame = _greetButton.frame;
    CGFloat imageInsetsLeft = (greetButtonFrame.size.width - _greetButton.imageView.frame.size.width)/2;
    _greetButton.imageEdgeInsets = UIEdgeInsetsMake(-(greetButtonFrame.size.height-_greetButton.imageView.size.height)/2, imageInsetsLeft, (greetButtonFrame.size.height-_greetButton.imageView.size.height)/2, imageInsetsLeft);
    _greetButton.titleEdgeInsets = UIEdgeInsetsMake(_greetButton.imageView.size.height, -_greetButton.frame.size.width, 0, -(_greetButton.frame.size.width-_greetButton.imageView.frame.size.width));
}

@end
