//
//  YFBBuyDiamondPrivilegeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBuyDiamondPrivilegeCell.h"

@interface YFBBuyDiamondPrivilegeCell ()
@property (nonatomic) UILabel *label;
@end

@implementation YFBBuyDiamondPrivilegeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.label = [[UILabel alloc] init];
        _label.textColor = kColor(@"#333333");
        _label.font = kFont(13);
        [self.contentView addSubview:_label];
        
        {
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.centerY.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(36));
            }];
        }
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

@end
