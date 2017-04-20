//
//  YFBGiftPopCell.m
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopCell.h"

@interface YFBGiftPopCell ()
{
    UILabel *_titleLabel;
    UIButton *_diamondBtn;
    UIImageView *_imageView;
}

@end

@implementation YFBGiftPopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setImage:[UIImage imageNamed:@"gift_pop_diamond_icon"] forState:UIControlStateNormal];
        _diamondBtn.titleLabel.font = kFont(10);
        _diamondBtn.userInteractionEnabled = NO;
        _diamondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_diamondBtn];
        {
            [_diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.right.mas_equalTo(self).mas_offset(kWidth(-9));
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(9);
        _titleLabel.textColor = kColor(@"#ffffff");
        //        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(9));
                make.bottom.mas_equalTo(self);
                make.right.mas_lessThanOrEqualTo(_diamondBtn.mas_left).mas_offset(kWidth(6));//mas_equalTo(_diamondBtn.mas_left);
            }];
        }
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [_imageView sizeToFit];
        _imageView.image = [UIImage imageNamed:@"bbt"];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self);
            }];
        }
        
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _diamondCount = diamondCount;
    [_diamondBtn setTitle:[NSString stringWithFormat:@"%zd",diamondCount] forState:UIControlStateNormal];
}

@end
