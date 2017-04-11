//
//  YFBRegisterUserModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRegisterUserModel.h"

@implementation YFBRegisterUserResponse


@end

@implementation YFBRegisterUserModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 5;
}

+ (Class)responseClass {
    return [YFBRegisterUserResponse class];
}

- (BOOL)registerUserWithUserInfo:(YFBUser *)user CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *userInfo = @{@"channelNo":YFB_CHANNEL_NO,
                               @"loginType":@(user.loginType),
                               @"loginName":user.nickName,
                               @"password":user.password,
                               @"nickName":user.nickName,
                               @"portraitUrl":user.userImage,
                               @"age":@"",
                               @"vocation":@"",
                               @"education":@"",
                               @"monthlyIncome":@"",
                               @"height":@"",
                               @"marriageStatus":@"",
                               @"gender":@"",};
    
    
    BOOL success = [self requestURLPath:YFB_USERCREATE_URL
                         standbyURLPath:nil
                             withParams:userInfo
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBRegisterUserResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            
                        }
                        if (handler) {
                            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp);
                        }
                    }];
    return success;
}

@end
