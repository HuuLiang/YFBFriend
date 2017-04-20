//
//  YFBMessageFunctionView.h
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YFBMessageFunciontType) {
    YFBMessageFunciontTypeAttention = 0,
    YFBMessageFunciontTypeYBi,
    YFBMessageFunciontTypePhone,
    YFBMessageFunciontTypeWX
};

typedef void(^MessageFunctionType)(YFBMessageFunciontType type);

@interface YFBMessageFunctionView : UIView

@property (nonatomic) MessageFunctionType functionType;

@end
