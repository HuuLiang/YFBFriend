//
//  YFBUser.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YFBUserSex) {
    YFBUserSexMale = 0,  //男性
    YFBUserSexFemale,    //女性
};




@interface YFBUser : NSObject <NSCoding>

+ (instancetype)currentUser;

//用户ID
@property (nonatomic,copy) NSString *userId;


- (void)saveOrUpdate;





#pragma mark - 注册信息

+ (NSArray *)allUserJob;

+ (NSArray *)allUserEdu;

+ (NSArray *)allUserIncome;

+ (NSArray *)allUserHeight;

+ (NSArray *)allUserMarr;

@end
