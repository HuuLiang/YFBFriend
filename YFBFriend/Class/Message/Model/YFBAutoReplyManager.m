//
//  YFBAutoReplyManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAutoReplyManager.h"

@implementation YFBAutoReplyMessage
@end

@implementation YFBRobotMsgModel
@end

@implementation YFBRobotContactModel
- (Class)robotMsgListElementClass {
    return [YFBRobotMsgModel class];
}
@end

@implementation YFBAutoReplyResponse
- (Class)userListElementClass {
    return [YFBRobotContactModel class];
}
@end

@implementation YFBAutoReplyManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBAutoReplyResponse class];
}


+ (instancetype)manager {
    static YFBAutoReplyManager *_autoReplyManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _autoReplyManager = [[YFBAutoReplyManager alloc] init];
    });
    return _autoReplyManager;
}

- (void)deleteYesterdayMessages {
    //删除数据库中不是今天的数据
    if (![YFBUtil isFirstDay]) {
        [YFBAutoReplyMessage deleteObjectsByCriteria:[NSString stringWithFormat:@"where messageTime!=\'%@\'",[YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatShortest]]];
    }
}

- (void)getRobotReplyMessages {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    [self requestURLPath:YFB_MSGLIST_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
     {
         YFBAutoReplyResponse *resp = nil;
         if (respStatus == QBURLResponseSuccess) {
             resp = self.response;
             [self saveRobotMessagesWith:resp.userList];
         }
     }];
    
}

- (void)getAutoReplyMessageWithUserId:(NSString *)userId {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"userIdStr":userId};
    [self requestURLPath:YFB_GETMSGLIST_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBAutoReplyResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [self saveRobotMessagesWith:resp.userList];
        }
    }];
}

- (void)saveRobotMessagesWith:(NSArray <YFBRobotContactModel *>*)userList {
    [userList enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(YFBRobotContactModel * _Nonnull contactRobot, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [contactRobot.robotMsgList enumerateObjectsWithOptions:NSEnumerationConcurrent
                                                     usingBlock:^(YFBRobotMsgModel * _Nonnull robotMsg, NSUInteger idx, BOOL * _Nonnull stop)
          {
              YFBAutoReplyMessage *autoReplyMessage = [YFBAutoReplyMessage findFirstByCriteria:[NSString stringWithFormat:@"where msgId=%ld",robotMsg.msgId]];
              if (!autoReplyMessage) {
                  YFBAutoReplyMessage *autoReplyMessage = [[YFBAutoReplyMessage alloc] init];
                  autoReplyMessage.userId = contactRobot.userId;
                  autoReplyMessage.nickName = contactRobot.nickName;
                  autoReplyMessage.portraitUrl = contactRobot.portraitUrl;
                  autoReplyMessage.content = robotMsg.content;
                  autoReplyMessage.msgId = robotMsg.msgId;
                  autoReplyMessage.msgType = robotMsg.msgType;
                  autoReplyMessage.sendTime = robotMsg.sendTime;
                  [autoReplyMessage saveOrUpdate];
              }
          }];
     }];
}

@end
