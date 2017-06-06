//
//  YFBSocialModel.m
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSocialModel.h"

@implementation YFBSocialResponse

@end


@implementation YFBSocialModel

+ (Class)responseClass {
    return [YFBSocialResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchSocialContentWithType:(YFBSocialType)socialType CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{};
    BOOL success = [self requestURLPath:nil
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBSocialResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,nil);
        }
    }];
    return success;
}

@end
