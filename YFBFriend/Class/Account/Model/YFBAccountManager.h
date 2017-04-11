//
//  YFBAccountManager.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SendAuthResp;

@interface YFBAccountManager : NSObject

+ (instancetype)manager;

- (void)loginWithQQ;

- (void)loginWithWX;

- (void)loginWithAccountAndPassword;

- (void)sendAuthRespCode:(SendAuthResp *)resp;

@end
