//
//  YFBPayUserModel.m
//  YFBFriend
//
//  Created by ylz on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayUserModel.h"

@implementation YFBPayUserModel

+ (YFBPayUserModel *)creatWithName:(NSString *)name text:(NSString *)text getCharge:(BOOL)getCharge; {
    YFBPayUserModel *model = [[YFBPayUserModel alloc] init];
    model.name = name;
    model.text = text;
    model.getCharge = getCharge;
    return model;
}

@end
