//
//  YFBInteractionManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBInteractionManager.h"
#import "YFBGreetingModel.h"
#import "YFBRobot.h"

@interface YFBInteractionManager ()
@property (nonatomic,retain) YFBGreetingModel *greetModel;
@end

@implementation YFBInteractionManager
QBDefineLazyPropertyInitialization(YFBGreetingModel, greetModel)

+ (instancetype)manager {
    static YFBInteractionManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBInteractionManager alloc] init];
    });
    return _manager;
}

- (void)greetWithUserInfoList:(NSArray<YFBRobot *> *)userList handler:(void (^)(BOOL * success))handler {
    [self.greetModel fetchGreetingInfoWithUserIdStr:userList CompletionHandler:^(BOOL success, id obj) {
        QBSafelyCallBlock(handler,&success);
    }];
}

@end
