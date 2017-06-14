//
//  YFBLocalNotificationManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLocalNotificationManager.h"
#import "YFBAutoReplyManager.h"

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
        localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        localNotification.userInfo = @{kYFBAutoNotificationTypeKeyName:notiDate};
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
    
    NSArray * arr =  [dateArr bk_select:^BOOL(NSDate * obj) {
        return [obj isInFuture];
    }];
    
    return arr;
}

- (void)checkLocalNotificatin {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
//            [self registerLocalNotification];
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

        }
    } else {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            
            // 注册远程通知 -根据远程通知类型
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
    }
}

- (void)setAutoNotification {
    [self checkLocalNotificatin];
    
    NSInteger timeInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendGetRobotMsgTimeIntervalKeyName] integerValue];
    if (timeInterval <= 60 * 10 && [YFBAutoReplyManager manager].allReplyMsgs.count > 0) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [[NSDate date] dateByAddingMinutes:1];
        localNotification.timeZone = [NSTimeZone systemTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = @"您有未阅读的消息";
        localNotification.alertAction = @"您有未阅读的消息";
        localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        localNotification.userInfo = @{@"oneMin":@"oneMin"};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
