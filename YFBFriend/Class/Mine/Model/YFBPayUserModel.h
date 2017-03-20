//
//  YFBPayUserModel.h
//  YFBFriend
//
//  Created by ylz on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBPayUserModel : NSObject


@property (nonatomic) NSString *name;
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL getCharge;//获得话费
+ (YFBPayUserModel *)creatWithName:(NSString *)name text:(NSString *)text getCharge:(BOOL)getCharge;

@end
