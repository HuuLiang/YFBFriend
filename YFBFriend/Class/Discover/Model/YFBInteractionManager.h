//
//  YFBInteractionManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFBRobot;

@interface YFBInteractionManager : NSObject

+ (instancetype)manager;

- (void)greetWithUserInfoList:(NSArray <YFBRobot *> *)userList handler:(void(^)(BOOL *success))handler;

@end
