//
//  YFBUtil.m
//  YFBFriend
//
//  Created by Liang on 2017/2/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "YFBUser.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const kRegisterKeyName           = @"YFB_register_keyname";
static NSString *const kUserRegisterKeyName       = @"YFB_userRegister_keyname";
static NSString *const kUserAccessUsername        = @"YFB_user_access_username";
static NSString *const kUserAccessServicename     = @"YFB_user_access_service";
static NSString *const kImageTokenKeyName         = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword   = @"wafei@#$%^%$^$wfsssfsf";

static NSString *const kYFBMessageReplyIsFirstDayKeyName = @"kYFBMessageReplyIsFirstDayKeyName";
//static NSString *const kYFBMessageReplayTimesKeyName = @"kYFBMessageReplayTimesKeyName";
static NSString *const kYFBMessageReplayTodayKeyName = @"kYFBMessageReplayTodayKeyName";

@implementation YFBUtil

#pragma mark -- 设备注册激活

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

//设备激活
+ (NSString *)UUID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegisteredUUID {
    return [self UUID] != nil;
}

+ (void)setRegisteredWithUUID:(NSString *)uuid {
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 判断用户是否登录

+ (BOOL)checkUserIsLogin {
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendCurrentUserKeyName];
    if (currentUserId.length > 0) {
        return YES;
    }
    return NO;
}



#pragma mark - 设备类型
+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (YFBDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return YFBDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return YFBDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return YFBDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return YFBDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return YFBDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return YFBDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return YFBDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return YFBDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return YFBDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return YFBDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return YFBDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return YFBDeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return YFBDeviceType_iPad;
    } else {
        return YFBDeviceTypeUnknown;
    }
}

#pragma mark - 图片加密

+ (NSString *)imageToken {
    NSString *imageToken = [[NSUserDefaults standardUserDefaults] objectForKey:kImageTokenKeyName];
    if (!imageToken) {
        return nil;
    }
    
    return [imageToken decryptedStringWithPassword:kImageTokenCryptPassword];
}


+ (void)setImageToken:(NSString *)imageToken {
    if (imageToken) {
        imageToken = [imageToken encryptedStringWithPassword:kImageTokenCryptPassword];
        [[NSUserDefaults standardUserDefaults] setObject:imageToken forKey:kImageTokenKeyName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kImageTokenKeyName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 时间转换

+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)compareCurrentTime:(NSTimeInterval)compareTimeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:compareTimeInterval];
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

#pragma mark - VIP

+ (BOOL)isVip {
    NSDate *expireDate = [self dateFromString:[YFBUser currentUser].expireTime WithDateFormat:kDateFormateLongest];
    return [expireDate isInFuture];
}

+ (BOOL)isFirstDay {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kYFBMessageReplyIsFirstDayKeyName];
    if (!lastDate) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kYFBMessageReplyIsFirstDayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    if ([lastDate isToday]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isToday {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kYFBMessageReplayTodayKeyName];
    if (!lastDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kYFBMessageReplayTodayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    if ([lastDate isToday]) {
        return YES;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kYFBMessageReplayTodayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }
}

#pragma mark 获取视频的播放时长
+ (float)getVideoLengthWithVideoUrl:(NSURL *)videoUrl {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

@end
