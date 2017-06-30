//
//  YFBSystemConfigManager.h
//  YFBFriend
//
//  Created by Liang on 2017/6/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBSystemConfig : NSObject
@property (nonatomic) NSString *SEX_SWITCH;
@end


@interface YFBSystemConfigResponse : QBURLResponse
@property (nonatomic) YFBSystemConfig *config;
@end

@interface YFBSystemConfigManager : QBEncryptedURLRequest

@property (nonatomic) NSString *SEX_SWITCH;

+ (instancetype)manager;

- (void)getSystemConfigInfo;

@end
