//
//  YFBUpdateUserVipModel.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUpdateUserVipModel.h"
#import "YFBSystemConfigModel.h"


@implementation YFBUpdateUserVipResponse

@end


@implementation YFBUpdateUserVipModel

+ (Class)responseClass {
    return [YFBUpdateUserVipResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 30;
}

- (BOOL)updateUserVipInfo:(YFBVipType)vipType CompletionHandler:(QBCompletionHandler)handler {
    NSInteger months = 0;
    if (vipType == YFBVipTypeYear) {
        months = [YFBSystemConfigModel sharedModel].vipMonthC;
    } else if (vipType == YFBVipTypeQuarter) {
        months = [YFBSystemConfigModel sharedModel].vipMonthB;
    } else if (vipType == YFBVipTypeMonth) {
        months = [YFBSystemConfigModel sharedModel].vipMonthA;
    }
    
    NSDictionary *params = @{@"userId":@"",
                             @"vipMonths":@(months)};
    
    BOOL success = [self requestURLPath:YFB_VIPUPDATE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBUpdateUserVipResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
//                            [JYUtil setVipExpireTime:resp.vipEndDate];
                        }
                    }];
    
    return success;
}
@end
