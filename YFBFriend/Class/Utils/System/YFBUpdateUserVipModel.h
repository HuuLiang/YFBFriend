//
//  YFBUpdateUserVipModel.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBUpdateUserVipResponse : QBURLResponse
@property (nonatomic) NSString *vipEndDate;
@end

@interface YFBUpdateUserVipModel : QBEncryptedURLRequest

- (BOOL)updateUserVipInfo:(YFBVipType)vipType CompletionHandler:(QBCompletionHandler)handler;

@end
