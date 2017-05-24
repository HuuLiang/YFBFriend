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

#import "YFBDiamondManager.h"
#import "YFBPayConfigManager.h"
#import "YFBPaymentManager.h"

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

typedef NS_ENUM(NSUInteger,YFBMessageBuyDiamondSection) {
    YFBMessageBuyDiamondSectionPayPoint = 0,
    YFBMessageBuyDiamondSectionPayType,
    YFBMessageBuyDiamondSectionToPay,
    YFBMessageBuyDiamondSectionCount
};

static NSString *const kYFBFriendMessagePopViewPayPointReusableIdentifier = @"kYFBFriendMessagePopViewPayPointReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayTitleReusableIdentifier = @"kYFBFriendMessagePopViewPayTitleReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayTypeReusableIdentifier  = @"kYFBFriendMessagePopViewPayTypeReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayToPayReusableIdentifier = @"kYFBFriendMessagePopViewPayToPayReusableIdentifier";

static NSString *const kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier = @"kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier = @"kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondToPayReusableIdentifier = @"kYFBFriendMessagePopVIewDiamondToPayReusableIdentifier";

@interface YFBMessagePayPopController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UITableView *diamondTableView;
@property (nonatomic) UITableView *vipTableView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSIndexPath *categoryIndexPath;
@property (nonatomic) NSIndexPath *payTypeIndexPath;
@property (nonatomic) YFBMessagePopViewType popViewType;
@property (nonatomic) NSInteger selectedPrice;
@property (nonatomic) NSInteger selectedCount;
@property (nonatomic) YFBPayType selectedPayType;
@end

@implementation YFBMessagePayPopController
QBDefineLazyPropertyInitialization(NSIndexPath, categoryIndexPath)
QBDefineLazyPropertyInitialization(NSIndexPath, payTypeIndexPath)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    switch (self.popViewType) {
        case YFBMessagePopViewTypeVip:
            [self configVipPopView];
            break;
            
        case YFBMessagePopViewTypeDiamond:
            [self configDiamondPopView];
            break;
            
        case YFBMessagePopViewTypeBuyDiamond:
            [self configDiamondBuyView];
            break;
            
        default:
            break;
    }
}

- (void)configVipPopView {
    self.vipTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _vipTableView.backgroundColor = [UIColor clearColor];
    _vipTableView.delegate = self;
    _vipTableView.dataSource = self;
    [_vipTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_vipTableView setScrollEnabled:NO];
    [_vipTableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier];
    [_vipTableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier];
    [_vipTableView registerClass:[YFBMessageToPayCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier];
    [self.view addSubview:_vipTableView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_diamond_pop_view"]];
    [self.view insertSubview:backImageView belowSubview:_vipTableView];
    
    {
        [_vipTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(670));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_vipTableView);
        }];
    }
    
    self.selectedPayType = YFBPayTypeWeiXin;
    self.selectedPrice = [YFBPayConfigManager manager].vipInfo.secondInfo.price;
    self.selectedCount = [YFBPayConfigManager manager].vipInfo.secondInfo.amount;
}

- (void)configDiamondBuyView {
    self.diamondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _diamondTableView.backgroundColor = [UIColor clearColor];
    _diamondTableView.delegate = self;
    _diamondTableView.dataSource = self;
    [_diamondTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_diamondTableView setScrollEnabled:NO];
    [_diamondTableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier];
    [_diamondTableView registerClass:[YFBMessagePayTitleCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTitleReusableIdentifier];
    [_diamondTableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier];
    [_diamondTableView registerClass:[YFBMessageToPayCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier];
    [self.view addSubview:_diamondTableView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_pay_pop_view"]];
    [self.view insertSubview:backImageView belowSubview:_diamondTableView];
    
    {
        [_diamondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(670));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_diamondTableView);
        }];
    }
    self.selectedPayType = YFBPayTypeWeiXin;
    self.selectedPrice = [YFBPayConfigManager manager].diamondInfo.secondInfo.price;
    self.selectedCount = [YFBPayConfigManager manager].diamondInfo.secondInfo.amount;
}

