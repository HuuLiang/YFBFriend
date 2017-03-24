//
//  YFBUser.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YFBUserSex) {
    YFBUsersexUnkown = 0,
    YFBUserSexMale,  //男性
    YFBUserSexFemale,    //女性
};

static NSString *const kYFBCurrentUserImageCacheKeyName = @"kYFBCurrentUserImageCacheKeyName";

@interface YFBUser : NSObject <NSCoding>

+ (instancetype)currentUser;

//用户ID
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,strong) UIImage *userImage;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,assign) YFBUserSex userSex;

@property (nonatomic,copy) NSString *age;

@property (nonatomic,copy) NSString *liveCity;

@property (nonatomic,copy) NSString *height;

@property (nonatomic,copy) NSString *income;

@property (nonatomic,copy) NSString *marrying;

@property (nonatomic,copy) NSString *QQNumber;

@property (nonatomic,copy) NSString *WXNumber;

@property (nonatomic,copy) NSString *phoneNumber;

@property (nonatomic,copy) NSString *education;

@property (nonatomic,copy) NSString *job;

@property (nonatomic,copy) NSString *birthday;

@property (nonatomic,copy) NSString *weight;

@property (nonatomic,copy) NSString *star;

- (void)saveOrUpdate;

#pragma mark - 注册信息

+ (NSArray *)allUserSex;
+ (NSArray *)allUserAge;
+ (NSArray *)allUserWeight;
+ (NSArray *)allUserStars;

//职业
+ (NSArray *)allUserJob;
//学历
+ (NSArray *)allUserEdu;
//收入
+ (NSArray *)allUserIncome;
//身高
+ (NSArray *)allUserHeight;
//婚姻状况
+ (NSArray *)allUserMarr;

+ (NSMutableDictionary *)allProvincesAndCities;
+ (NSArray *)defaultHometown;
+ (NSArray *)allCitiesWihtProvince:(NSString *)province;

@end
