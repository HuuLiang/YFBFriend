//
//  JYMessageEmotionManager.h
//  JYFriend
//
//  Created by Liang on 2017/2/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "XHEmotionManager.h"

@interface JYMessageEmotionManager : XHEmotionManager

+ (instancetype)manager;

- (void)configEmotionMangers;

@property (nonatomic)NSMutableArray *emtionManager;

@end
