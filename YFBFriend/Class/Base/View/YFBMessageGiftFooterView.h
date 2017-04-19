//
//  YFBMessageGiftFooterView.h
//  YFBFriend
//
//  Created by ylz on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMessageGiftFooterView : UIView

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageNumbers;
@property (nonatomic) NSInteger diamondCount;

@property (nonatomic,copy) QBAction topUpAction;
@property (nonatomic,copy) QBAction sendAction;
@end
