//
//  YFBApplePayManager.h
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PayResultBlock)(YFBPayResult payResult);

@interface YFBApplePayManager : NSObject

+ (instancetype)manager;

- (void)getProductionInfosWithType:(NSString *)type;

- (void)payWithProductionId:(NSString *)productionId handler:(PayResultBlock)handler;

@end

extern NSString *const kYFBProductionTypeOpenVipKeyName;
extern NSString *const kYFBProductionTypePurchaseKeyName;


extern NSString *const kYFBOpenVipSliverKeyName;
extern NSString *const kYFBOpenVipGlodkeyName;

extern NSString *const kYFBPurchase100KeyName;
extern NSString *const kYFBPurchase158KeyName;
extern NSString *const kYFBPurchase300KeyName;
extern NSString *const kYFBPurchase500KeyName;
extern NSString *const kYFBPurchase1000KeyName;

