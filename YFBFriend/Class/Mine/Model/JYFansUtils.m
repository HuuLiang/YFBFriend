//
//  JYFansUtils.m
//  JYFriend
//
//  Created by ylz on 2017/2/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYFansUtils.h"
#import "JYInteractiveModel.h"


static NSString *const JYSaveISFirstDayDictionaryKey = @"jy_save_isfirst_day_dictionary_key";
static NSString *const JYSaveFirstDateKey = @"jy2017_save_first_date_key";

@implementation JYFansUtils

+ (NSInteger)fetchLoadFansCountWithTiemKey:(NSString *)timeKey {
    if (!timeKey) {
        return 0;
    }
    NSDate *firstLoadDate = [self fetchFirstLoadDayDateWithTimeKey:timeKey];
    
    NSMutableDictionary *dayDict = [self fistDayDictWithTimeKey:timeKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastDate = [defaults objectForKey:timeKey];
    if (!lastDate) {
        [defaults setObject:[NSDate date] forKey:timeKey];
        [defaults synchronize];
        return [self randomNumberWithMinNumber:9 maxNumber:15];//第一次启动,随机加载9-15条
    }
    
    if (lastDate) {
        NSDate *currentDate = [NSDate date];//判断是否是第一天
        if (firstLoadDate.year == currentDate.year && firstLoadDate.month == currentDate.month && firstLoadDate.day == currentDate.day) {
      
            NSInteger hours = [[NSDate date] hoursAfterDate:lastDate];
            NSInteger loadCount = 0;
            for (int i = 0; i<hours; i++) {
                loadCount += [self randomNumberWithMinNumber:1 maxNumber:3];
            }
            if (loadCount > 0) {
                [defaults setObject:[NSDate date] forKey:timeKey];
                [defaults synchronize];
            }
            return loadCount;

        }else{
        
            NSInteger days = [[NSDate date] daysAfterDate:lastDate];

//            QBLog(@"%zd,last%zd",[NSDate date].seconds,lastDate.seconds)
        if (([NSDate date].hour < lastDate.hour ||
             ([NSDate date].hour == lastDate.hour && [NSDate date].minute < lastDate.minute) ||
             ([NSDate date].hour == lastDate.hour && [NSDate date].minute == lastDate.minute && [NSDate date].seconds < lastDate.seconds)))
        {
            days = days +1;
        }else {
        
            days = days;
        }
            
            NSInteger loadCount = 0;
            for (int i = 0; i < days; i++) {
                loadCount += [self randomNumberWithMinNumber:3 maxNumber:5];
            }
            if (days > 0 && ![dayDict[timeKey] boolValue]) {
                [dayDict setObject:@(YES) forKey:timeKey];
                [defaults setObject:dayDict forKey:JYSaveISFirstDayDictionaryKey];
                [defaults synchronize];
                NSInteger hours = 24 - lastDate.hour;
                for (int i = 0; i<hours; i++) {
                    loadCount += [self randomNumberWithMinNumber:1 maxNumber:3];
                }
                
            }
            if (loadCount > 0) {
                [defaults setObject:[NSDate date] forKey:timeKey];
                [defaults synchronize];
            }
            return loadCount;
            }
    }
    return 0;
}

+ (int)randomNumberWithMinNumber:(int)minNumber maxNumber:(int)maxNumber{
    
    int random = arc4random_uniform(maxNumber - minNumber +1) + minNumber;
    
    return random;
}

+ (NSMutableDictionary *)fistDayDictWithTimeKey:(NSString *)timeKey {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dayDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:JYSaveISFirstDayDictionaryKey]];
    if (!dayDict) {//用字典缓存是否已经加载过从上次打开到当天凌晨的个数
        dayDict = [NSMutableDictionary dictionary];
    }
    if (![[dayDict allKeys] containsObject:timeKey]) {
        [dayDict setObject:@(NO) forKey:timeKey];
        [defaults setObject:dayDict forKey:JYSaveISFirstDayDictionaryKey];
        [defaults synchronize];
    }
    return dayDict;
}

+ (NSDate *)fetchFirstLoadDayDateWithTimeKey:(NSString *)timeKey {
    if (!timeKey) {
        return nil;
    }
//缓存第一次打开的date
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dayDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:JYSaveFirstDateKey]];
    if (!dayDict) {
        dayDict = [NSMutableDictionary dictionary];
    }
    if (![[dayDict allKeys] containsObject:timeKey]) {
        [dayDict setObject:[NSDate date] forKey:timeKey];
        [defaults setObject:dayDict forKey:JYSaveFirstDateKey];
        [defaults synchronize];
    }
    return dayDict[timeKey];
}





@end
