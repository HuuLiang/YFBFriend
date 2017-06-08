//
//  YFBSocialCell.m
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSocialCell.h"
#import "YFBStarView.h"
#import "YFBCommentCell.h"
#import "YFBSocialModel.h"

@interface YFBSocialCell ()
@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *serverCountLabel;
@property (nonatomic) YFBStarView *starView;
@property (nonatomic) UIImageView *hotImgV;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIButton *allDescButton;
@property (nonatomic) UIImageView *imgVA;
@property (nonatomic) UIImageView *imgVB;
@property (nonatomic) UIImageView *imgVC;
@property (nonatomic) UILabel *serverTitleLabel;
@property (nonatomic) UIButton *wxButton;
@property (nonatomic) UIButton *checkButton;
@property (nonatomic) YFBCommentCell *firstComment;
@property (nonatomic) YFBCommentCell *secondComment;
@property (nonatomic) UIButton *allCommentsButton;
@end

@implementation YFBSocialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.userImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _userImgV.layer.cornerRadius = kWidth(40);
        _userImgV.layer.masksToBounds = YES;
        _userImgV.userInteractionEnabled = YES;
        [self.contentView addSubview:_userImgV];
        @weakify(self);
        [_userImgV bk_whenTapped:^{
            @strongify(self);
            if (self.detailAction) {
                self.detailAction();
            }
        }];

        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = kColor(@"#8458D0");
        _nickLabel.font = kFont(14);
        [self.contentView addSubview:_nickLabel];
        
        
        self.serverCountLabel = [[UILabel alloc] init];
        _serverCountLabel.textColor = kColor(@"#EEB336");
        _serverCountLabel.font = kFont(11);
        [self.contentView addSubview:_serverCountLabel];
        
        
        self.starView = [[YFBStarView alloc] init];
        [self.contentView addSubview:_starView];
        
        
        self.hotImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"social_hot"]];
        [self.contentView addSubview:_hotImgV];
        
        
        self.descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = kColor(@"#333333");
        _descLabel.font = kFont(14);
        [self.contentView addSubview:_descLabel];
        
        
        self.allDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allDescButton setTitle:@"查看全文" forState:UIControlStateNormal];
        [_allDescButton setTitleColor:kColor(@"#8458D0") forState:UIControlStateNormal];
        [_allDescButton setImage:[UIImage imageNamed:@"check_desc"] forState:UIControlStateNormal];
        _allDescButton.titleLabel.font = kFont(14);
        [self.contentView addSubview:_allDescButton];
        
        [_allDescButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.descAction) {
                self.descAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        self.imgVA = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVA];
        
        
        self.imgVB = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVB];
        
        
        self.imgVC = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVC];
        
        
        self.serverTitleLabel = [[UILabel alloc] init];
        _serverTitleLabel.textColor = kColor(@"#333333");
        _serverTitleLabel.font = kFont(14);
        _serverTitleLabel.text = @"最新服务评价";
        [self.contentView addSubview:_serverTitleLabel];
        
        
        self.wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxButton setTitle:@"我的微信" forState:UIControlStateNormal];
        [_wxButton setTitleColor:kColor(@"#8458D0") forState:UIControlStateNormal];
        _wxButton.titleLabel.font = kFont(12);
        _wxButton.layer.cornerRadius = 3;
        _wxButton.layer.borderColor = kColor(@"#E5E5E5").CGColor;
        _wxButton.layer.borderWidth = 1;
        [self.contentView addSubview:_wxButton];
        
        [_wxButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.wxAction) {
                self.wxAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setTitle:@"查看" forState:UIControlStateNormal];
        [_checkButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _checkButton.titleLabel.font = kFont(12);
        [_checkButton setBackgroundColor:kColor(@"#8458D0")];
        _checkButton.layer.cornerRadius = 3;
        [self.contentView addSubview:_checkButton];
        
        [_checkButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        self.firstComment = [[YFBCommentCell alloc] init];
        [self.contentView addSubview:_firstComment];
        
        
        self.secondComment = [[YFBCommentCell alloc] init];
        [self.contentView addSubview:_secondComment];
        
        
        self.allCommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allCommentsButton setTitle:@"查看全文" forState:UIControlStateNormal];
        [_allCommentsButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        [_allCommentsButton setImage:[UIImage imageNamed:@"check_comment"] forState:UIControlStateNormal];
        _allCommentsButton.titleLabel.font = kFont(12);
        [self.contentView addSubview:_allCommentsButton];
        
        [_allCommentsButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.commentAction) {
                self.commentAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(self.contentView).offset(kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(80)));
            }];
            
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV);
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_serverCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickLabel);
                make.left.equalTo(_nickLabel.mas_right).offset(kWidth(24));
                make.height.mas_equalTo(_serverCountLabel.font.lineHeight);
            }];
            
            [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_serverCountLabel);
                make.left.equalTo(_serverCountLabel.mas_right).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(136), kWidth(20)));
            }];
            
            [_hotImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_starView);
                make.left.equalTo(_starView.mas_right).offset(kWidth(28));
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(36)));
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(20));
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(10));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(60));
                make.height.mas_equalTo(_descLabel.font.lineHeight * 3);
            }];
            
            [_allDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_descLabel);
                make.top.equalTo(_descLabel.mas_bottom).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(82), kWidth(28)));
            }];
            
            CGFloat imgVWidth = (kScreenWidth - kWidth(210))/3;
            
            [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(130));
                make.top.equalTo(_descLabel.mas_bottom).offset(kWidth(64));
                make.size.mas_equalTo(CGSizeMake(imgVWidth, imgVWidth));
            }];
            
            [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_imgVA);
                make.left.equalTo(_imgVA.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(imgVWidth, imgVWidth));
            }];
            
            [_imgVC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_imgVB);
                make.left.equalTo(_imgVB.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(imgVWidth, imgVWidth));
            }];
            
            [_serverTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickLabel);
                make.top.equalTo(_imgVA.mas_bottom).offset(kWidth(56));
                make.height.mas_equalTo(_serverTitleLabel.font.lineHeight);
            }];
            
            [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_serverTitleLabel);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(60));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(48)));
            }];
            
            [_wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_checkButton);
                make.right.equalTo(_checkButton.mas_left).offset(-kWidth(16));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(48)));
            }];
            
            [_firstComment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickLabel);
                make.top.equalTo(_serverTitleLabel.mas_bottom).offset(kWidth(24));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.height.mas_equalTo(kWidth(100));
            }];
            
            [_secondComment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickLabel);
                make.top.equalTo(_firstComment.mas_bottom).offset(1);
                make.right.equalTo(_firstComment);
                make.height.mas_equalTo(kWidth(100));
            }];
            
            [_allCommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(_secondComment.mas_bottom).offset(kWidth(18));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(34)));
            }];
        }
    }
    return self;
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrl] placeholderImage:[UIImage imageNamed:@"login_userImage"]];
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = nickName;
}

