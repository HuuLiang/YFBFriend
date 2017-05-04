//
//  YFBContactManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBContactModel : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *messageTime;
@property (nonatomic) NSString *messageContent;
@property (nonatomic) YFBMessageType messageType;
@end

@interface YFBContactManager : NSObject

+ (instancetype)manager;

- (NSArray <YFBContactModel *> *)loadAllContactInfo;

@end