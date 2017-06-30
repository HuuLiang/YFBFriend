//
//  YFBDiamondManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondManager.h"
#import "YFBApplePayManager.h"

@implementation YFBDiamondInfo

@end


@implementation YFBDiamondResponse
- (Class)diamondPriceConfListElementClass {
    return [YFBDiamondInfo class];
}
@end


@implementation YFBDiamondManager
QBDefineLazyPropertyInitialization(NSMutableArray, diamondList)

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBDiamondResponse class];
}

+ (instancetype)manager {
    static YFBDiamondManager *_diamondModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _diamondModel = [[YFBDiamondManager alloc] init];
    });
    return _diamondModel;
}

- (void)getDiamondListCache {
    if (self.diamondList.count == 0) {
        [self fetchDiamondListWithCompletionHandler:^(BOOL success, NSArray <YFBDiamondInfo *> *obj) {
            if (success) {
                [self.diamondList addObjectsFromArray:obj];
            } else {
                [self performSelector:@selector(getDiamondListCache) withObject:nil afterDelay:30];
            }
        }];
    }
}

- (BOOL)fetchDiamondListWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_DIAMONLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBDiamondResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                            [[YFBApplePayManager manager] getProductionInfosWithType:kYFBProductionTypePurchaseKeyName];
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.diamondPriceConfList);
                        }
                    }];
    return success;
}

extern NSString *const kYFBPurchase100KeyName;
extern NSString *const kYFBPurchase158KeyName;
extern NSString *const kYFBPurchase300KeyName;
extern NSString *const kYFBPurchase500KeyName;
extern NSString *const kYFBPurchase1000KeyName;


- (void)changeDiamondPrice:(CGFloat)newPrice WithDiamondKeyName:(NSString *)diamondKeyName {
    NSInteger idx = 9999;
    if ([diamondKeyName isEqualToString:kYFBPurchase100KeyName]) {
        idx = 0;
    } else if ([diamondKeyName isEqualToString:kYFBPurchase158KeyName]) {
        idx = 1;
    } else if ([diamondKeyName isEqualToString:kYFBPurchase300KeyName]) {
        idx = 2;
    } else if ([diamondKeyName isEqualToString:kYFBPurchase500KeyName]) {
        idx = 3;
    } else if ([diamondKeyName isEqualToString:kYFBPurchase1000KeyName]) {
        idx = 4;
    }
    
    if (idx>=0 && idx <=5) {
        if (self.diamondList.count > idx) {
            YFBDiamondInfo *diamondInfo = self.diamondList[idx];
            diamondInfo.price = newPrice;
            diamondInfo.serverKeyName = diamondKeyName;
            [self.diamondList replaceObjectAtIndex:idx withObject:diamondInfo];
        }
    }
}

@end
