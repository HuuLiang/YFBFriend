//
//  JYPaymentViewController.h
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYPaymentViewController : JYBaseViewController

//- (instancetype)initWithBaseModel:(QBBaseModel *)baseModel;

- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;
- (void)payForWithVipLevel:(JYVipType)vipType price:(NSInteger)price;

@end
