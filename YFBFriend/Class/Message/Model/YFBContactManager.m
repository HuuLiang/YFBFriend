//
//  YFBContactManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactManager.h"

@implementation YFBContactModel

@end


@implementation YFBContactManager

+ (instancetype)manager {
    static YFBContactManager *_contactManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _contactManager = [[YFBContactManager alloc] init];
    });
    return _contactManager;
}

- (NSArray <YFBContactModel *> *)loadAllContactInfo {
    NSArray *allContacts = [YFBContactModel findAll];
    return allContacts;
}

@end
