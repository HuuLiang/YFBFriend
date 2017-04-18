//
//  YFBBlagGiftView.h
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBBlagGiftView : UIView

@property (nonatomic) NSString *headerImageUrl;
@property (nonatomic) NSString *sendTitle;
@property (nonatomic) NSString *sendSubTitle;
@property (nonatomic,copy) QBAction closeAction;
@property (nonatomic,copy) QBAction giftAction;
@end
