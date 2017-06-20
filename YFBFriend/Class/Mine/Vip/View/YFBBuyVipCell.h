//
//  YFBBuyVipCell.h
//  YFBFriend
//
//  Created by Liang on 2017/6/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YFBBuyVipType) {
    YFBBuyVipTypeGold = 0,
    YFBBuyVipTypeSliver
};

@interface YFBBuyVipCell : UITableViewCell

@property (nonatomic) YFBBuyVipType vipType;
@property (nonatomic) YFBAction payAction;

@end
