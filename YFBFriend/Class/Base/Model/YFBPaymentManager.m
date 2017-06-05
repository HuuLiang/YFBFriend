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

@implementation YFBPaymentInfo

+ (YFBPaymentInfo *)createPaymentInfoWithOrderId:(NSString *)orderId
                                       payAction:(NSString *)payAction
                                         payType:(YFBPayType)payType
                                        payPrice:(NSUInteger)payPrice
                                        payCount:(NSUInteger)payCount
                                       payMethod:(NSString *)payMethod {
    YFBPaymentInfo *paymentInfo = [[YFBPaymentInfo alloc] init];
    paymentInfo.payOrderId = orderId;
    paymentInfo.payAction = payAction;
    paymentInfo.payType = payType;
    paymentInfo.payPrice = payPrice;
    paymentInfo.payCount = payCount;
    paymentInfo.payMethod = payMethod;
    paymentInfo.payResult = YFBPayResultUnknow;
    [paymentInfo saveOrUpdate];
    return paymentInfo;
}

@end


@interface YFBPaymentManager()
@property (nonatomic) YFBPaymentInfo *paymentInfo;
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
    
    NSString *payMethod = nil;
    switch (payType) {
        case YFBPayTypeAliPay:
            payMethod = kYFBPaymentMethodAliKeyName;
            break;
            
        case YFBPayTypeWeiXin:
            payMethod = kYFBPaymentMethodWXKeyName;
            break;
            
        default:
            break;
    }
    
    self.paymentInfo = [YFBPaymentInfo createPaymentInfoWithOrderId:YFB_PAYMENT_ORDERID
                                                                     payAction:action
                                                                       payType:payType
                                                                      payPrice:price
                                                                      payCount:count
                                                                     payMethod:payMethod];
#ifdef DEBUG
    _paymentInfo.payPrice = 1;
#endif
    
    if (payType == YFBPayTypeAliPay) {
        [[AlipayManager shareInstance] startAlipay:_paymentInfo.payOrderId
                                             price:_paymentInfo.payPrice
                                        withResult:^(YFBPayResult result, Order *order)
        {
            if (handler) {
                handler(result == YFBPayResultSuccess);
            }
            [self commitOrderInfoandnotiPayResult:result];
        }];
    } else if (payType == YFBPayTypeWeiXin) {
        [[WeChatPayManager sharedInstance] startWeChatPayWithOrderNo:_paymentInfo.payOrderId
                                                               price:_paymentInfo.payPrice
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
    _paymentInfo.payResult = result;
    
    [_paymentInfo saveOrUpdate];
    
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
            payStatus = kYFBPaymentStatusCancleKeyName;
            [[YFBHudManager manager] showHudWithText:@"支付取消"];
            break;
            
        default:
            break;
    }
    
    NSString *payCountKeyName;
    
    if ([_paymentInfo.payAction isEqualToString:kYFBPaymentActionOpenVipKeyName]) {
        payCountKeyName = @"days";
    } else if ([_paymentInfo.payAction isEqualToString:kYFBPaymentActionPURCHASEDIAMONDKeyName]) {
        payCountKeyName = @"amount";
    }
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"orderNo":_paymentInfo.payOrderId,
                             @"payAction":_paymentInfo.payAction,
                             @"payStatus":payStatus,
                             @"payMethod":_paymentInfo.payMethod,
                             @"price":@(_paymentInfo.payPrice),
                             payCountKeyName:@(_paymentInfo.payCount)};
    
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
