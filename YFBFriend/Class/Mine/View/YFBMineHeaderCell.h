//
//  YFBMineHeaderCell.h
//  YFBFriend
//
//  Created by ylz on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMineHeaderCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *idNumber;
@property (nonatomic) NSString *headerUrl;
@property (nonatomic) NSString *invite;//邀请码

@property (nonatomic,copy) QBAction ktVipAction;//开通VIP
@property (nonatomic,copy) QBAction attestationAction;//手机认证

@end
