//
//  YFBLocalNotificationManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation YFBLocalNotificationManager

+ (instancetype)manager {
    static YFBLocalNotificationManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBLocalNotificationManager alloc] init];
    });
    return _manager;
}

- (void)startAutoLocalNotification {
    
    [self checkLocalNotificatin];
    
    //删除所有本地通知 重新添加新的一轮通知周期
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (NSDate *notiDate in [self getAllLocalNotificationDates]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = notiDate;
        localNotification.timeZone = [NSTimeZone systemTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = @"您有未阅读的消息";
        localNotification.alertAction = @"您有未阅读的消息";
        localNotification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (NSArray <NSDate *> *)getAllLocalNotificationDates {
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:[[NSDate date] year]];
    [comps setMonth:[[NSDate date] month]];
    [comps setDay:[[NSDate date] day]];
    [comps setHour:10];
    [comps setMinute:3];
    [comps setSecond:0];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *instanceDate = [calendar dateFromComponents:comps];

    for (NSInteger dayCount = 0; dayCount < 3 ; dayCount++) {
        NSDate *newDate = [instanceDate dateByAddingDays:dayCount];
        for (NSInteger i = 0; i < 3; i++) {
            if (i == 0) {
                [dateArr addObject:newDate];
            } else if (i == 1) {
                newDate  = [newDate dateByAddingHours:5];
                newDate = [newDate dateByAddingMinutes:7];
                [dateArr addObject:newDate];
            } else if (i == 2) {
                newDate = [newDate dateByAddingHours:12];
                newDate = [newDate dateByAddingMinutes:3];
                [dateArr addObject:newDate];
            }
        }
    }
    return dateArr;
}

- (void)checkLocalNotificatin {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
            [self registerLocalNotification];
        }
    } else {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            [self registerLocalNotification];
        }
    }
}

- (void)registerLocalNotification {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)setAutoNotification {
    [self checkLocalNotificatin];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingMinutes:1];
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = @"您有未阅读的消息";
    localNotification.alertAction = @"您有未阅读的消息";
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
