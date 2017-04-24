//
//  YFBChatTableViewCell.h
//  YFBFriend
//
//  Created by ylz on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBChatTableViewCell : UITableViewCell

+ (instancetype)createChatTableViewCellWithTableView:(UITableView *)tableView;

- (void)setCellAttributTitle:(NSAttributedString *)str;

@end