- (void)setServerCount:(NSInteger)serverCount {
    _serverCountLabel.text = [NSString stringWithFormat:@"[已服务%ld人]",serverCount];
}

- (void)setDescStr:(NSString *)descStr {
    _descLabel.text = descStr;
    CGFloat height = [descStr sizeWithFont:kFont(14) maxWidth:kWidth(560)].height;
    [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)setImgUrlA:(NSString *)imgUrlA {
    [_imgVA sd_setImageWithURL:[NSURL URLWithString:imgUrlA]];
}

- (void)setImgUrlB:(NSString *)imgUrlB {
    [_imgVB sd_setImageWithURL:[NSURL URLWithString:imgUrlB]];

}

- (void)setImgUrlC:(NSString *)imgUrlC {
    [_imgVC sd_setImageWithURL:[NSURL URLWithString:imgUrlC]];
}

- (void)setServerRate:(NSInteger)serverRate {
    _starView.rate = serverRate;
    _hotImgV.hidden = serverRate != 5;

}

- (void)setFirstCommentModel:(YFBCommentModel *)firstCommentModel {
    _firstComment.nickName = firstCommentModel.nickName;
    _firstComment.timeStr = firstCommentModel.time;
    _firstComment.serverOption = firstCommentModel.serv;
    _firstComment.commentStr = firstCommentModel.content;
    
    CGFloat commentContentHeight = [firstCommentModel.content sizeWithFont:kFont(12) maxWidth:kWidth(560)].height;
    CGFloat commentHeight = kWidth(24) + kWidth(34) + kWidth(4) + kWidth(22) + kWidth(20) + commentContentHeight + kWidth(20);
    
}

- (void)setSecondCommentModel:(YFBCommentModel *)secondCommentModel {
    _secondComment.nickName = secondCommentModel.nickName;
    _secondComment.timeStr = secondCommentModel.time;
    _secondComment.serverOption = secondCommentModel.serv;
    _secondComment.commentStr = secondCommentModel.content;
    
    CGFloat commentContentHeight = [secondCommentModel.content sizeWithFont:kFont(12) maxWidth:kWidth(560)].height;
    CGFloat commentHeight = kWidth(24) + kWidth(34) + kWidth(4) + kWidth(22) + kWidth(20) + commentContentHeight + kWidth(20);
    
}

- (void)setNeedShowButton:(BOOL)needShowButton {
    if (needShowButton) {
        [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFont(14).lineHeight *3);
        }];
    }
    
    _allDescButton.hidden = !needShowButton;
    [_imgVA mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLabel.mas_bottom).offset(needShowButton ? kWidth(64) : kWidth(26));
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CAShapeLayer *lineA = [CAShapeLayer layer];
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [lineA setFillColor:[[UIColor clearColor] CGColor]];
    [lineA setStrokeColor:[[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:1.0f] CGColor]];
    lineA.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathA, NULL, _imgVA.frame.origin.x , _imgVA.frame.origin.y+_imgVA.size.height+kWidth(20));
    CGPathAddLineToPoint(linePathA, NULL, _imgVC.origin.x+_imgVC.size.width , _imgVC.origin.y+_imgVC.size.height+kWidth(20));
    [lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.layer addSublayer:lineA];
    
    CAShapeLayer *lineB = [CAShapeLayer layer];
    CGMutablePathRef linePathB = CGPathCreateMutable();
    [lineB setFillColor:[[UIColor clearColor] CGColor]];
    [lineB setStrokeColor:[[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:1.0f] CGColor]];
    lineB.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathB, NULL, _firstComment.frame.origin.x , _firstComment.frame.origin.y+_firstComment.size.height+kWidth(20));
    CGPathAddLineToPoint(linePathB, NULL, _firstComment.origin.x+_firstComment.size.width , _firstComment.origin.y+_firstComment.size.height+kWidth(20));
    [lineB setPath:linePathB];
    CGPathRelease(linePathB);
    [self.layer addSublayer:lineB];
    
    CAShapeLayer *lineC = [CAShapeLayer layer];
    CGMutablePathRef linePathC = CGPathCreateMutable();
    [lineC setFillColor:[[UIColor clearColor] CGColor]];
    [lineC setStrokeColor:[[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:1.0f] CGColor]];
    lineC.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathC, NULL, _secondComment.frame.origin.x , _secondComment.frame.origin.y+_secondComment.size.height+kWidth(20));
    CGPathAddLineToPoint(linePathC, NULL, _secondComment.origin.x+_secondComment.size.width , _secondComment.origin.y+_secondComment.size.height+kWidth(20));
    [lineC setPath:linePathC];
    CGPathRelease(linePathC);
    [self.layer addSublayer:lineC];
}

@end
