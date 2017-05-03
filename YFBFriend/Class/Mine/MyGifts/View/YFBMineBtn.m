//
//  YFBMineBtn.m
//  YFBFriend
//
//  Created by ylz on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineBtn.h"

@implementation YFBMineBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(CGRectGetWidth(contentRect) - CGRectGetHeight(contentRect)*0.55, contentRect.origin.y, CGRectGetHeight(contentRect)*0.55, CGRectGetHeight(contentRect)*0.4);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    return CGRectMake(0,contentRect.origin.y , CGRectGetWidth(contentRect) - (CGRectGetWidth(imageRect)), CGRectGetHeight(imageRect));
}

@end
