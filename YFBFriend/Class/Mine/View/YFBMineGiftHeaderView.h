//
//  YFBMineGiftHeaderView.h
//  YFBFriend
//
//  Created by ylz on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMineGiftHeaderView : UIView

@property (nonatomic) NSAttributedString *title;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *allGift;

@property (nonatomic,copy) QBAction action;
@end
