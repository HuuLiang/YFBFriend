//
//  YFBSocialModel.h
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBSocialResponse : QBURLResponse


@end


@interface YFBSocialModel : QBEncryptedURLRequest

- (BOOL)fetchSocialContentWithType:(YFBSocialType)socialType CompletionHandler:(QBCompletionHandler)handler;

@end
