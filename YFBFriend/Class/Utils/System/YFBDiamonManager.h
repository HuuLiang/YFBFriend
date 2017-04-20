//
//  YFBDiamonManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBDiamonInfo : NSObject
@property (nonatomic) NSInteger diamondAmount;
@property (nonatomic) NSInteger dpcId;
@property (nonatomic) NSInteger price;
@end

@interface YFBDiamonResponse : QBURLResponse
@property (nonatomic) NSArray <YFBDiamonInfo *> * diamondPriceConfList;
@end

@interface YFBDiamonManager : QBEncryptedURLRequest

+ (instancetype)manager;

@property (nonatomic,readonly) NSArray <YFBDiamonInfo *> *diamonList;

- (void)getDiamonListCache;

- (BOOL)fetchDiamonListWithCompletionHandler:(QBCompletionHandler)handler;

@end
