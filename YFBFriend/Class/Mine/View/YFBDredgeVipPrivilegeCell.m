//
//  YFBDredgeVipPrivilegeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDredgeVipPrivilegeCell.h"

#define TitleArr            @[@"畅",@"倍",@"减",@"送"]
#define PrivilegeArr        @[@"特权01",@"特权02",@"特权03",@"特权04"]
#define detailArr           @[@"可与所有女用户聊天",@"吸收灵气速度加倍",@"灵气消耗减半",@"购买Y币额外赠送10%"]

@interface YFBDredgeVipPrivilegeCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *privilegeLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@end

@implementation YFBDredgeVipPrivilegeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(18);
        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = kWidth(42);
        _titleLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleLabel];
        
        self.privilegeLabel = [[UILabel alloc] init];
        _privilegeLabel.textColor = kColor(@"#999999");
        _privilegeLabel.font = kFont(14);
        [self.contentView addSubview:_privilegeLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = kColor(@"#333333");
        _detailLabel.font = kFont(16);
        [self.contentView addSubview:_detailLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(84), kWidth(84)));
            }];
            
            [_privilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel.mas_right).offset(kWidth(30));
                make.bottom.equalTo(self.contentView.mas_centerY).offset(-kWidth(6));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_privilegeLabel);
                make.top.equalTo(self.contentView.mas_centerY).offset(kWidth(6));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _titleLabel.text = TitleArr[index];
    _privilegeLabel.text = PrivilegeArr[index];
    _detailLabel.text = detailArr[index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
