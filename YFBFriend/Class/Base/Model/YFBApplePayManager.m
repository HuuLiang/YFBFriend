//
//  YFBApplePayManager.m
//  YFBFriend
//
//  Created by Liang on 2017/6/29.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBApplePayManager.h"
#import <StoreKit/StoreKit.h>

NSString *const kYFBOpenVipGlodkeyName = @"OPEN_VIP_1";

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

- (void)getProductionInfos {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[@"YPB_VIP_1Month",@"YPB_VIP_3Month"]]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        [[YFBHudManager manager] showHudWithText:@"请设置允许应用内购买"];
    }
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    _priceArray = [[NSMutableArray alloc] init];
//    NSLog(@"-----------收到产品反馈信息--------------");
//    NSArray *myProduct = response.products;
//    NSLog(@"-------------myProduct-----------------%lu",(unsigned long)myProduct.count);
//    NSLog(@"无效产品Product ID:%@",response.invalidProductIdentifiers);
//    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
//    // populate UI
//    for(SKProduct *product in myProduct){
//        NSLog(@"--------------------");
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
//        [_priceArray addObject:product.price];
//    }
//    
//    [self setPriceInfoWithArray:_priceArray];

}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
}


@end
