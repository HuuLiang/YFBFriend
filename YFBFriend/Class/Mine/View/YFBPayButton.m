//
//  YFBPayButton.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayButton.h"

@interface YFBPayButton ()
{
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UILabel *_detailLabel;
}
@property (nonatomic) UIImageView *selectImageView;
@end

@implementation YFBPayButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColor(@"#f4f4f4");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#e0e0e0").CGColor;
        self.layer.cornerRadius = 5;
        [self clipsToBounds];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(18);
        _titleLabel.textColor = kColor(@"#000000");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.mas_equalTo(self).mas_offset(kWidth(40));
                make.height.mas_equalTo(kWidth(40));
            }];
        }
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kFont(18);
        _subTitleLabel.textColor = kColor(@"#666666");
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_subTitleLabel];
        {
            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(kWidth(12));
                make.height.mas_equalTo(kWidth(40));
            }];
        }
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(13);
        _detailLabel.textColor = kColor(@"#f63f50");
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.mas_equalTo(_subTitleLabel.mas_bottom).mas_offset(kWidth(12));
                make.height.mas_equalTo(kWidth(40));
            }];
        }
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_pay_selcte_icon"]];
        [self addSubview:_selectImageView];
        {
            [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
        }
        _selectImageView.hidden = YES;
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _selectImageView.hidden = NO;
        self.backgroundColor = kColor(@"#f3eaea");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#f34254").CGColor;
        
    }else{
        _selectImageView.hidden = YES;
        self.backgroundColor = kColor(@"#f4f4f4");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#e0e0e0").CGColor;
    }
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    _detailLabel.text = detailTitle;
}

@end
