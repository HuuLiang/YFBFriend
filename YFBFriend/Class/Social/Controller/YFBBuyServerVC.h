//
//  YFBBuyServerVC.h
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBBuyServerVC : YFBBaseViewController

+ (void)showSocialPaymentViewControllerWithInfo:(NSArray *)paymentInfo userId:(NSString *)userId InCurrentVC:(UIViewController *)currentViewController;



@end
