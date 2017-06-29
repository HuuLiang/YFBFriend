//
//  YFBUserControlManager.h
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBUserControlModel : JKDBModel
@property (nonatomic) NSString *userId;
@end

@interface YFBUserControlManager : NSObject

+ (instancetype)manager;

- (BOOL)forbidTime;

- (BOOL)shoulForbidUserWithUserId:(NSString *)userId;

- (void)addUserIntoForbidList:(NSString *)userId;

@end
