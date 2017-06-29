//
//  YFBApplePayManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBApplePayManager.h"
#import <StoreKit/StoreKit.h>

@implementation YFBApplePayManager

+ (instancetype)manager {
    static YFBApplePayManager *_applePayManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _applePayManager = [[YFBApplePayManager alloc] init];
    });
    return _applePayManager;
}



@end
