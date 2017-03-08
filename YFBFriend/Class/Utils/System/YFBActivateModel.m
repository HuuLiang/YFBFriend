//
//  YFBActivateModel.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation YFBActivate


@end

@implementation YFBActivateModel

+ (Class)responseClass {
    return [YFBActivate class];
}

+ (instancetype)sharedModel {
    static YFBActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YFBActivateModel alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(YFBActivateHandler)handler {
    //    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
    //                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
    //                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    //
    //    NSDictionary *params = @{@"cn":JY_CHANNEL_NO,
    //                             @"imsi":@"999999999999999",
    //                             @"imei":@"999999999999999",
    //                             @"sms":@"00000000000",
    //                             @"cw":@(kScreenWidth),
    //                             @"ch":@(kScreenHeight),
    //                             @"cm":[JYUtil deviceName],
    //                             @"mf":[UIDevice currentDevice].model,
    //                             @"sdkV":sdkV,
    //                             @"cpuV":@"",
    //                             @"appV":[JYUtil appVersion],
    //                             @"appVN":@"",
    //                             @"ccn":JY_PACKAGE_CERTIFICATE,
    //                             @"operator":[QBNetworkInfo sharedInfo].carriarName ?: @"",
    //                             @"systemVersion":[UIDevice currentDevice].systemVersion};
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"appVersion":[YFBUtil appVersion],
                             @"appId":YFB_REST_APPID};
    
    BOOL success = [self requestURLPath:YFB_ACTIVATION_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                            YFBActivate *resp;
                            if (respStatus == QBURLResponseSuccess) {
                                resp = self.response;
                            }
                            
                            if (handler) {
                                handler(respStatus == QBURLResponseSuccess , resp.uuid);
                            }
                        }];
    return success;
}

@end
