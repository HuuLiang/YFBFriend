//
//  YFBBlackListVC.m
//  YFBFriend
//
//  Created by Liang on 2017/6/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBlackListVC.h"

@interface YFBBlackListVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation YFBBlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
    layout.minimumLineSpacing = kWidth(10);
    layout.minimumInteritemSpacing = kWidth(10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
