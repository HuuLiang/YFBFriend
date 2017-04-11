//
//  YFBImageUploadManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBImageUploadManager.h"
#import "QiniuToken.h"
#import "QiniuUploader.h"
#import <AFNetworking.h>

@implementation YFBImageUploadManager

+ (void)registerWithSecretKey:(NSString *)secretKey accessKey:(NSString *)accessKey scope:(NSString *)scope {
    [QiniuToken registerWithScope:scope SecretKey:secretKey Accesskey:accessKey];
}

//+ (NSString *)imageURLWithName:(NSString *)name {
//    NSString *baseURL = [YPBSystemConfig sharedConfig].imgUrl;
//    if (![baseURL hasSuffix:@"/"]) {
//        baseURL = [baseURL stringByAppendingString:@"/"];
//    }
//    
//    return [baseURL stringByAppendingString:name];
//}

+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
  completionHandler:(QBCompletionHandler)handler
{
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    
    uploader.uploadOneFileSucceeded = ^(AFHTTPRequestSerializer *operation, NSInteger index, NSString *key) {
        QBSafelyCallBlock(handler,YES,nil);
    };
    
    uploader.uploadOneFileFailed = ^(AFHTTPRequestSerializer *operation, NSInteger index, NSDictionary *error) {
        QBSafelyCallBlock(handler,NO,error);
    };
    
    [self uploader:uploader addImage:image withName:name];
    return [uploader startUpload];
}

+ (void)uploader:(QiniuUploader *)uploader addImage:(UIImage *)image withName:(NSString *)name {
    const CGFloat widthMetrics = 736;
    const CGFloat heightMetrics = 414;
    const CGFloat compressionQuality = MIN(1, MAX(widthMetrics/image.size.width, heightMetrics/image.size.height));
    
    NSData *imageData;
    if ([name hasSuffix:@".png"]) {
        imageData = UIImagePNGRepresentation(image);
    } else {
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
    }
    
    [uploader addFile:[[QiniuFile alloc] initWithFileData:imageData withKey:name]];
}


@end
