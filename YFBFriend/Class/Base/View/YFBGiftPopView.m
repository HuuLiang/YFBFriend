//
//  YFBGiftPopView.m
//  YFBFriend
//
//  Created by ylz on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopView.h"
#import "YFBGiftPopCell.h"
#import "YFBGiftFooterView.h"

static NSString *const YFBGiftPopCellIdentifier = @"yfb_gift_pop_cell_identifier";

@interface YFBGiftPopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    CGFloat _footerHeight;
    CGFloat _edg;
}
@property (nonatomic) YFBGiftFooterView *footerView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) YFBGiftPopViewType type;
@end

@implementation YFBGiftPopView

- (instancetype)initWithGiftInfos:(NSArray *)giftInfos WithGiftViewType:(YFBGiftPopViewType)type {
    self = [super init];
    
    if (self) {
        
        self.type = type;
        
        switch (type) {
            case YFBGiftPopViewTypeList:
                self.backgroundColor = [kColor(@"#A1A1A1") colorWithAlphaComponent:1];
                self.layer.borderColor = [kColor(@"#000000") colorWithAlphaComponent:0.8].CGColor;
                self.layer.borderWidth = 0.03f;
                break;
            case YFBGiftPopViewTypeBlag:
                self.backgroundColor = kColor(@"#ffffff");
                self.layer.borderColor = [kColor(@"#F3B050") colorWithAlphaComponent:1].CGColor;
                self.layer.borderWidth = 2.0f;
                break;
            default:
                break;
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat footerHeight ;
        switch (type) {
            case YFBGiftPopViewTypeList:
                flowLayout.minimumInteritemSpacing = 0.25;
                flowLayout.minimumLineSpacing = 0.25;
                footerHeight = kWidth(88);
                break;
                
            case YFBGiftPopViewTypeBlag:
                flowLayout.minimumInteritemSpacing = 1;
                flowLayout.minimumLineSpacing = 1;
                footerHeight = kWidth(40);
                break;
                
            default:
                break;
        }
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YFBGiftPopCell class] forCellWithReuseIdentifier:YFBGiftPopCellIdentifier];
        [self addSubview:_collectionView];
        
        _footerView = [[YFBGiftFooterView alloc] initWithGiftType:type];
        _footerView.pageNumbers = 2;
        _footerView.diamondCount = 2300;
        @weakify(self);
        _footerView.sendAction = ^{
            @strongify(self);
            if (self.sendAction) {
                self.sendAction();
            }
            QBLog(@"点击赠送")
        };
        _footerView.payAction = ^{
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
            QBLog(@"点击充值")
        };
        [self addSubview:_footerView];
        {
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(3);
                make.top.equalTo(self).offset(3);
                make.right.equalTo(self.mas_right).offset(-3);
                make.bottom.equalTo(self.mas_bottom).offset(-footerHeight-3);
                make.edges.equalTo(self).mas_equalTo(UIEdgeInsetsMake(1,  1, footerHeight + 1, 1));
            }];
            
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.top.equalTo(_collectionView.mas_bottom).offset(1);
            }];
        }
    }
    return self;
}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBGiftPopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YFBGiftPopCellIdentifier forIndexPath:indexPath];
    if (_type == YFBGiftPopViewTypeList) {
        cell.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.8];
    } else if (_type == YFBGiftPopViewTypeBlag) {
        cell.backgroundColor = kColor(@"#EF5F73");
    }
    cell.title = @"棒棒糖";
    cell.diamondCount = 1800;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat fullHeight = CGRectGetHeight(collectionView.bounds);
    CGFloat itemWidth = ((long)fullWidth - /*flowLayout.sectionInset.left - flowLayout.sectionInset.right -*/ flowLayout.minimumInteritemSpacing * 3) / 4;
    CGFloat itemHeight = ((long)fullHeight - /*flowLayout.sectionInset.bottom - flowLayout.sectionInset.top -*/ flowLayout.minimumLineSpacing)/2;
    return CGSizeMake((long)itemWidth, (long)itemHeight);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    QBLog(@"%f %f",scrollView.contentOffset.x,CGRectGetWidth(self.bounds));
    if (_footerView) {
        _footerView.currentPage = scrollView.contentOffset.x / (CGRectGetWidth(self.bounds));
    }
}

@end
