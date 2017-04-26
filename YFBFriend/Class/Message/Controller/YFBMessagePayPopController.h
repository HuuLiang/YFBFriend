//
//  YFBMessagePayPopController.h
//  YFBFriend
//
//  Created by ylz on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBMessagePayPopController : YFBBaseViewController

+ (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC;

- (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC;

- (void)hide;

@end
