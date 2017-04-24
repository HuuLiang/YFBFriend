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
    YFBMessageTypeText = 1,      //文字消息
    YFBMessageTypePhoto = 2,     //图片消息
    YFBMessageTypeGift = 3,     //礼物
    YFBMessageTypeCount
};


@interface YFBMessageModel : JKDBModel
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSString *messageTime;
@property (nonatomic) YFBMessageType messageType;

+ (NSArray <YFBMessageModel *>*)allMessagesWithUserId:(NSString *)userId;

@end
