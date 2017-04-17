//
//  YFBContactModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactModel.h"

@implementation YFBRobotMsgModel

@end


@implementation YFBContactUserModel
- (Class)robotMsgListElementClass {
    return [YFBRobotMsgModel class];
}
@end


@implementation YFBContactResponse
- (Class)userListElementClass {
    return [YFBContactUserModel class];
}
@end


@implementation YFBContactModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBContactResponse class];
}

- (BOOL)fetchContactInfoWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_MSGLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBContactResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp);
        }
    }];
    
    return success;
}

@end
