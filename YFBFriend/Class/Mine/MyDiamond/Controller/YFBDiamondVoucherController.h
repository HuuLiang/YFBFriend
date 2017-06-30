//
//  YFBDiamondVoucherController.h
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBDiamondVoucherController : YFBBaseViewController

+ (void)showDiamondVoucherVCWithPrice:(CGFloat)price diamond:(NSInteger)diamond action:(NSString *)payAction serverKeyName:(NSString *)serverKeyName InCurrentVC:(UIViewController *)currentViewController;

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond;

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond Action:(NSString *)payAction;

@end
