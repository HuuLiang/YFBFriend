//
//  YFBMinePhotosViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMinePhotosViewController.h"
#import "YFBMyPhotoCell.h"
#import "YFBPhotoManager.h"

static NSString *const kYFBMyPhotoCellReusableIdentifier = @"kYFBMyPhotoCellReusableIdentifier";

@interface YFBMinePhotosViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *colleciontView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YFBMinePhotosViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kWidth(20);
    layout.minimumLineSpacing = kWidth(20);
    self.colleciontView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_colleciontView registerClass:[YFBMyPhotoCell class] forCellWithReuseIdentifier:kYFBMyPhotoCellReusableIdentifier];
    _colleciontView.backgroundColor = kColor(@"#efefef");
    _colleciontView.delegate = self;
    _colleciontView.dataSource = self;
    [self.view addSubview:_colleciontView];
    
    {
        [_colleciontView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_colleciontView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_colleciontView YFB_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[[YFBPhotoManager manager] allImageKeys]];
    [self->_colleciontView reloadData];
    [self->_colleciontView YFB_endPullToRefresh];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBMyPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBMyPhotoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        cell.imageKeyName = self.dataSource[indexPath.item];
    } else if (indexPath.item == self.dataSource.count) {
        cell.functionCell = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < self.dataSource.count + 1) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 3) / 4;
        return CGSizeMake((long)width, (long)width);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.item == self.dataSource.count) {
        //增加照片
        [[YFBPhotoManager manager] getImageInCurrentViewController:self handler:^(UIImage *pickerImage, NSString *keyName) {
            @strongify(self);
            [[SDImageCache sharedImageCache] storeImage:pickerImage forKey:keyName];
            [[YFBPhotoManager manager] saveOneImageKey:keyName];
            [self->_colleciontView YFB_triggerPullToRefresh];
        }];
    }
}

@end