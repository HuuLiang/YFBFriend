//
//  JYMineAvatarButton.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineAvatarButton.h"

@implementation JYMineAvatarButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#FF206F"];
        self.titleLabel.layer.cornerRadius = 5;
        self.titleLabel.clipsToBounds = YES;
        self.imageView.forceRoundCorner = YES;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat titleWidth = imageRect.size.width * 1.25;
    return CGRectMake(-(titleWidth-imageRect.size.width)/2, CGRectGetMaxY(imageRect)+5, titleWidth, 30);
}

@end
