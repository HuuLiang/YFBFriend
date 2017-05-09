//
//  YFBConfiguration.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBConfiguration : NSObject

@property (nonatomic,readonly) NSString *channelNo;

+ (instancetype)sharedConfig;
+ (instancetype)sharedStandbyConfig;


@end
