//
//  YFBUser.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUser.h"

static YFBUser *_currentUser;

static NSString *const kYFBFriendCurrentUserKeyName      = @"kYFBFriendCurrentUserKeyName";
static NSString *const kYFBFriendCurrentUserIdKeyName    = @"kYFBFriendCurrentUserIdKeyName";

@implementation YFBUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendCurrentUserKeyName]];
        if (!_currentUser) {
            _currentUser = [[YFBUser alloc] init];
        }
    });
    return _currentUser;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.userId = [coder decodeObjectForKey:kYFBFriendCurrentUserIdKeyName];;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:kYFBFriendCurrentUserIdKeyName];
}

- (void)saveOrUpdate {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kYFBFriendCurrentUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
