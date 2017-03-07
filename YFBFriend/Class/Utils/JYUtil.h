//
//  JYUtil.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYAppSpread;

@interface JYUtil : NSObject

+ (NSString *)accessId;

+ (NSString *)UUID;
+ (BOOL)isRegisteredUUID;
+ (void)setRegisteredWithUUID:(NSString *)uuid;
/**
 这里的userID使用的是UUID
 */
+ (NSString *)userId;
+ (BOOL)isRegisteredUserId;
+ (void)setRegisteredWithUserId:(NSString *)userId;
/**
 这里的userIDs是用户注册后请求注册的生成的userID
 */
+ (void)setRegisteredWithCurretnUserId:(NSString *)currentUserID;
+ (BOOL)isRegisteredAboutCurretnUserId;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

+ (BOOL)isVip;
+ (NSDate *)expireDateTime;
+ (void)setVipExpireTime:(NSString *)expireTime;
+ (BOOL)isSendPacketWithUserId:(NSString *)userId;//判断是否给该机器人发送过红包
+ (void)saveSendPacketUserId:(NSString *)userId;//把发送过红包的用户缓存起来

+ (BOOL)isIpad;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (JYDeviceType)deviceType;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;
+ (void)showSpreadBanner;
+ (void)getSpreadeBannerInfo;
+ (void)showBanner;
+ (NSArray <JYAppSpread *> *)getUnInstalledSpreads;

+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat;
+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat;
+ (BOOL)shouldRefreshContentWithKey:(NSString *)refreshKey timeInterval:(NSUInteger)timeInterval;
+ (NSDate *)currentDate;
+ (NSString *)compareCurrentTime:(NSString *)compareDateString;
+ (BOOL)isTodayWithKeyName:(NSString *)keyName;

+ (id)getValueWithKeyName:(NSString *)keyName;
+ (void)setValue:(id)object withKeyName:(NSString *)keyName;
+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(NSDictionary *)params;

+ (void)setInteractiveCount:(NSInteger)count WithUserType:(JYMineUsersType)type;
+ (NSInteger)getInteractiveCountWithUserType:(JYMineUsersType)type;

//+ (void)beforehandFetchFansCount;//预先获取粉丝和关注的个数
@end
