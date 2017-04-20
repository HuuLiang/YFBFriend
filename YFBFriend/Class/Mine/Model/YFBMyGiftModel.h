//
//  YFBMyGiftModel.h
//  YFBFriend
//
//  Created by ylz on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBMyGiftModel : QBEncryptedURLRequest

- (void)fetchMyGiftModelWithType:(NSString *)typeString CompleteHandler:(QBCompletionHandler)handler;

@end
