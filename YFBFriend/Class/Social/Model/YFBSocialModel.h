//
//  YFBSocialModel.h
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBCommentModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *serv;
@property (nonatomic) NSString *content;
@end

@interface YFBSocialServiceModel : NSObject
@property (nonatomic) NSString * servName;
@property (nonatomic) NSString * iconUrl;
@property (nonatomic) NSString * time;
@property (nonatomic) NSString * price;
@property (nonatomic) NSString * orig;
@end

@interface YFBSocialInfo : NSObject
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSInteger servNum;
@property (nonatomic) NSInteger star;
@property (nonatomic) NSString *describe;
@property (nonatomic) NSString *imgUrl1;
@property (nonatomic) NSString *imgUrl2;
@property (nonatomic) NSString *imgUrl3;
@property (nonatomic) NSString *weixin;
@property (nonatomic) NSArray <YFBSocialServiceModel *>*serviceLists;
@property (nonatomic) NSArray <YFBCommentModel *>*comments;
@property (nonatomic) BOOL needShowButton;
@end


@interface YFBSocialResponse : QBURLResponse
@property (nonatomic) NSArray <YFBSocialInfo *> *cityServices;
@end


@interface YFBSocialModel : QBEncryptedURLRequest

- (BOOL)fetchSocialContentWithType:(YFBSocialType)socialType CompletionHandler:(QBCompletionHandler)handler;

@end
