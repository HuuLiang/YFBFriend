//
//  YFBSystemConfigModel.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "YFBSystemConfig.h"

@interface YFBSystemConfigResponse : QBURLResponse
@property (nonatomic,retain) NSArray<YFBSystemConfig *> *configs;
@end

typedef void (^YFBFetchSystemConfigCompletionHandler)(BOOL success);

@interface YFBSystemConfigModel : QBEncryptedURLRequest

@property (nonatomic) NSInteger vipPriceA;
@property (nonatomic) NSInteger vipPriceB;
@property (nonatomic) NSInteger vipPriceC;

@property (nonatomic) NSInteger vipMonthA;
@property (nonatomic) NSInteger vipMonthB;
@property (nonatomic) NSInteger vipMonthC;

@property (nonatomic) NSString *imageToken;
@property (nonatomic,readonly) BOOL loaded;
//qq客服
@property (nonatomic) NSString *contactScheme;
@property (nonatomic) NSString *contactName;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(YFBFetchSystemConfigCompletionHandler)handler;

@end
