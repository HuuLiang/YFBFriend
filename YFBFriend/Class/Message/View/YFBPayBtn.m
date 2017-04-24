//
//  YFBPayBtn.m
//  YFBFriend
//
//  Created by ylz on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayBtn.h"

@interface YFBPayBtn ()

@property (nonatomic) UIImageView *selectImageView;
@end

@implementation YFBPayBtn
- (UILabel *)label {
    if (_label) {
        return _label;
    }
    _label = [[UILabel alloc] init];
    _label.font = kFont(18);
    _label.textColor = kColor(@"#000000");
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
    return _label;
}

- (UILabel *)subLabel {
    if (_subLabel) {
        return _subLabel;
    }
    _subLabel = [[UILabel alloc] init];
    _subLabel.font = kFont(18);
    _subLabel.textColor = kColor(@"#666666");
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_subLabel];
    
    return _subLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel) {
        return _detailLabel;
    }
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = kFont(13);
    _detailLabel.textColor = kColor(@"#f63f50");
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_detailLabel];
    return _detailLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColor(@"#f4f4f4");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#e0e0e0").CGColor;
        self.layer.cornerRadius = 5;
        [self clipsToBounds];
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
    self.label.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subLabel.text = subTitle;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    self.detailLabel.text = detailTitle;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (_label) {
        
    }
}

@end
