//
//  YFBAccountManager.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAccountManager.h"

@implementation YFBAccountManager

+ (instancetype)manager {
    static YFBAccountManager *_accountManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountManger = [[YFBAccountManager alloc] init];
    });
    return _accountManger;
}

- (void)loginWithQQ {
    
}

- (void)loginWithWX {
    
}

- (void)loginWithAccountAndPassword {
    
}


@end
