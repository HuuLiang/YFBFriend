//
//  YFBMessagePayPointCell.h
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMessagePayPointCell : UITableViewCell
@property (nonatomic,copy) NSString *morePrice;
@property (nonatomic,copy) NSString *moreTitle;
@property (nonatomic,copy) NSString *lessPrice;
@property (nonatomic,copy) NSString *lessTitle;
@property (nonatomic,copy) QBAction payAction;
@end
