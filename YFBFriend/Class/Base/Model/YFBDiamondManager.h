//
//  YFBDiamondManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBDiamondInfo : NSObject
@property (nonatomic) NSString *serverKeyName;
@property (nonatomic) NSInteger diamondAmount;
@property (nonatomic) NSInteger dpcId;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSString *giveDesc;
@end

@interface YFBDiamondResponse : QBURLResponse
@property (nonatomic) NSArray <YFBDiamondInfo *> * diamondPriceConfList;
@end

@interface YFBDiamondManager : QBEncryptedURLRequest

+ (instancetype)manager;

@property (nonatomic) NSMutableArray <YFBDiamondInfo *> *diamondList;

- (void)getDiamondListCache;

- (BOOL)fetchDiamondListWithCompletionHandler:(QBCompletionHandler)handler;

- (void)changeDiamondPrice:(CGFloat)newPrice WithDiamondKeyName:(NSString *)diamondKeyName;

@end
