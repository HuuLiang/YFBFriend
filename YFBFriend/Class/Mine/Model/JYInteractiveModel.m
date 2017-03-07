//
//  JYInteractiveModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYInteractiveModel.h"

@implementation JYInteractiveUser


@end


@implementation JYInteractiveResponse

- (Class)userListElementClass {
    return [JYInteractiveUser class];
}

@end

@implementation JYInteractiveModel

+ (Class)responseClass {
    return [JYInteractiveResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchInteractiveInfoWithType:(JYMineUsersType)type count:(NSInteger)count CompletionHandler:(QBCompletionHandler)handler {
    
    NSDictionary *params = nil;
    if (type == JYMineUsersTypeFollow) {
        params = @{@"sendUserId":[JYUtil UUID],
                   @"msgType":@"FOLLOW"};
    } else if (type == JYMineUsersTypeFans) {
        params = @{@"receiveUserId":[JYUtil UUID],
                   @"msgType":@"FOLLOW",
                   @"an" : @(count)};
    } else if (type == JYMineUsersTypeVisitor) {
        params = @{@"receiveUserId":[JYUtil UUID],
                   @"msgType":@"VISIT",
                   @"an" : @(count)};
    }
    
    BOOL success = [self requestURLPath:JY_INTERACTIVE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYInteractiveResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.userList);
        }
        
    }];
    return success;
}

@end
