//
//  YFBPhotoBrowse.h
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBPhotoBrowse : UIView

+ (instancetype)browse;

- (void)showPhotoBrowseWithImageUrl:(NSString *)imageUrl onSuperView:(UIView *)superView;

@property (nonatomic) QBAction closeAction;

@end