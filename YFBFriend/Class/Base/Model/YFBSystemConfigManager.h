//
//  YFBSystemConfigManager.h
//  YFBFriend
//
//  Created by Liang on 2017/6/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>


@interface YFBSystemConfig : QBURLResponse

@end

@interface YFBSystemConfigManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)getSystemConfigInfo;

@end
