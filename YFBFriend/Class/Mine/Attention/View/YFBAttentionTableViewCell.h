//
//  YFBAttentionTableViewCell.h
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBAttentionTableViewCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *headerUrl;
@property (nonatomic) NSString *age;
@property (nonatomic) NSInteger photoCount;

@property (nonatomic,copy) QBAction attentionAction;

@end
