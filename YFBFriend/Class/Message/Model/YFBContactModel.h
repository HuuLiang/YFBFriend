//
//  YFBContactModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBRobotMsgModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *msgId;
@property (nonatomic) NSString *msgType;
@property (nonatomic) NSString *sendTime;
@end

@interface YFBContactUserModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSArray <YFBRobotMsgModel *> *robotMsgList;
@end

@interface YFBContactResponse : QBURLResponse
@property (nonatomic) NSArray <YFBContactUserModel *> *userList;
@property (nonatomic) NSInteger visitMeCount;
@end

@interface YFBContactModel : QBEncryptedURLRequest
- (BOOL)fetchContactInfoWithCompletionHandler:(QBCompletionHandler)handler;
@end
