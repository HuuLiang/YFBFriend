//
//  YFBBlackListVC.m
//  YFBFriend
//
//  Created by Liang on 2017/6/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBlackListVC.h"
#import "YFBBlackCell.h"
#import "YFBRobot.h"

static NSString *const KFYBBlackListCellReusableIdentifier = @"KFYBBlackListCellReusableIdentifier";

@interface YFBBlackListVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray <YFBRobot *> * dataSource;
@property (nonatomic) NSMutableArray <NSIndexPath *> *indexPaths;
@end

@implementation YFBBlackListVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, indexPaths)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
    layout.minimumLineSpacing = kWidth(10);
    layout.minimumInteritemSpacing = kWidth(10);
    CGFloat width = (kScreenWidth - kWidth(70))/4;
    layout.itemSize = CGSizeMake(width, width);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kColor(@"#ffffff");
    [_collectionView registerClass:[YFBBlackCell class] forCellWithReuseIdentifier:KFYBBlackListCellReusableIdentifier];
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    @weakify(self);
    [_collectionView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self.dataSource removeAllObjects];
        [self.indexPaths removeAllObjects];
        [self.dataSource addObjectsFromArray:[YFBRobot findByCriteria:[NSString stringWithFormat:@"where blackList=1"]]];
        [self.collectionView reloadData];
        [self.collectionView YFB_endPullToRefresh];
    }];
    
    [_collectionView YFB_triggerPullToRefresh];
    
    [self configRightBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"解除" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.indexPaths enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YFBRobot *robot = self.dataSource[obj.item];
            robot.blackList = NO;
            [robot saveOrUpdate];
        }];
        [_collectionView YFB_triggerPullToRefresh];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBBlackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KFYBBlackListCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.item];
        cell.userImgStr = robot.portraitUrl;
        cell.selectedCell = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBBlackCell *blackCell = (YFBBlackCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.indexPaths containsObject:indexPath]) {
        blackCell.selectedCell = NO;
        [self.indexPaths removeObject:indexPath];
    } else {
        blackCell.selectedCell = YES;
        [self.indexPaths addObject:indexPath];
    }
}

@end
