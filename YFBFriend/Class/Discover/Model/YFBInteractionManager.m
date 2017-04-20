//
//  YFBInteractionManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBInteractionManager.h"
#import "YFBGreetingModel.h"
#import "YFBRobot.h"

@interface YFBInteractionManager ()
@property (nonatomic,retain) YFBGreetingModel *greetModel;
@end

@implementation YFBInteractionManager
QBDefineLazyPropertyInitialization(YFBGreetingModel, greetModel)

+ (instancetype)manager {
    static YFBInteractionManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBInteractionManager alloc] init];
    });
    return _manager;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

//打招呼
- (void)greetWithUserInfoList:(NSArray<YFBRobot *> *)userList handler:(void (^)(BOOL success))handler {
    [self.greetModel fetchGreetingInfoWithUserIdStr:userList CompletionHandler:^(BOOL success, id obj) {
        QBSafelyCallBlock(handler,success);
    }];
}

- (BOOL)fetchGreetingInfoWithUserIdStr:(NSArray <YFBRobot *> *)userList CompletionHandler:(QBCompletionHandler)handler {
    NSMutableArray *availableUserList = [NSMutableArray array];
    NSMutableArray *userIdList = [NSMutableArray array];
    
    [userList enumerateObjectsUsingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![YFBRobot checkUserIsGreetedWithUserId:obj.userId]) {
            [userIdList addObject:obj.userId];
            [availableUserList addObject:obj];
        }
    }];
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"userIdStr":[userIdList componentsJoinedByString:@","]};
    
    BOOL success = [self requestURLPath:YFB_GREET_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (respStatus == QBURLResponseSuccess) {
                            
                            [availableUserList enumerateObjectsUsingBlock:^(YFBRobot *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                obj.greeted = YES;
                                [obj saveOrUpdate];
                            }];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,nil);
                        }
                    }];
    return success;
}

//关注
- (void)concernUserWithUserId:(NSString *)userId handler:(void (^)(BOOL))handler {
    __block YFBRobot *robot = [YFBRobot findFirstByCriteria:[NSString stringWithFormat:@"WHRER userId=\'%@\'",userId]];
    if (robot.concerned) {
        [[YFBHudManager manager] showHudWithText:@"已经关注过了"];
        return;
    }
    [self concernOrCancleUserWithUserId:userId isConcern:YES CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            if (!robot) {
                robot = [[YFBRobot alloc] init];
            }
            robot.concerned = YES;
            [robot saveOrUpdate];
        } else {
            [[YFBHudManager manager] showHudWithText:@"关注失败，请重试"];
        }
    }];
}

//取消关注
- (void)cancleConcernUserWithUserId:(NSString *)userId handler:(void (^)(BOOL))handler {
    __block YFBRobot *robot = [YFBRobot findFirstByCriteria:[NSString stringWithFormat:@"WHRER userId=\'%@\'",userId]];
    if (robot.concerned) {
        [self concernOrCancleUserWithUserId:userId isConcern:NO CompletionHandler:^(BOOL success, id obj) {
            if (success) {
                if (!robot) {
                    robot = [[YFBRobot alloc] init];
                }
                robot.concerned = NO;
                [robot saveOrUpdate];
            } else {
                [[YFBHudManager manager] showHudWithText:@"取消关注失败，请重试"];
            }
        }];
    } else {
        [[YFBHudManager manager] showHudWithText:@"您还未关注TA哦"];
    }

}

- (BOOL)concernOrCancleUserWithUserId:(NSString *)userId isConcern:(BOOL)isConcern CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"toUserId":userId};
    BOOL success = [self requestURLPath:isConcern ? YFB_CONCERN_URL : YFB_CANCELCONCERN_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,nil);
        }
    }];
    
    return success;
}

@end