- (void)configDiamondPopView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[YFBMessageDiamondCategoryCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondPayTypeCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondToPayCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(590));
        }];
    }
    [self setDefaultSelectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setDefaultSelectedIndex {
    if (_collectionView) {
        if (!_categoryIndexPath) {
            self.categoryIndexPath = [NSIndexPath indexPathForItem:0 inSection:YFBPopViewDiamondSectionCategory];
        }
        [_collectionView selectItemAtIndexPath:self.categoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
        if (!_payTypeIndexPath) {
            self.payTypeIndexPath = [NSIndexPath indexPathForItem:0 inSection:YFBPopViewDiamondSectionType];
        }
        [_collectionView selectItemAtIndexPath:self.payTypeIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDefaultSelectedIndex];
}

+ (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC {
    YFBMessagePayPopController *payPopView = [[YFBMessagePayPopController alloc] init];
    [payPopView showMessageTopUpPopViewWithType:type onCurrentVC:currentVC];
}

- (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC {
    self.popViewType = type;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)dealloc {
    
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
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        return YFBPopViewSectionCount;
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        return YFBMessageBuyDiamondSectionCount;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier forIndexPath:indexPath];
            cell.morePrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.secondInfo.price/100)];
            cell.moreTitle = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].diamondInfo.secondInfo.detail];
            cell.lessPrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.firstInfo.price/100)];
            cell.lessTitle = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].diamondInfo.firstInfo.detail];
            @weakify(self);
            cell.payAction = ^(id obj) {
                @strongify(self);
                
                YFBMessagePayTitleCell *cell = [self->_diamondTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:YFBPopViewSectionPayTitle]];
                if ([obj integerValue] == 1) {
                    cell.title = @"对应1100钻石";
                    cell.subTitle = @"(赠送100元话费)";
                    
                    self.selectedCount = (long)[YFBPayConfigManager manager].diamondInfo.secondInfo.amount;
                    self.selectedPrice = (long)[YFBPayConfigManager manager].diamondInfo.secondInfo.price;
                    
                } else if ([obj integerValue] == 2) {
                    cell.title = @"对应500钻石";
                    cell.subTitle = @"";
                    
                    self.selectedCount = (long)[YFBPayConfigManager manager].diamondInfo.firstInfo.amount;
                    self.selectedPrice = (long)[YFBPayConfigManager manager].diamondInfo.firstInfo.price;
                }
            };
            return cell;
        } else if (indexPath.section == YFBPopViewSectionPayTitle) {
            YFBMessagePayTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTitleReusableIdentifier forIndexPath:indexPath];
            cell.title = @"对应1100钻石";
            cell.subTitle = @"(赠送100元话费)";
            return cell;
        } else if (indexPath.section == YFBPopViewSectionPayType) {
            YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payTypeAction = ^(NSNumber * selectedPayTypeNumber) {
                @strongify(self);
                if ([selectedPayTypeNumber integerValue] == YFBPayTypeWeiXin) {
                    self.selectedPayType = YFBPayTypeWeiXin;
                } else if ([selectedPayTypeNumber integerValue] == YFBPayTypeAliPay) {
                    self.selectedPayType = YFBPayTypeAliPay;
                }
            };
            return cell;
        } else if (indexPath.section == YFBPopViewSectionGoToPay) {
            YFBMessageToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payAction = ^{
                @strongify(self);
                [[YFBPaymentManager manager] payForAction:kYFBPaymentActionPURCHASEDIAMONDKeyName WithPayType:self.selectedPayType price:self.selectedPrice count:self.selectedCount handler:^(BOOL success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                    [self hide];
                }];
            };
            return cell;
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBMessageBuyDiamondSectionPayPoint) {
            YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier forIndexPath:indexPath];
            cell.morePrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.secondInfo.price)/100];;
            cell.moreTitle = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].vipInfo.secondInfo.detail];
            cell.lessPrice = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.firstInfo.price)/100];;
            cell.lessTitle = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].vipInfo.firstInfo.detail];
            @weakify(self);
            cell.payAction = ^(id obj) {
                @strongify(self);
                if ([obj integerValue] == 1) {
                    self.selectedPrice = [YFBPayConfigManager manager].vipInfo.secondInfo.price;
                    self.selectedCount = [YFBPayConfigManager manager].vipInfo.secondInfo.amount;
                } else if ([obj integerValue] == 2) {
                    self.selectedPrice = [YFBPayConfigManager manager].vipInfo.firstInfo.price;
                    self.selectedCount = [YFBPayConfigManager manager].vipInfo.firstInfo.amount;
                }
            };
            return cell;
        } else if (indexPath.section == YFBMessageBuyDiamondSectionPayType) {
            YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payTypeAction = ^(NSNumber * selectedPayTypeNumber) {
                @strongify(self);
                if ([selectedPayTypeNumber integerValue] == YFBPayTypeWeiXin) {
                    self.selectedPayType = YFBPayTypeWeiXin;
                } else if ([selectedPayTypeNumber integerValue] == YFBPayTypeAliPay) {
                    self.selectedPayType = YFBPayTypeAliPay;
                }
            };
            return cell;
        } else if (indexPath.section == YFBMessageBuyDiamondSectionToPay) {
            YFBMessageToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayToPayReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payAction = ^{
                @strongify(self);
                [[YFBPaymentManager manager] payForAction:kYFBPaymentActionOpenVipKeyName WithPayType:self.selectedPayType price:self.selectedPrice count:self.selectedCount handler:^(BOOL success) {
                    if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                        [self hide];
                    }
                }];
            };
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            return kWidth(160);
        } else if (indexPath.section == YFBPopViewSectionPayTitle) {
            return kWidth(58);
        } else if (indexPath.section == YFBPopViewSectionPayType) {
            return kWidth(80);
        } else if (indexPath.section == YFBPopViewSectionGoToPay) {
            return kWidth(84);
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBMessageBuyDiamondSectionPayPoint) {
            return kWidth(160);
        } else if (indexPath.section == YFBMessageBuyDiamondSectionPayType) {
            return kWidth(80);
        } else if (indexPath.section == YFBMessageBuyDiamondSectionToPay) {
            return kWidth(84);
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return kWidth(160);
        } else if (section == YFBPopViewSectionPayTitle) {
            return kWidth(32);
        } else if (section == YFBPopViewSectionPayType) {
            return kWidth(30);
        } else if (section == YFBPopViewSectionGoToPay) {
            return kWidth(32);
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (section == YFBMessageBuyDiamondSectionPayPoint) {
            return kWidth(220);
        } else if (section == YFBMessageBuyDiamondSectionPayType) {
            return kWidth(66);
        } else if (section == YFBMessageBuyDiamondSectionToPay) {
            return kWidth(32);
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return 0.01f;
        } else if (section == YFBPopViewSectionPayTitle) {
            return 0.01f;
        } else if (section == YFBPopViewSectionPayType) {
            return 0.01f;
        } else if (section == YFBPopViewSectionGoToPay) {
            return kWidth(34);
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (section == YFBMessageBuyDiamondSectionPayPoint) {
            return 0.01f;
        } else if (section == YFBMessageBuyDiamondSectionPayType) {
            return 0.01f;
        } else if (section == YFBMessageBuyDiamondSectionToPay) {
            return kWidth(34);
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    if ([tableView isKindOfClass:[_vipTableView class]]) {
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(14);
        label.textColor = kColor(@"#999999");
        [headerView addSubview:label];
        
        if (section == YFBMessageBuyDiamondSectionPayPoint) {
           label.text = @"开通服务";
        } else if (section == YFBMessageBuyDiamondSectionPayType) {
            label.text = @"支付方式";
        }
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView).offset(kWidth(40));
                make.bottom.equalTo(headerView.mas_bottom).offset(-kWidth(16));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
    }
    
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
        if (indexPath.item < [YFBDiamondManager manager].diamonList.count) {
            YFBDiamondInfo *diamondInfo = [YFBDiamondManager manager].diamonList[indexPath.item];
            cell.diamondCount = [NSString stringWithFormat:@"%ld",(long)diamondInfo.diamondAmount];
            cell.price = [NSString stringWithFormat:@"%ld",(long)(diamondInfo.price/100)];
        }
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        YFBMessageDiamondPayTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier forIndexPath:indexPath];
        cell.payType = indexPath.item;
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        YFBMessageDiamondToPayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        cell.payAction = ^(id obj) {
            @strongify(self);
            YFBDiamondInfo *diamondInfo = [YFBDiamondManager manager].diamonList[self.categoryIndexPath.item];
            //支付
            [[YFBPaymentManager manager] payForAction:kYFBPaymentActionPURCHASEDIAMONDKeyName WithPayType:self.payTypeIndexPath.item price:diamondInfo.price count:diamondInfo.diamondAmount handler:^(BOOL success) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                    [self hide];
                }
            }];
        };
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        if (![self.categoryIndexPath isEqual:indexPath]) {
            [_collectionView deselectItemAtIndexPath:self.categoryIndexPath animated:YES];
            self.categoryIndexPath = indexPath;
        }
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        if (![self.payTypeIndexPath isEqual:indexPath]) {
            [_collectionView deselectItemAtIndexPath:self.payTypeIndexPath animated:YES];
            self.payTypeIndexPath = indexPath;
        }
    }

    return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == YFBPopViewDiamondSectionPay && indexPath.item < [YFBDiamondManager manager].diamonList.count) {
//        YFBDiamondInfo *diamondInfo = [YFBDiamondManager manager].diamonList[indexPath.item];
//        //支付
//        [[YFBPaymentManager manager] payForAction:kYFBPaymentActionPURCHASEDIAMONDKeyName WithPayType:self.payTypeIndexPath.item price:diamondInfo.price count:diamondInfo.diamondAmount handler:^(BOOL success) {
//            if (success) {
//                
//            }
//        }];
//    }
//}
@end
