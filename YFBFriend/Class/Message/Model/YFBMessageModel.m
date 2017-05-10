//
//  YFBMessageModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageModel.h"

@implementation YFBMessageModel

+ (NSArray<YFBMessageModel *> *)allMessagesWithUserId:(NSString *)userId {
    return [self findByCriteria:[NSString stringWithFormat:@"WHERE sendUserId=\'%@\' or receiveUserId=\'%@\'",userId,userId]];
}

+ (void)deleteAllPreviouslyMessages {
    [[YFBMessageModel findAll] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBMessageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[YFBUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong] isToday]) {
            [obj deleteObject];
        }
    }];
}

@end
