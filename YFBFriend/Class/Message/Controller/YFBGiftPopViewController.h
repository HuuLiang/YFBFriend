//
//  YFBGiftPopViewController.h
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"


@interface YFBGiftPopViewController : YFBBaseViewController

+ (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController;

- (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController;

- (void)hide;


@end
