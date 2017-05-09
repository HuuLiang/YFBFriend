//
//  YFBVipExampleCell.h
//  YFBFriend
//
//  Created by Liang on 2017/5/2.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBVipExampleCell : UITableViewCell
@property (nonatomic) NSArray *userList;
@property (nonatomic) BOOL scrollStart;
@end



@interface YFBScrollCell : UITableViewCell
@property (nonatomic) NSString *title;
@end
