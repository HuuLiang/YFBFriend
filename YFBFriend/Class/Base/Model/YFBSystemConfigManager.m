//
//  YFBSystemConfigManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSystemConfigManager.h"

@implementation YFBSystemConfig

@end

@implementation YFBSystemConfigManager

+ (Class)responseClass {
    return [YFBSystemConfig class];
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

+ (instancetype)manager {
    static YFBSystemConfigManager *_systemConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemConfig = [[YFBSystemConfigManager alloc] init];
    });
    return _systemConfig;
}

- (void)getSystemConfigInfo {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"type":@(2)};
    
    [self requestURLPath:YFB_CONFIG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBSystemConfig *config = nil;
        if (respStatus == QBURLResponseSuccess) {
            config = self.response;
        }
    }];
}

@end
