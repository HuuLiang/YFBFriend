//
//  YFBMessagePayTitleCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayTitleCell.h"

@interface YFBMessagePayTitleCell ()
@property (nonatomic) UILabel *label;
@property (nonatomic) UILabel *subLabel;
@end


@implementation YFBMessagePayTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.layer.cornerRadius = 3;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = kColor(@"#dddddd").CGColor;
        
        self.label = [[UILabel alloc] init];
        _label.font = kFont(12);
        _label.textColor = kColor(@"#666666");
        [self.contentView addSubview:_label];
        
        self.subLabel = [[UILabel alloc] init];
        _subLabel.font = kFont(12);
        _subLabel.textColor = kColor(@"#8458D0");
        [self.contentView addSubview:_subLabel];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(kWidth(40));
            make.right.equalTo(self).offset(-kWidth(40));
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(kWidth(6));
        }];
        
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(_label.mas_right).offset(kWidth(4));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subLabel.text = subTitle;
}

@end
