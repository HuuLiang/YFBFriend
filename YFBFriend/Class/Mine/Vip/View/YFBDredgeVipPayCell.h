//
//  YFBDredgeVipPayCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBDredgeVipPayCell : UITableViewCell
@property (nonatomic,copy) NSString *lessTime;
@property (nonatomic,copy) NSString *lessPrice;
@property (nonatomic,copy) NSString *lessTitle;
@property (nonatomic,copy) NSString *moreTime;
@property (nonatomic,copy) NSString *morePrice;
@property (nonatomic,copy) NSString *moreTitle;
@property (nonatomic,copy) QBAction payAction;
@end
