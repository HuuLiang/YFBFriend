//
//  YFBUserControlManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUserControlManager.h"

static NSString *const KYFBForbidUserKeyName = @"KYFBForbidUserKeyName";

@implementation YFBUserControlModel


@end

@implementation YFBUserControlManager

+ (instancetype)manager {
    static YFBUserControlManager *_controlManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _controlManager = [[YFBUserControlManager alloc] init];
    });
    return _controlManager;
}

- (BOOL)forbidTime {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:KYFBForbidUserKeyName];
    if (!date) {
        date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:KYFBForbidUserKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    } else {
        if ([[NSDate date] hoursAfterDate:date] > 120) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)shoulForbidUserWithUserId:(NSString *)userId {
    if ([self forbidTime]) {
        YFBUserControlModel *userControlModel = [YFBUserControlModel findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
        return userControlModel != nil;
    } else {
        return NO;
    }
}

- (void)addUserIntoForbidList:(NSString *)userId {
    YFBUserControlModel *userControlModel = [YFBUserControlModel findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (userControlModel) {
        return;
    }
    userControlModel = [[YFBUserControlModel alloc] init];
    userControlModel.userId = userId;
    [userControlModel saveOrUpdate];
}

@end
