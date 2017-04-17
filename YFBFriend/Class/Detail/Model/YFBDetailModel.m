//
//  YFBDetailModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailModel.h"

@implementation YFBUserBaseInfoModel

@end

@implementation YFBUserLoginModel
- (Class)userBaseInfoClass {
    return [YFBUserBaseInfoModel class];
}
@end

@implementation YFBDetailResponse
- (Class)userLoginInfoClass {
    return [YFBUserLoginModel class];
}
@end


@implementation YFBDetailModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBDetailResponse class];
}

- (BOOL)fetchDetailInfoWithUserId:(NSString *)userId CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"toUserId":userId};
    BOOL success = [self requestURLPath:YFB_DETAIL_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        
    }];
    return success;
}

@end
