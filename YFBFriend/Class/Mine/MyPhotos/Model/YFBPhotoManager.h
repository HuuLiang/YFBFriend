//
//  YFBPhotoManager.h
//  YFBFriend
//
//  Created by Liang on 2017/3/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImagePicker)(UIImage *pickerImage,NSString *keyName);

@interface YFBPhotoManager : NSObject

+ (instancetype)manager;

//- (void)saveAllImageKeys:(NSArray *)imageKeys;
//
//- (NSArray *)allImageKeys;
//
//- (void)saveOneImageKey:(NSString *)imageKey;



- (void)getImageInCurrentViewController:(UIViewController *)viewController handler:(ImagePicker)picker;

@end
