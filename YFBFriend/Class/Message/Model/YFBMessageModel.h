//
//  YFBMessageModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, YFBMessageType) {
    JYMessageTypeText = 1,      //文字消息
    JYMessageTypePhoto = 2,     //图片消息
    JYMessageTypeVioce = 3,     //声音消息
    JYMessageTypeEmotion = 4,   //表情消息
    JYMessageTypeNormal = 5,    //未开通VIP
    JYMessageTypeVIP = 6,       //开通VIP
    JYMessageTypeCount
};


@interface YFBMessageModel : JKDBModel
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSString *messageTime;
@property (nonatomic) YFBMessageType messageType;

+ (NSArray <YFBMessageModel *>*)allMessagesWithUserId:(NSString *)userId;

@end
