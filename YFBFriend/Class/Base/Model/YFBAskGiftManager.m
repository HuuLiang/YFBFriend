//
//  YFBAskGiftManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAskGiftManager.h"
#import "YFBGiftPopViewController.h"


@implementation YFBAskGiftManager

+ (instancetype)manager {
    static YFBAskGiftManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBAskGiftManager alloc] init];
    });
    return _manager;
}

- (void)getUserInfo {
    
}

- (void)popAskGiftView {
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [YFBGiftPopViewController showGiftViewInCurrentViewController:currentVC isMessagePop:NO];
}


@end
