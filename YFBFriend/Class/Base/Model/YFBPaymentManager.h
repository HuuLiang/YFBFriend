//
//  YFBPaymentManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBPaymentManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)payForAction:(NSString *)action WithPayType:(YFBPayType)payType price:(NSInteger)price count:(NSInteger)count handler:(void(^)(BOOL success))handler;

@end

extern NSString *const kYFBPaymentActionOpenVipKeyName;
extern NSString *const kYFBPaymentActionPURCHASEDIAMONDKeyName;

extern NSString *const kYFBPaymentStatusSucessKeyName;
extern NSString *const kYFBPaymentStatusCancleKeyName;
extern NSString *const kYFBPaymentStatusFailedKeyName;

extern NSString *const kYFBPaymentMethodAliKeyName;
extern NSString *const kYFBPaymentMethodWXKeyName;
