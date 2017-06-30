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

static NSString *const kYFBOpenVipSliverKeyName         = @"VIP_90";
static NSString *const kYFBOpenVipGlodkeyName           = @"VIP_90_90";

static NSString *const kYFBPurchase100KeyName           = @"PURCHASE_DIAMOND_100";
static NSString *const kYFBPurchase158KeyName           = @"PURCHASE_DIAMOND_158";
static NSString *const kYFBPurchase300KeyName           = @"PURCHASE_DIAMOND_300";
static NSString *const kYFBPurchase500KeyName           = @"PURCHASE_DIAMOND_500";
static NSString *const kYFBPurchase1000KeyName          = @"PURCHASE_DIAMOND_1000";


@interface YFBApplePayManager () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

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
        if ([type isEqualToString:kYFBPayConfigTypeVipKeyName]) {
            produtionInfos = [NSSet setWithArray:@[kYFBOpenVipSliverKeyName,kYFBOpenVipGlodkeyName]];
        } else if ([type isEqualToString:kYFBPayConfigTypeDiamondKeyName]) {
            produtionInfos = [NSSet setWithArray:@[kYFBPurchase100KeyName,kYFBPurchase158KeyName,kYFBPurchase300KeyName,kYFBPurchase500KeyName,kYFBPurchase1000KeyName]];
        }
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:produtionInfos];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        [[YFBHudManager manager] showHudWithText:@"请设置允许应用内购买"];
    }
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
            [YFBPayConfigManager manager].vipInfo.firstInfo.price = [product.price floatValue];
//            [YFBPayConfigManager manager].vipInfo.firstInfo.amount = product
        } else if ([product.productIdentifier isEqualToString:kYFBOpenVipGlodkeyName]) {
            
        } else if ([product.productIdentifier isEqualToString:kYFBPurchase100KeyName]) {
            
        } else if ([product.productIdentifier isEqualToString:kYFBPurchase158KeyName]) {
            
        } else if ([product.productIdentifier isEqualToString:kYFBPurchase300KeyName]) {
            
        } else if ([product.productIdentifier isEqualToString:kYFBPurchase500KeyName]) {
            
        } else if ([product.productIdentifier isEqualToString:kYFBPurchase1000KeyName]) {
            
        }
    }
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
}


@end
