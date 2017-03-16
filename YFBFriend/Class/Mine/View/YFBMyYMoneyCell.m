//
//  YFBMyYMoneyCell.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyYMoneyCell.h"

@interface YFBMyYMoneyCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation YFBMyYMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithResourcePath:@"my_ymoney" ofType:@"jpg"]];
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(kWidth(200));
            }];
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14);
        _titleLabel.backgroundColor = kColor(@"#fffbf0");
        _titleLabel.textColor = kColor(@"#cdbe93");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self);
                make.top.mas_equalTo(_imageView.mas_bottom);
            }];
        }
        [self setTitleLabelText];
    }
    
    return self;
}

- (void)setTitleLabelText{
    
    _titleLabel.text = @"已购买Y币用户: 234353人";
    
    
    
}



@end
