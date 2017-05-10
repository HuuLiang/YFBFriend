//
//  YFBContactManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactManager.h"

@implementation YFBContactModel

@end


@implementation YFBContactManager

+ (instancetype)manager {
    static YFBContactManager *_contactManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _contactManager = [[YFBContactManager alloc] init];
    });
    return _contactManager;
}

- (NSArray <YFBContactModel *> *)loadAllContactInfo {
    NSArray *allContacts = [YFBContactModel findAll];
    return allContacts;
}

- (YFBContactModel *)findContactInfoWithUserId:(NSString *)userId {
    YFBContactModel *contactModel = [YFBContactModel findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (!contactModel) {
        contactModel = [[YFBContactModel alloc] init];
    }
    return contactModel;
}

- (void)deleteAllPreviouslyContactInfo {
    [[self loadAllContactInfo] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[YFBUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong] isToday]) {
            obj.messageTime = @"";
            obj.messageContent = @"";
        }
    }];
}

@end
