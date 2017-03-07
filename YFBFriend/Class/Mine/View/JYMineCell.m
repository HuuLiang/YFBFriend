//
//  JYMineCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineCell.h"

@interface JYMineCell ()
{
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
}
@end

@implementation JYMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(kWidth(30));
                make.centerY.mas_equalTo(self.contentView);
                make.height.equalTo(self.contentView).multipliedBy(0.45);
                make.width.equalTo(_iconImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        _titleLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_iconImageView);
                make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(kWidth(20));
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    _iconImageView.image = iconImage;
}


@end
