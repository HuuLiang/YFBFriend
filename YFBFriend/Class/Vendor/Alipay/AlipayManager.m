//
//  AlipayManager.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "AlipayManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


static AlipayManager *alipayManager;

@interface AlipayManager ()
@property (nonatomic,copy) AlipayResultBlock resultBlock;
@property (nonatomic,retain) Order *payOrder;
@end

@implementation AlipayManager
{
}



#pragma mark - shareInstance
+ (AlipayManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        alipayManager = [[AlipayManager alloc] init];
    });
    return alipayManager;
}



#pragma mark -  function
/*!
 *	@brief 支付宝支付接口
 *  @param orderId  订单的id ，在调用创建订单之后服务器会返回该订单的id
 *  @param price    商品价格
 *  @result
 */
- (void)startAlipay:(NSString *)_orderId price:(NSUInteger)_price withResult:(AlipayResultBlock)resultBlock
{
    self.resultBlock = resultBlock;
    
//    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
//    if (!appName) {
//        appName = @"家庭影院";
//    }
//    
    Order *order = [[Order alloc] init];
    order.partner       = @"2088121511256613";
    order.seller        = @"wuyp@iqu8.cn";
    
    order.tradeNO       = _orderId;         //订单ID（由商家自行制定）
    order.productName   = @"商品标题"; //商品标题
    order.productDescription = YFB_PAYMENT_RESERVE_DATA; //商品描述
    order.amount        = [NSString stringWithFormat:@"%.2f", _price/100.];           //商品价格
    order.notifyURL     =  @"http://phas.ayyygs.com/pd-has/notifyByAlipay.json"; //回调URL
    
    order.service       = @"mobile.securitypay.pay";
    order.paymentType   = @"1";
    order.inputCharset  = @"utf-8";
    order.itBPay        = @"30m";
    order.showUrl       = @"m.alipay.com";
    
    
    
    
    NSString *orderInfo = [order description];
    NSString *appScheme = kYFBFriendAliPaySchemeUrl;
//
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer   = CreateRSADataSigner(@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMXv/hpnzbA3rO/P5KJKatb3NugTw965VYzcdEFyv38iIpMA3io7/kEcuMRGMDQ0VQJgNaF8/sHDu/j/+NPSDBzeOKtsqVsZoY5jKK1K43LujAYz2v8lvNLkFcaFoUhfMXHhxNnoHNtGXIadhHFK+v2a1l3YCZiP5XJ3rQo1FbrBAgMBAAECgYA4XFbJZAdQhvnqKxMaFwCHB0uOF5qtP66Zdmhv/mGCrNCVdSjNc9m45pnB4Y52PvR5wbVjrzjHKZnLk+9hOS0TRkbOmiuCfxB2doB3YMeGlgo+rPSUL0Ey5WKF8+IJvImQfgf8kgJlU/7RPeAtfY+pmxY9PvbULHKGS5q8KHXLFQJBAPtJ0S1idGtnRXX8f2+I7aqmxnH3QwVtU2DhN++l6n+XIEWmNgvVJoLY/bdtK84lKZl9nJw3hSVZ6C6qN1F7up8CQQDJphduiRVezGSR0ofcOBwT/jTxynovFH4zhdWLu/4f3p9fHvKFqYqdgv8Z5lUr4W6Bga+k0hLuqGvJjXAyI+6fAkAvHqNjsD+GWEIVIri+sF1oj4dMnYHqxZpJ41F61ZDIRg1eIhGmXFyxUoEY4RbCvAM17fDs9hg4bch036Qp2lqfAkBj9VByO8P7LSjBXHJ6iNnqUz4dibhNtEPm+HXmAbe0RqAMAARKm8OZ1wDr7tDTorkru4S9GGHIKnbb/5/ZSxSTAkB+cIT779yzXIVZYNj8Q2C+FMiHdUrw9OVikW6nKRcIlJJMBQfPzvjfR5ux0NVi1CM76hl5C4f4GSKFgM7AYXwX");
    NSString *signedString  = [signer signString:orderInfo];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderInfo, signedString, @"RSA"];
        
        self.payOrder = order;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        {
            [self sendNotificationByResult:resultDic];
        }];
    }
    
}


- (void)sendNotificationByResult:(NSDictionary *)_resultDic
{
    QBLog(@"支付宝返回的result : %@" , _resultDic);
    YFBPayResult payResult = YFBPayResultFailed;
    //用户放弃付款的情况  6001
    if([[_resultDic allKeys] containsObject:@"resultStatus"])
    {
        NSString * resultStatues  = _resultDic[@"resultStatus"];
        if([resultStatues isEqualToString:@"6001"]) {
            payResult = YFBPayResultCancle;
        } else if ([resultStatues isEqualToString:@"9000"]) {
            payResult = YFBPayResultSuccess;
        } else {
            payResult = YFBPayResultFailed;
        }
    }
    
    if (self.resultBlock) {
        self.resultBlock(payResult, self.payOrder);
    }
}

@end
