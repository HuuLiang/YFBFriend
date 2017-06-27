//
//  YFBSystemConfigManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSystemConfigManager.h"

@implementation YFBSystemConfigManager

+ (instancetype)manager {
    static YFBSystemConfigManager *_systemConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemConfig = [[YFBSystemConfigManager alloc] init];
    });
    return _systemConfig;
}

- (void)getSystemConfigInfo {
    NSDictionary *params = @{};
    [self requestURLPath:YFB_CONFIG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == QBURLResponseSuccess) {
            
        }
    }];
}

@end
