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
    return 10;
}

+ (Class)responseClass {
    return [YFBRegisterUserResponse class];
}

- (BOOL)registerUserWithUserInfo:(YFBUser *)user CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *userInfo = @{@"channelNo":YFB_CHANNEL_NO,
                               @"loginType":@(user.loginType),
                               @"password":user.password,
                               @"nickName":user.nickName,
                               @"portraitUrl":user.userImage ?: @"",
                               @"age":@(user.age),
                               @"vocation":user.job,
                               @"education":user.education,
                               @"monthlyIncome":user.income,
                               @"height":@(user.height),
                               @"marriageStatus":@(user.marriageStatus),
                               @"gender":user.userSex == YFBUserSexMale ? @"M" : @"F"};
    
    
    BOOL success = [self requestURLPath:YFB_USERCREATE_URL
                         standbyURLPath:nil
                             withParams:userInfo
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBRegisterUserResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            [YFBUser currentUser].userId = resp.userId;
                            [YFBUser currentUser].token = resp.token;
                            [[YFBUser currentUser] saveOrUpdate];
                        }
                        if (handler) {
                            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp);
                        }
                    }];
    return success;
}

@end
