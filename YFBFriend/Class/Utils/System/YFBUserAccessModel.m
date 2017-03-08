//
//  YFBUserAccessModel.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUserAccessModel.h"

@implementation YFBUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static YFBUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[YFBUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [YFBUtil UUID];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:YFB_ACCESS_URL
                          withParams:@{@"userId":userId,@"accessId":[YFBUtil accessId]}
                     responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    BOOL success = NO;
                    if (respStatus == QBURLResponseSuccess) {
                        NSString *resp = self.response;
                        success = [resp isEqualToString:@"SUCCESS"];
                        if (success) {
                            QBLog(@"Record user access!");
                        }
                    }
                }];
    return ret;
}


@end
