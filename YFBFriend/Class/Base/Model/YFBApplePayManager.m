//
//  YFBApplePayManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBApplePayManager.h"
#import <StoreKit/StoreKit.h>
#import "YFBPayConfigManager.h"
#import "YFBDiamondManager.h"

NSString *const kYFBProductionTypeOpenVipKeyName = @"OPEN_VIP";
NSString *const kYFBProductionTypePurchaseKeyName = @"PURCHASE_DIAMOND";

NSString *const kYFBOpenVipSliverKeyName         = @"VIP_90";
NSString *const kYFBOpenVipGlodkeyName           = @"VIP_90_90";

NSString *const kYFBPurchase100KeyName           = @"PURCHASE_DIAMOND_100";
NSString *const kYFBPurchase158KeyName           = @"PURCHASE_DIAMOND_158";
NSString *const kYFBPurchase300KeyName           = @"PURCHASE_DIAMOND_300";
NSString *const kYFBPurchase500KeyName           = @"PURCHASE_DIAMOND_500";
NSString *const kYFBPurchase1000KeyName          = @"PURCHASE_DIAMOND_1000";


@interface YFBApplePayManager () <SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic) PayResultBlock payResultHandler;
@end

@implementation YFBApplePayManager

+ (instancetype)manager {
    static YFBApplePayManager *_applePayManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _applePayManager = [[YFBApplePayManager alloc] init];
    });
    return _applePayManager;
}

- (void)getProductionInfosWithType:(NSString *)type {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments]) {
        NSSet * produtionInfos;
        if ([type isEqualToString:kYFBProductionTypeOpenVipKeyName]) {
            produtionInfos = [NSSet setWithArray:@[kYFBOpenVipSliverKeyName,kYFBOpenVipGlodkeyName]];
        } else if ([type isEqualToString:kYFBProductionTypePurchaseKeyName]) {
            produtionInfos = [NSSet setWithArray:@[kYFBPurchase100KeyName,kYFBPurchase158KeyName,kYFBPurchase300KeyName,kYFBPurchase500KeyName,kYFBPurchase1000KeyName]];
        }
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:produtionInfos];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        [[YFBHudManager manager] showHudWithText:@"请设置允许应用内购买"];
    }
}

- (void)payWithProductionId:(NSString *)productionId handler:(PayResultBlock)handler {
    self.payResultHandler = handler;
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = productionId;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"-------------myProduct-----------------%lu",(unsigned long)myProduct.count);
    NSLog(@"无效产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"--------------------");
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        if ([product.productIdentifier isEqualToString:kYFBOpenVipSliverKeyName]) {
            [YFBPayConfigManager manager].vipInfo.firstInfo.price = [product.price floatValue]*100;
            [YFBPayConfigManager manager].vipInfo.firstInfo.serverKeyName = kYFBOpenVipSliverKeyName;
        } else if ([product.productIdentifier isEqualToString:kYFBOpenVipGlodkeyName]) {
            [YFBPayConfigManager manager].vipInfo.secondInfo.price = [product.price floatValue]*100;
            [YFBPayConfigManager manager].vipInfo.secondInfo.serverKeyName = kYFBOpenVipGlodkeyName;
        } else {
            [[YFBDiamondManager manager] changeDiamondPrice:[product.price floatValue]*100 WithDiamondKeyName:product.productIdentifier];
        }
    }
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"pay out:%ld  id:%@",(long)transaction.transactionState,transaction.payment.productIdentifier);
        
        NSLog(@"%@",transaction.transactionIdentifier);
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"正在购买中");
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买完成");
                if (self.payResultHandler) {
                    self.payResultHandler(YFBPayResultSuccess);
                }
                break;

            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败");
                if (self.payResultHandler) {
                    self.payResultHandler(YFBPayResultFailed);
                }
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;

            case SKPaymentTransactionStateDeferred:
                NSLog(@"未知");
                if (self.payResultHandler) {
                    self.payResultHandler(YFBPayResultUnknow);
                }
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;

            default:
                break;
        }
        
    }
    
}


@end
