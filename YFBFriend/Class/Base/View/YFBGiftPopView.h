//
//  YFBGiftPopView.h
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBGiftPopView : UIView
- (instancetype)initWithGiftModels:(NSArray *)giftModels edg:(CGFloat)edg footerHeight:(CGFloat)height backColor:(UIColor *)backColor isMessagePop:(BOOL)isMessagePop;

@end
