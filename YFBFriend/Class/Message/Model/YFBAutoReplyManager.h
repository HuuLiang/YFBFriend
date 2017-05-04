//
//  YFBAutoReplyManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBAutoReplyMessage : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger msgId;
@property (nonatomic) NSString *msgType;
@property (nonatomic) NSString *sendTime;
@end

@interface YFBRobotMsgModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger msgId;
@property (nonatomic) NSString *msgType;
@property (nonatomic) NSString *sendTime;
@end

@interface YFBRobotContactModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSArray <YFBRobotMsgModel *> *robotMsgList;
@end

@interface YFBAutoReplyResponse : QBURLResponse
@property (nonatomic) NSArray <YFBRobotContactModel *> *userList;
@property (nonatomic) NSInteger visitMeCount;
@end


@interface YFBAutoReplyManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)deleteYesterdayMessages;

- (void)getRobotReplyMessages;

- (void)getAutoReplyMessageWithUserId:(NSString *)userId;

- (void)saveRobotMessagesWith:(NSArray <YFBRobotContactModel *>*)userList;

- (void)startAutoRollingToReply;

@end
