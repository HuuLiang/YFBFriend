//
//  YFBRobot.h
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUser.h"

@interface YFBRobot : YFBUser

@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,assign) BOOL greeted;


@end
