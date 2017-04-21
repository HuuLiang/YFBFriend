//
//  YFBDiamonManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamonManager.h"

@implementation YFBDiamonInfo

@end


@implementation YFBDiamonResponse
- (Class)diamondPriceConfListElementClass {
    return [YFBDiamonInfo class];
}
@end


@implementation YFBDiamonManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBDiamonResponse class];
}

+ (instancetype)manager {
    static YFBDiamonManager *_diamonModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _diamonModel = [[YFBDiamonManager alloc] init];
    });
    return _diamonModel;
}

- (void)getDiamonListCache {
    if (self.diamonList.count == 0) {
        [self fetchDiamonListWithCompletionHandler:^(BOOL success, NSArray <YFBDiamonInfo *> *obj) {
            if (success) {
                _diamonList = obj;
            } else {
                [self performSelector:@selector(getDiamonListCache) withObject:nil afterDelay:30];
            }
        }];
    }
}

- (BOOL)fetchDiamonListWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_DIAMONLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBDiamonResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.diamondPriceConfList);
                        }
                    }];
    return success;
}


@end
