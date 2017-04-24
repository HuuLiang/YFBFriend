//
//  YFBMTableViewDatasource.h
//  YFBFriend
//
//  Created by ylz on 2017/3/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBChatTableViewCell.h"

typedef UITableViewCell *(^YFBTableViewCellBlock)( id model);

@interface YFBMTableViewDatasource : NSObject<UITableViewDelegate, UITableViewDataSource>

/**
 *  设置数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

/**
 *  设置cell配置block
 */
@property (nonatomic, copy) YFBTableViewCellBlock tableViewCell;

/**
 *  设置是否是按组还是row  yes : row   no : section  默认是yes
 */
@property (nonatomic, assign) BOOL isRow;

/**
 *  设置tableviewcell的高度
 */
@property (nonatomic, assign) CGFloat rowHeight;

/**
 *  设置tableview头部view  默认无
 */
@property (nonatomic, strong) UIView *headView;

@end
