//
//  YFBSocialCell.h
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBSocialCell : UITableViewCell
@property (nonatomic) YFBAction detailAction;
@property (nonatomic) YFBAction descAction;
@property (nonatomic) YFBAction wxAction;
@property (nonatomic) YFBAction payAction;
@property (nonatomic) YFBAction commentAction;

@property (nonatomic) NSString *userImgUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSInteger serverCount;
@property (nonatomic) NSInteger serverRate;
@property (nonatomic) NSString *descStr;
@property (nonatomic) NSString *imgUrlA;
@property (nonatomic) NSString *imgUrlB;
@property (nonatomic) NSString *imgUrlC;

@end
