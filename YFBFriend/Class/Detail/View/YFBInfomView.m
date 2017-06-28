//
//  YFBInfomView.m
//  YFBFriend
//
//  Created by Liang on 2017/6/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBInfomView.h"

@interface YFBInfomView ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UIButton *blackButton;
@property (nonatomic) UIButton *informButton;
@end

@implementation YFBInfomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_Triangle"]];
        [self addSubview:_imgV];
        
        self.blackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_blackButton setTitle:@"拉黑" forState:UIControlStateNormal];
        [_blackButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _blackButton.titleLabel.font = kFont(14);
        _blackButton.backgroundColor = kColor(@"#ffffff");
        [self addSubview:_blackButton];
        
        self.informButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_informButton setTitle:@"举报" forState:UIControlStateNormal];
        [_informButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _informButton.titleLabel.font = kFont(14);
        _informButton.backgroundColor = kColor(@"#ffffff");
        [self addSubview:_informButton];
        
        @weakify(self);
        [_blackButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.blackAction) {
                self.blackAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_informButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.informAction) {
                self.informAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-kWidth(16));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];
            
            [_blackButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imgV.mas_bottom);
                make.right.equalTo(self.mas_right);
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(84)));
            }];
            
            [_informButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_blackButton.mas_bottom).offset(0.5);
                make.right.equalTo(self.mas_right);
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(84)));
            }];
        }
        
    }
    return self;
}

@end
