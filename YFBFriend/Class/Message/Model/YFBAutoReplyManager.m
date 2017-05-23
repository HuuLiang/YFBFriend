//
//  YFBAutoReplyManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAutoReplyManager.h"
#import "YFBMessageModel.h"
#import "YFBContactManager.h"
#import "YFBContactView.h"

static NSString *const kYFBFriendGetRobotReplyMessageKeyName = @"kYFBFriendGetRobotReplyMessageKeyName";

static const NSUInteger kRollingTimeInterval = 5;

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

@interface YFBAutoReplyManager ()
@property (nonatomic,retain) dispatch_queue_t replyQueue;
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
    if(![YFBUtil isToday]) {
        [YFBAutoReplyMessage deleteObjectsByCriteria:[NSString stringWithFormat:@"where messageTime!=\'%@\'",[YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatShortest]]];
        [YFBMessageModel deleteAllPreviouslyMessages];
    }
}

- (void)getRobotReplyMessages {
    if (![YFBUtil isVip] && [YFBUser currentUser].diamondCount == 0) {
        if (![YFBUtil isToday]) {
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kYFBFriendGetRobotReplyMessageKeyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSInteger getReplyMsgCount = [[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendGetRobotReplyMessageKeyName] integerValue];
        if (getReplyMsgCount < 3) {
            getReplyMsgCount++;
            [[NSUserDefaults standardUserDefaults] setObject:@(getReplyMsgCount) forKey:kYFBFriendGetRobotReplyMessageKeyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            return;
        }
    }
    
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
             [self performSelector:@selector(getRobotReplyMessages) withObject:nil afterDelay:60*10];
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
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];

    [userList enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(YFBRobotContactModel * _Nonnull contactRobot, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (idx == 0) {
             timeInterval = 30 + timeInterval;//30秒以后开始回复 初始化回复时间
         }
         
         [contactRobot.robotMsgList enumerateObjectsWithOptions:NSEnumerationConcurrent
                                                     usingBlock:^(YFBRobotMsgModel * _Nonnull robotMsg, NSUInteger idx, BOOL * _Nonnull stop)
          {
              timeInterval += arc4random() % 4 + 4;
              YFBAutoReplyMessage *autoReplyMessage = [YFBAutoReplyMessage findFirstByCriteria:[NSString stringWithFormat:@"where msgId=%ld",robotMsg.msgId]];
              if (!autoReplyMessage) {
                  YFBAutoReplyMessage *autoReplyMessage = [[YFBAutoReplyMessage alloc] init];
                  autoReplyMessage.userId = contactRobot.userId;
                  autoReplyMessage.nickName = contactRobot.nickName;
                  autoReplyMessage.portraitUrl = contactRobot.portraitUrl;
                  autoReplyMessage.content = robotMsg.content;
                  autoReplyMessage.msgId = robotMsg.msgId;
                  autoReplyMessage.msgType = robotMsg.msgType;
                  autoReplyMessage.age = contactRobot.age;
                  autoReplyMessage.height = contactRobot.height;
                  autoReplyMessage.gender = contactRobot.gender;
                  autoReplyMessage.replyTime = timeInterval;
                  autoReplyMessage.replyed = NO;
                  [autoReplyMessage saveOrUpdate];
              }
          }];
     }];
}

//获取所有的自动回复信息
- (NSArray <YFBAutoReplyMessage *>*)findAllAutoReplyMessages {
    NSArray *array = [YFBAutoReplyMessage findByCriteria:[NSString stringWithFormat:@"where replyed=0 order by replyTime asc"]];
    if (array.count > 0) {
        return array;
    }
    return nil;
}


- (void)startAutoRollingToReply {
    if (self.replyQueue) {
        return;
    }
    self.replyQueue = dispatch_queue_create("YFBFriend.AutoReply.Queue", nil);
    [self rollingReplayMessages];
}

- (void)rollingReplayMessages {
    if (![[UIApplication sharedApplication].keyWindow.rootViewController isBeingPresented]) {
        dispatch_async(self.replyQueue, ^{
            
            __block uint nextRollingReplyTime = kRollingTimeInterval;
            
            NSArray *array = [self findAllAutoReplyMessages];
            
            
            [array enumerateObjectsUsingBlock:^(YFBAutoReplyMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
                if (obj.replyTime <= currentTimeInterval) {
                    //向聊天详情中插入一条记录
                    YFBMessageModel *msgModel = [[YFBMessageModel alloc] init];
                    msgModel.sendUserId = obj.userId;
                    msgModel.receiveUserId = [YFBUser currentUser].userId;
                    msgModel.messageTime = [YFBUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.replyTime] WithDateFormat:KDateFormatLong];
                    msgModel.messageType = [obj.msgType integerValue];
                    msgModel.content = obj.content;
                    msgModel.nickName = obj.nickName;
                    [msgModel saveOrUpdate];
                    
                    //向消息记录中插入一条最近消息
                    YFBContactModel *contact =  [YFBContactModel findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=\'%@\'",obj.userId]];
                    if (!contact) {
                        contact = [[YFBContactModel alloc] init];
                        contact.userId = obj.userId;
                        contact.portraitUrl = obj.portraitUrl;
                        contact.nickName = obj.nickName;
                        contact.messageTime = [YFBUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.replyTime] WithDateFormat:KDateFormatLong];
                        contact.messageType = [obj.msgType integerValue];
                    }
                    if ([obj.msgType integerValue] == YFBMessageTypePhoto) {
                        contact.messageContent = [NSString stringWithFormat:@"%@向您发送了一张图片",obj.nickName];
                    } else {
                        contact.messageContent = obj.content;
                    }
                    contact.unreadMsgCount += 1;
                    [contact saveOrUpdate];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBFriendShowMessageNotification object:obj];
                    
                    //标记已经回复过的缓存
                    obj.replyed = YES;
                    [obj saveOrUpdate];
                    
                    //向消息界面发出通知更改角标数字
                    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateContactUnReadMessageNotification object:obj];
                } else {
                    NSTimeInterval nextTime = obj.replyTime - [[NSDate date] timeIntervalSince1970];
                    if (nextTime < nextRollingReplyTime) {
                        nextRollingReplyTime = nextTime;
                    }
                    QBLog(@"下次循环推送时间 %d",nextRollingReplyTime);
                }
            }];
            
            QBLog(@"回复池数量%ld 下次循环推送时间 %d",array.count,nextRollingReplyTime);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                sleep(nextRollingReplyTime);
                [self rollingReplayMessages];
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            sleep(2);
            [self rollingReplayMessages];
        });
    }
}

@end
