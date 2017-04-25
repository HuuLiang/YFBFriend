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

#import "YFBMessageDiamondCategoryCell.h"
#import "YFBMessageDiamondPayTypeCell.h"
#import "YFBMessageDiamondToPayCell.h"

typedef NS_ENUM(NSUInteger, YFBPopViewSection) {
    YFBPopViewSectionPayPoint = 0,
    YFBPopViewSectionPayTitle,
    YFBPopViewSectionPayType,
    YFBPopViewSectionGoToPay,
    YFBPopViewSectionCount
};

typedef NS_ENUM(NSUInteger,YFBPopViewDiamondSection) {
    YFBPopViewDiamondSectionCategory,
    YFBPopViewDiamondSectionType,
    YFBPopViewDiamondSectionPay,
    YFBPopViewDiamondSectionCount
};

static NSString *const kYFBFriendMessagePopViewPayPointReusableIdentifier = @"kYFBFriendMessagePopViewPayPointReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayTitleReusableIdentifier = @"kYFBFriendMessagePopViewPayTitleReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayTypeReusableIdentifier  = @"kYFBFriendMessagePopViewPayTypeReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayToPayReusableIdentifier = @"kYFBFriendMessagePopViewPayToPayReusableIdentifier";

static NSString *const kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier = @"kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier = @"kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondToPayReusableIdentifier = @"kYFBFriendMessagePopVIewDiamondToPayReusableIdentifier";

@interface YFBMessagePayPopController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation YFBMessagePayPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
//    [self configVipPopView];
    [self configDiamondPopView];
}

- (void)configVipPopView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier];
    [_tableView registerClass:[YFBMessagePayTitleCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTitleReusableIdentifier];
    [_tableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier];
    [_tableView registerClass:[YFBMessageToPayCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier];
    [self.view addSubview:_tableView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_pay_pop_view"]];
    [self.view insertSubview:backImageView belowSubview:_tableView];
    
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(670));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableView);
        }];
    }
}

- (void)configDiamondPopView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = kWidth(24);
//    layout.minimumInteritemSpacing = kWidth(22);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[YFBMessageDiamondCategoryCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondPayTypeCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondToPayCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(590));
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBPopViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewSectionPayPoint) {
        YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier forIndexPath:indexPath];
        cell.morePrice = @"¥100";
        cell.moreTitle = @"赠送100元话费";
        cell.lessPrice = @"¥50";
        cell.lessTitle = @"赠送50元话费";
        @weakify(self);
        cell.payAction = ^(id obj) {
            @strongify(self);
            
            YFBMessagePayTitleCell *cell = [self->_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:YFBPopViewSectionPayTitle]];
            if ([obj integerValue] == 1) {
                cell.title = @"对应11000币";
                cell.subTitle = @"(赠送100元话费)";
            } else if ([obj integerValue] == 2) {
                cell.title = @"对应5000币";
                cell.subTitle = @"(赠送50元话费)";
            }
        };
        return cell;
    } else if (indexPath.section == YFBPopViewSectionPayTitle) {
        YFBMessagePayTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTitleReusableIdentifier forIndexPath:indexPath];
        cell.title = @"对应11000币";
        cell.subTitle = @"(赠送100元话费)";
        return cell;
    } else if (indexPath.section == YFBPopViewSectionPayType) {
        YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        cell.payTypeAction = ^(id obj) {
            @strongify(self);
            
        };
        return cell;
    } else if (indexPath.section == YFBPopViewSectionGoToPay) {
        YFBMessageToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewSectionPayPoint) {
        return kWidth(160);
    } else if (indexPath.section == YFBPopViewSectionPayTitle) {
        return kWidth(58);
    } else if (indexPath.section == YFBPopViewSectionPayType) {
        return kWidth(80);
    } else if (indexPath.section == YFBPopViewSectionGoToPay) {
        return kWidth(84);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBPopViewSectionPayPoint) {
        return kWidth(160);
    } else if (section == YFBPopViewSectionPayTitle) {
        return kWidth(32);
    } else if (section == YFBPopViewSectionPayType) {
        return kWidth(30);
    } else if (section == YFBPopViewSectionGoToPay) {
        return kWidth(32);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == YFBPopViewSectionPayPoint) {
        return 0.01f;
    } else if (section == YFBPopViewSectionPayTitle) {
        return 0.01f;
    } else if (section == YFBPopViewSectionPayType) {
        return 0.01f;
    } else if (section == YFBPopViewSectionGoToPay) {
        return kWidth(34);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return YFBPopViewDiamondSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return 6;
    } else if (section == YFBPopViewDiamondSectionType) {
        return 2;
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        YFBMessageDiamondCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier forIndexPath:indexPath];
        cell.diamondCount = [NSString stringWithFormat:@"%ld",100*indexPath.item];
        cell.price = [NSString stringWithFormat:@"%ld",10*indexPath.item];
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        YFBMessageDiamondPayTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier forIndexPath:indexPath];
        cell.payType = indexPath.item;
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        YFBMessageDiamondToPayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat itemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets edgeInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    
    CGFloat width;
    
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right - itemSpacing) / 2;
        return CGSizeMake((long)width, kWidth(88));
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right - itemSpacing) / 2;
        return CGSizeMake((long)width, kWidth(76));
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right);
        return CGSizeMake((long)width, kWidth(72));
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return kWidth(22);
    } else if (section == YFBPopViewDiamondSectionType) {
        return kWidth(22);
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 0;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return kWidth(24);
    } else if (section == YFBPopViewDiamondSectionType) {
        return 0;
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return UIEdgeInsetsMake(kWidth(30), kWidth(40), kWidth(42), kWidth(40));
    } else if (section == YFBPopViewDiamondSectionType) {
        return UIEdgeInsetsMake(kWidth(0), kWidth(40), kWidth(30), kWidth(40));
    } else if (section == YFBPopViewDiamondSectionPay) {
        return UIEdgeInsetsMake(kWidth(0), kWidth(40), kWidth(28), kWidth(40));
    }
    return UIEdgeInsetsZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        
    }
}

@end
