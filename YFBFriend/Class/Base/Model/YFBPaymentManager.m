//
//  YFBPaymentManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPaymentManager.h"
#import "AlipayManager.h"
#import "WeChatPayManager.h"
#import "YFBDetailManager.h"

NSString *const kYFBPaymentActionOpenVipKeyName             = @"OPEN_VIP";
NSString *const kYFBPaymentActionPURCHASEDIAMONDKeyName     = @"PURCHASE_DIAMOND";

NSString *const kYFBPaymentStatusSucessKeyName              = @"FR_PAY_SUCC";
NSString *const kYFBPaymentStatusCancleKeyName              = @"FR_PAY_CANCEL";
NSString *const kYFBPaymentStatusFailedKeyName              = @"FR_PAY_FAIL";

NSString *const kYFBPaymentMethodAliKeyName                 = @"FR_ALIPAY";
NSString *const kYFBPaymentMethodWXKeyName                  = @"FR_WEIXIN";

@interface YFBPaymentManager()
@property (nonatomic) NSString *payOrderNo;
@property (nonatomic) NSString *payAction;
@property (nonatomic) NSInteger payPrice;
@property (nonatomic) NSInteger payCount;
@property (nonatomic) NSString *payMethod;
@end

@implementation YFBPaymentManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (instancetype)manager {
    static YFBPaymentManager *_paymentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _paymentManager = [[YFBPaymentManager alloc] init];
    });
    return _paymentManager;
}

- (void)payForAction:(NSString *)action WithPayType:(YFBPayType)payType price:(NSInteger)price count:(NSInteger)count handler:(void(^)(BOOL success))handler {
    self.payAction = action;
    self.payOrderNo = YFB_PAYMENT_ORDERID;
    self.payPrice = price;
    self.payCount = count;
    
    switch (payType) {
        case YFBPayTypeAliPay:
            self.payMethod = kYFBPaymentMethodAliKeyName;
            break;
            
        case YFBPayTypeWeiXin:
            self.payMethod = kYFBPaymentMethodWXKeyName;
            break;
            
        default:
            break;
    }
    
    _payPrice = 1;
    
    if (payType == YFBPayTypeAliPay) {
        [[AlipayManager shareInstance] startAlipay:_payOrderNo
                                             price:_payPrice
                                        withResult:^(YFBPayResult result, Order *order)
        {
            if (handler) {
                handler(result == YFBPayResultSuccess);
            }
            [self commitOrderInfoandnotiPayResult:result];
        }];
    } else if (payType == YFBPayTypeWeiXin) {
        [[WeChatPayManager sharedInstance] startWeChatPayWithOrderNo:_payOrderNo
                                                               price:_payPrice
                                                   completionHandler:^(YFBPayResult result)
        {
            if (handler) {
                handler(result == YFBPayResultSuccess);
            }
            [self commitOrderInfoandnotiPayResult:result];
        }];
    }
}

- (void)commitOrderInfoandnotiPayResult:(YFBPayResult)result {
    NSString *payStatus;
    switch (result) {
        case YFBPayResultSuccess:
            payStatus = kYFBPaymentStatusSucessKeyName;
            [[YFBHudManager manager] showHudWithText:@"支付成功"];
            
            break;
            
        case YFBPayResultFailed:
            payStatus = kYFBPaymentStatusFailedKeyName;
            [[YFBHudManager manager] showHudWithText:@"支付失败"];
            break;
            
        case YFBPayResultCancle:
            payStatus = kYFBPaymentStatusFailedKeyName;
            [[YFBHudManager manager] showHudWithText:@"支付取消"];
            break;
            
        default:
            break;
    }
    
    NSString *payCountKeyName;
    
    if ([_payAction isEqualToString:kYFBPaymentActionOpenVipKeyName]) {
        payCountKeyName = @"days";
    } else if ([_payAction isEqualToString:kYFBPaymentActionPURCHASEDIAMONDKeyName]) {
        payCountKeyName = @"amount";
    }
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"orderNo":_payOrderNo,
                             @"payAction":_payAction,
                             @"payStatus":payStatus,
                             @"payMethod":_payMethod,
                             @"price":@(_payPrice),
                             payCountKeyName:@(_payCount)};
    
    [self requestURLPath:YFB_UPDATEORDER_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
     {
         if (respStatus == QBURLResponseSuccess) {
             QBLog(@"订单上传成功");
             if (result == YFBPayResultSuccess) {
                 [[YFBDetailManager manager] fetchDetailInfoWithUserId:[YFBUser currentUser].userId CompletionHandler:^(BOOL success, YFBUserLoginModel * obj) {
                     if (success) {
                         [YFBUser currentUser].diamondCount = obj.userBaseInfo.myDiamonds;
                         [YFBUser currentUser].expireTime = obj.userBaseInfo.vipExpireDate;
                         [[YFBUser currentUser] saveOrUpdateUserInfo];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                         [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                     }
                 }];
             }
         }
     }];
}

@end
