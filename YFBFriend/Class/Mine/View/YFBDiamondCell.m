//
//  YFBDiamondCell.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondCell.h"

@interface YFBDiamondCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIButton *_detailBtn;
}

@end

@implementation YFBDiamondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_diamond_icon"]];
        [self addSubview:_imageView];
        {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(40));
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(40)));
        }];
        }
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.titleLabel.font = kFont(15);
        [_detailBtn setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _detailBtn.layer.borderColor = kColor(@"#e6e6e6").CGColor;
        _detailBtn.layer.borderWidth = 1;
        [self addSubview:_detailBtn];
        {
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(kWidth(-40));
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(180), kWidth(64)));
        }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = kColor(@"#333333");
        [self addSubview:_titleLabel];
        {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageView.mas_right).mas_offset(kWidth(12));
            make.centerY.mas_equalTo(_imageView);
            make.right.mas_equalTo(_detailBtn.mas_left).mas_offset(kWidth(-30));
            make.height.mas_equalTo(kWidth(45));
        }];
        }
    }
    return self;
}

- (void)setTitle:(NSNumber *)title {
    _title = title;
    _titleLabel.text = title.stringValue;
}

- (void)setPrice:(NSNumber *)price {
    _price = price;
    [_detailBtn setTitle:[NSString stringWithFormat:@"¥  %@",price] forState:UIControlStateNormal];
}

@end
