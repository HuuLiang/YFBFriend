//
//  JYLocalVideoUtils.h
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLocalVideoUrlPathModel : JKDBModel

@property (nonatomic) NSString *videoPath;

@end

@interface JYLocalVideoUtils : NSObject

+ (NSString *)currentTime;
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)fetchTimeIntervalToCurrentTimeWithStartTime:(NSString *)startTime;
/**
 视频的第一帧图片
 */
+ (UIImage *)getImage:(NSURL*)videoURL;
/**
 获取视频长度
 */
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)videoUrl ;
//
+ (NSString *)writeToFileWithVideoUrl:(NSURL *)videoUrl needSaveVideoName:(BOOL)needSaveVideoName;

@end
