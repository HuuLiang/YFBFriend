//
//  YFBBlackCell.m
//  YFBFriend
//
//  Created by Liang on 2017/6/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBlackCell.h"

@interface YFBBlackCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UIButton *selectedButton;
@end

@implementation YFBBlackCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[UIImage imageNamed:@"black_normal"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectedButton];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(kWidth(10));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(36)));
            }];
        }
        
        
    }
    return self;
}

- (void)setUserImgStr:(NSString *)userImgStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:userImgStr] placeholderImage:[UIImage imageNamed:@"mine_default_avatar"]];
}

- (void)setSelectedCell:(BOOL)selectedCell {
    if (selectedCell) {
        [_selectedButton setImage:[UIImage imageNamed:@"black_selected"] forState:UIControlStateNormal];
    } else {
        [_selectedButton setImage:[UIImage imageNamed:@"black_normal"] forState:UIControlStateNormal];
    }
}

@end
