//
//  YFBRegisterUserModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBRegisterUserResponse : QBURLResponse

@end

@interface YFBRegisterUserModel : QBEncryptedURLRequest

- (BOOL)registerUserWithUserInfo:(YFBUser *)user CompletionHandler:(QBCompletionHandler)handler;

@end
