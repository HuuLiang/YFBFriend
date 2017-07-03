//
//  YFBSystemConfigManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSystemConfigManager.h"

@implementation YFBSystemConfig
- (Class)configClass {
    return [YFBSystemConfig class];
}

@end


@implementation YFBSystemConfigResponse
- (Class)configClass {
    return [YFBSystemConfig class];
}
@end

@implementation YFBSystemConfigManager

+ (Class)responseClass {
    return [YFBSystemConfigResponse class];
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

    NSDictionary *params = @{@"type":@(2)};
    
    [self requestURLPath:YFB_CONFIG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBSystemConfigResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            self.SEX_SWITCH = resp.config.SEX_SWITCH;
        }
    }];
}

@end
