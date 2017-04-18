//
//  YFBBlagGiftView.m
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBlagGiftView.h"
#import "YFBGiftPopView.h"

@interface YFBBlagGiftView ()
{
    UILabel *_titileLabel;
    UILabel *_subTitleLabel;
    UIImageView *_headerImageView;
    UIButton *_sendBtn;
    YFBGiftPopView *_popView;
}


@end

@implementation YFBBlagGiftView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_pop_back_image"]];
        backImage.userInteractionEnabled = YES;
        [self addSubview:backImage];
        {
            [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(self);
                make.right.mas_equalTo(self).mas_offset(kWidth(-24));
                make.top.mas_equalTo(self).mas_offset(kWidth(80));
            }];
        }
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.forceRoundCorner = YES;
        _headerImageView.layer.borderColor = kColor(@"#b96ad7").CGColor;
        _headerImageView.layer.borderWidth = kWidth(4);
        [self addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(backImage);
                make.top.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
        }
        UIImageView *startImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_pop_star_image"]];
        //        [startImage sizeToFit];
        [self addSubview:startImage];
        {
            [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.height.mas_equalTo(_headerImageView);
                //            make.size.mas_equalTo(CGSizeMake(kWidth(516), 140));
                make.width.mas_equalTo(kWidth(516));
            }];
        }
        
        _titileLabel = [[UILabel alloc] init];
        _titileLabel.font = kFont(16);
        _titileLabel.textColor = kColor(@"#333333");
        _titileLabel.textAlignment = NSTextAlignmentCenter;
        _titileLabel.backgroundColor = [UIColor clearColor];
        [backImage addSubview:_titileLabel];
        {
            [_titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(backImage);
                make.top.mas_equalTo(backImage).mas_offset(kWidth(104));
                make.height.mas_equalTo(kWidth(16));
            }];
        }
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kFont(12);
        _subTitleLabel.textColor = kColor(@"#999999");
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        [backImage addSubview:_subTitleLabel];
        {
            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_titileLabel.mas_bottom).mas_offset(kWidth(26));
                make.centerX.mas_equalTo(backImage);
                make.height.mas_equalTo(kWidth(48));
                make.width.mas_equalTo(kWidth(440));
            }];
        }
        _popView = [[YFBGiftPopView alloc] initWithGiftModels:nil edg:kWidth(6) footerHeight:kWidth(40) backColor:kColor(@"#ef5f73") isMessagePop:NO];
        [backImage addSubview:_popView];
        {
            [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(backImage).mas_offset(kWidth(26));
                make.right.mas_equalTo(backImage).mas_offset(kWidth(-26));
                make.top.mas_equalTo(_subTitleLabel.mas_bottom).mas_offset(kWidth(22));
                make.height.mas_equalTo((long)kWidth(356));
            }];
        }
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundColor:kColor(@"#f3b050")];
        _sendBtn.layer.cornerRadius = kWidth(38);
        _sendBtn.clipsToBounds = YES;
        _sendBtn.titleLabel.font = kFont(15);
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"打赏礼物" forState:UIControlStateNormal];
        @weakify(self);
        [_sendBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.giftAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        [backImage addSubview:_sendBtn];
        {
            [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(backImage).mas_offset(kWidth(-24));
                make.size.mas_equalTo(CGSizeMake(kWidth(500), kWidth(76)));
                make.centerX.mas_equalTo(backImage);
            }];
        }
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"gift_close_btn_icon"] forState:UIControlStateNormal];
        [closeBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.closeAction,self);
            
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        {
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(backImage.mas_right);
                make.centerY.mas_equalTo(backImage.mas_top).mas_offset(kWidth(60));
                make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(48)));
            }];
        }
    }
    return self;
}

- (void)setSendTitle:(NSString *)sendTitle {
    _sendTitle = sendTitle;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@向你索要礼物",sendTitle]];
    [attribute setAttributes:@{NSForegroundColorAttributeName : kColor(@"#fd5c61")} range:NSMakeRange(0, sendTitle.length)];
    _titileLabel.attributedText = attribute.copy;
}

- (void)setSendSubTitle:(NSString *)sendSubTitle {
    _sendSubTitle = sendSubTitle;
    _subTitleLabel.text = sendSubTitle;
}

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}

@end
