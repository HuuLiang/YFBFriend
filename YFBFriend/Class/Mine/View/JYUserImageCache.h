//
//  JYUserImageCache.h
//  JYFriend
//
//  Created by ylz on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYImageCacheModel : NSObject
@property (nonatomic) NSString *imageName;
+ (NSArray *)findAll;
+ (void)deleteObjectWithImage:(NSString *)imageKey;
+ (NSString *)saveOrUpdateWithImage:(UIImage *)image;
+ (NSArray *)getAllImage;
@end

@interface JYUserImageCache : NSObject

+ (NSString *)getImageMd5KeyWithImage:(UIImage *)image;
+ (NSString *)writeToFileWithImage:(UIImage *)image needSaveImageName:(BOOL)needSaveName;

@end
