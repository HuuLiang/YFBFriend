//
//  YFBUser.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBUser : NSObject <NSCoding>

+ (instancetype)currentUser;

//用户ID
@property (nonatomic,copy) NSString *userId;


- (void)saveOrUpdate;

@end
