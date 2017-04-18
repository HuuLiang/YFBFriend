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
    YFBGiftFooterView *_footerView;
    CGFloat _footerHeight;
    CGFloat _edg;
}
@end

@implementation YFBGiftPopView

- (instancetype)initWithGiftModels:(NSArray *)giftModels edg:(CGFloat)edg footerHeight:(CGFloat)height{
    
    if (self = [super init]) {
        _footerHeight = height;
        _edg = edg;
        self.backgroundColor = kColor(@"#ffffff");
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = kWidth(2);
        flowLayout.minimumInteritemSpacing = kWidth(2);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        self.layer.borderColor = kColor(@"#f3b050").CGColor;
        self.layer.borderWidth = edg >0 ? kWidth(4) : 0;//内边距
        _collectionView.pagingEnabled = YES;
        //        _collectionView.contentInset = insets;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = self.backgroundColor;
        
        [_collectionView registerClass:[YFBGiftPopCell class] forCellWithReuseIdentifier:YFBGiftPopCellIdentifier];
        [self addSubview:_collectionView];
        {
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(self).mas_offset(_edg);
                make.right.mas_equalTo(self).mas_offset(-_edg);
                make.bottom.mas_equalTo(self).mas_offset(-(edg + height + kWidth(2)));
            }];
        }
        
        _footerView = [[YFBGiftFooterView alloc] init];
        _footerView.backgroundColor = kColor(@"#ef5f73");
        _footerView.pageNumbers = 2;//giftModels.count % 8 == 0 ? giftModels.count/8 : giftModels.count/8 +1;
        _footerView.diamondCount = 2300;
        [self addSubview:_footerView];
        {
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self);
                make.top.mas_equalTo(_collectionView.mas_bottom).mas_offset(kWidth(2));
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
    cell.title = @"棒棒糖";
    cell.diamondCount = 1800;
    cell.backgroundColor = kColor(@"#ef5f73");
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (long)(CGRectGetWidth(self.bounds)- _edg*2 - 3*kWidth(2)) /4.;
    QBLog(@"%f",width)
    return CGSizeMake(width, width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.x > 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x +1, 0);
    }
    _footerView.currentPage = scrollView.contentOffset.x / (CGRectGetWidth(self.bounds) - _edg*2);
}


@end
