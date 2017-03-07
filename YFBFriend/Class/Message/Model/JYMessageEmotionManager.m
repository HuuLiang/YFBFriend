//
//  JYMessageEmotionManager.m
//  JYFriend
//
//  Created by Liang on 2017/2/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYMessageEmotionManager.h"

@implementation JYMessageEmotionManager

+ (instancetype)manager {
    static JYMessageEmotionManager *_emotionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotionManager = [[JYMessageEmotionManager alloc] init];
    });
    return _emotionManager;
}

- (void)configEmotionMangers {
    NSMutableArray *emotionManagers = [NSMutableArray array];

    //加载大黄脸
    XHEmotionManager *bigEmotionManager = [[XHEmotionManager alloc] init];
    bigEmotionManager.emotionName = @"大黄脸";
    NSMutableArray *bigEmotions = [NSMutableArray array];
    for (NSInteger j = 0; j < 55; j ++) {
        XHEmotion *emotion = [[XHEmotion alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"e%ld.gif", (long)j + 100];
        emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"e%ld", (long)j+100] ofType:@"gif"];
        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
        [bigEmotions addObject:emotion];
    }
    bigEmotionManager.emotions = bigEmotions;
    [emotionManagers addObject:bigEmotionManager];
    
    self.emtionManager = emotionManagers;
}

@end
