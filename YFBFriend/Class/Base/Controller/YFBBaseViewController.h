//
//  YFBBaseViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBBaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

- (instancetype)initWithTitle:(NSString *)title;

@end
