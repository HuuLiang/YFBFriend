//
//  YFBMineGiftCell.h
//  YFBFriend
//
//  Created by ylz on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMineGiftCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *diamond;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *giveStr;
@property (nonatomic,copy) QBAction giveAction;

@end