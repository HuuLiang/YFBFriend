//
//  YFBInteractionManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
@class YFBRobot;

@interface YFBInteractionManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)greetWithUserInfoList:(NSArray <YFBRobot *> *)userList toAllUsers:(BOOL)toAll handler:(void(^)(BOOL success))handler;

- (void)concernUserWithUserId:(NSString *)userId handler:(void(^)(BOOL success))handler;

- (void)cancleConcernUserWithUserId:(NSString *)userId handler:(void(^)(BOOL success))handler;

- (void)sendAdviceWithContent:(NSString *)content Contact:(NSString *)contact handler:(void(^)(BOOL success))handler;

@end
