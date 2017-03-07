//
//  JYUserImageCache.m
//  JYFriend
//
//  Created by ylz on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//
#import "JYUserImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "JYMD5Utils.h"
#import <SDImageCache.h>

static NSString *const filePaths = @"JYMyPhotos";

static NSString *const kJYImageCacheImageName = @"jiaoyou_imagemodel_imagechche_key";

@implementation JYImageCacheModel
+ (NSArray *)findAll {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJYImageCacheImageName];
}

+ (NSArray *)getAllImage{
    NSMutableArray *allImages = [NSMutableArray arrayWithCapacity:[self findAll].count];
    [[self findAll] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [allImages addObject:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj]];
    }];
    return allImages.copy;
}

+ (void)deleteObjectWithImage:(NSString *)imageKey {
    NSMutableArray *imagesArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kJYImageCacheImageName]];
    if ([imagesArr containsObject:imageKey]) {
        [imagesArr removeObject:imageKey];
        [[SDImageCache sharedImageCache] removeImageForKey:imageKey];
        [[NSUserDefaults standardUserDefaults] setObject:imagesArr forKey:kJYImageCacheImageName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

+ (NSString *)saveOrUpdateWithImage:(UIImage *)image {
    NSMutableArray *imagesArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kJYImageCacheImageName]];
    NSString *imageKey = [JYUserImageCache writeToFileWithImage:image needSaveImageName:NO];
    if (![imagesArr containsObject:imageKey]) {
        [imagesArr addObject:imageKey];
        [[NSUserDefaults standardUserDefaults] setObject:imagesArr forKey:kJYImageCacheImageName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return imageKey;
    }else {
        return nil;
    }
}


@end

@implementation JYUserImageCache

+ (instancetype)shareInstance{
    static JYUserImageCache *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JYUserImageCache alloc] init];
    });
    return _instance;
}


+ (NSString *)writeToFileWithImage:(UIImage *)image needSaveImageName:(BOOL)needSaveName{
    NSData *imageData = [self zipImageWithImage:image];
    UIImage *newImage = [UIImage imageWithData:imageData];
    NSString *imageDataMd5 = [JYMD5Utils md5Data:imageData];
    [[SDImageCache sharedImageCache] storeImage:newImage forKey:imageDataMd5 toDisk:YES];
    
    return imageDataMd5;
}

+ (NSString *)getImageMd5KeyWithImage:(UIImage *)image {
  //对图片进行压缩
    NSData *imageData = [self zipImageWithImage:image];
    NSString *imageDataMd5 = [JYMD5Utils md5Data:imageData];
    return imageDataMd5;
}

+ (NSData *)zipImageWithImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = 80*1024;
    CGFloat compression = 0.6f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    UIImage *newImage = image;
    while ([compressedData length] > maxFileSize) {
        if ([JYUtil deviceType] > JYDeviceType_iPhone4S) {
             compression *= 0.8f;
        }
        newImage = [[self class] compressImage:newImage newWidth:newImage.size.width*compression];
        compressedData = UIImageJPEGRepresentation(newImage, compression);
    }
    return compressedData;
}

+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
