//
//  YFBPayUserCountUtil.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayUserCountUtil.h"

static NSString *const kPayVipUserCountKey = @"k_yfb_pay_vip_user_count_key";

@interface YFBPayUserCountUtil ()


@end

@implementation YFBPayUserCountUtil

- (NSInteger)fetchPayVipUserCountWithIsDredge:(BOOL)IsDredge{
    NSString *key = @"payMoney";
    if (IsDredge) {
        key = @"dredgeVip";
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *payDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:kPayVipUserCountKey]];
    if (![payDict.allKeys containsObject:key]) {
        NSInteger random1 = arc4random_uniform(1000);
        NSInteger random2 = arc4random_uniform(80) + 10;
        random1 = random2 *10000 + random1;
        [payDict setObject:@(random1) forKey:key];
        [defaults setObject:payDict forKey:kPayVipUserCountKey];
        [defaults synchronize];
    }
    NSInteger payCount = [payDict[key] integerValue];
    
    return payCount;
}



@end
