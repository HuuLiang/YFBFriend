//
//  YFBMyGiftModel.m
//  YFBFriend
//
//  Created by ylz on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyGiftModel.h"

@implementation YFBMyGiftModel

- (void)fetchMyGiftModelWithType:(NSString *)typeString CompleteHandler :(QBCompletionHandler)handler {

    NSDictionary *params = @{@"type" : typeString ,
                             @"token" : [YFBUser currentUser].token ,
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId" : [YFBUser currentUser].userId};
    [self requestURLPath:YFB_MY_GIFT_URL standbyURLPath:nil withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        if (respStatus == QBURLResponseSuccess) {
         
            if (handler) {
                handler(respStatus == QBURLResponseSuccess,nil);
            }
        }
    }];

}

@end
