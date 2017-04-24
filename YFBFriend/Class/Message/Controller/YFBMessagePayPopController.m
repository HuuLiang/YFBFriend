//
//  YFBMessagePayPopController.m
//  YFBFriend
//
//  Created by ylz on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayPopController.h"
#import "YFBMessagePayPointCell.h"
#import "YFBMessagePayTitleCell.h"
#import "YFBMessagePayTypeCell.h"
#import "YFBMessageToPayCell.h"

typedef NS_ENUM(NSUInteger, YFBTopViewRow) {
    YFBTopViewRowPayPoint = 0,
    YFBTopViewRowPayTitle,
    YFBTopViewRowPayType,
    YFBTopViewRowGoToPay,
    YFBTopViewRowCount
};

static NSString *const kYFBFriendMessagePopViewPayPointKeyName = @"kYFBFriendMessagePopViewPayPointKeyName";
static NSString *const kYFBFriendMessagePopViewPayTitleKeyName = @"kYFBFriendMessagePopViewPayTitleKeyName";
static NSString *const kYFBFriendMessagePopViewPayTypeKeyName  = @"kYFBFriendMessagePopViewPayTypeKeyName";
static NSString *const kYFBFriendMessagePopViewPayToPayKeyName = @"kYFBFriendMessagePopViewPayToPayKeyName";


@interface YFBMessagePayPopController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBMessagePayPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_pay_pop_view"]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointKeyName];
    [_tableView registerClass:[YFBMessagePayTitleCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTitleKeyName];
    [_tableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeKeyName];
    [_tableView registerClass:[YFBMessageToPayCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayToPayKeyName];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(670));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showMessageTopUpPopViewWithCurrentVC:(UIViewController *)currentVC {
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
    
}


- (void)hide {
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return YFBTopViewRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBTopViewRowPayPoint) {
        YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointKeyName forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.row == YFBTopViewRowPayTitle) {
        YFBMessagePayTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTitleKeyName forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.row == YFBTopViewRowPayType) {
        YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeKeyName forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.row == YFBTopViewRowGoToPay) {
        YFBMessageToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayToPayKeyName forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == YFBTopViewRowPayPoint) {
        
    } else if (indexPath.row == YFBTopViewRowPayTitle) {
        
    } else if (indexPath.row == YFBTopViewRowPayType) {
        
    } else if (indexPath.row == YFBTopViewRowGoToPay) {
        
    }
    return 0;
}

@end
