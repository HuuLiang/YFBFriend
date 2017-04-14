//
//  YFBGreetingModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGreetingModel.h"
#import "YFBRobot.h"

#pragma mark - 获取一键打招呼用户

@implementation YFBGreetingInfoResponse
- (Class)userListElementClass {
    return [YFBRobot class];
}
@end

@implementation YFBGreetingInfoModel
- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBGreetingInfoResponse class];
}

- (BOOL)fetchGreetingInfoWithCompletionHandler:(QBCompletionHandler)handler {
    
    NSDictionary *params = @{@"gender":[YFBUser currentUser].userSex == YFBUserSexMale ? @"M" : @"F",
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_GREETINFO_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBGreetingInfoResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.userList);
        }
    }];
    return success;
}
@end

#pragma mark - 一键打招呼

@implementation YFBGreetingResponse

@end

@implementation YFBGreetingModel


- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBGreetingResponse class];
}

- (BOOL)fetchGreetingInfoWithUserIdStr:(NSArray <YFBRobot *>*)userList CompletionHandler:(QBCompletionHandler)handler {
    
    NSMutableArray *availableUserList = [NSMutableArray array];
    NSMutableArray *userIdList = [NSMutableArray array];
    
//    [userList enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    }];
    
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
//            [availableUserList enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBRobot *  _Nonnull robot, NSUInteger idx, BOOL * _Nonnull stop) {
//                robot.greeted = YES;
//                [robot saveOrUpdate];
//            }];
            
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

@end
