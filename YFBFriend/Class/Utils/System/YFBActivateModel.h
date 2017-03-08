//
//  YFBActivateModel.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^YFBActivateHandler)(BOOL success, NSString *uuid);

@interface YFBActivate : QBURLResponse
@property (nonatomic) NSString *uuid;

@end

@interface YFBActivateModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(YFBActivateHandler)handler;

@end
