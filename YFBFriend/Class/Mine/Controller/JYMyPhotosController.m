//
//  JYMyPhotosController.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMyPhotosController.h"
#import "JYMyPhotoCell.h"
#import "JYMyPhotoBigImageView.h"
#import "JYUserImageCache.h"
#import "JYLocalPhotoUtils.h"

static CGFloat klineSpace = 0;
static CGFloat kitemSpace = 2.5;

static NSString *const kMyPhotoChcheIndex = @"my_photo_chche_index";
static NSString *const kMyPhotoCellIndetifier = @"myphotocell_indetifier";
static const void *kActionPopCellAssociatedKey = &kActionPopCellAssociatedKey;

@interface JYMyPhotosController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,JYLocalPhotoUtilsDelegate>
{
    UICollectionView *_layoutCollectionView;
}

//@property (nonatomic,retain) UIActionSheet *photoActionSheet;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic) BOOL isDelete;//是否是删除模式
@property (nonatomic) CGPoint currentCellPoint;
@property (nonatomic,retain) UIBarButtonItem *rightItem;
@end

@implementation JYMyPhotosController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

//- (UIActionSheet *)photoActionSheet {
//    if (_photoActionSheet) {
//        return _photoActionSheet;
//    }
//    _photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
//    
//    return _photoActionSheet;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的相册";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kWidth(kitemSpace *2);
    layout.minimumLineSpacing = kWidth(klineSpace *2);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(kWidth(15), kWidth(30), kWidth(20), kWidth(15));
    [_layoutCollectionView registerClass:[JYMyPhotoCell class] forCellWithReuseIdentifier:kMyPhotoCellIndetifier];
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
    @weakify(self);//退出删除
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadPhotoMode];
    }];
    [_layoutCollectionView JY_triggerPullToRefresh];
    
   self.rightItem =  [[UIBarButtonItem alloc] bk_initWithTitle:@"退出" style:UIBarButtonItemStyleBordered handler:^(UIBarButtonItem *sender) {
         @strongify(self);
         [self->_layoutCollectionView reloadData];
         [self quitDeletePattern];
    }];
}

- (void)loadPhotoMode {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
//        self.dataSource = [JYUserImageCache fetchAllImages].mutableCopy;
        self.dataSource = [NSMutableArray arrayWithArray:[JYImageCacheModel findAll]];
        if (!self) {
            return ;
        }
        if (self.dataSource.count == 0) {
            [self quitDeletePattern];
        }
        [self->_layoutCollectionView reloadData];
        [self->_layoutCollectionView JY_endPullToRefresh];
    });

}
/**
 退出编辑模式
 */
- (void)quitDeletePattern {
    self.isDelete = NO;
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYMyPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyPhotoCellIndetifier forIndexPath:indexPath];
    if (indexPath.item == self.dataSource.count) {
        cell.isAdd = YES;//添加照片的cell
        cell.imageUrl = nil;
        cell.isDelegate = NO;
    }else {
        NSString *imageKey = self.dataSource[indexPath.item];
        cell.isAdd = NO;
        cell.imageKey = imageKey;
        if (self.isDelete) {
            cell.isDelegate = YES;
        }else{
            cell.isDelegate = NO;
        }
        @weakify(self);
        cell.action = ^(id obj) {
            @strongify(self);
            self.isDelete = YES;
            [self->_layoutCollectionView reloadData];
            self.navigationItem.rightBarButtonItem = self.rightItem;
        };
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        CGFloat width = (kScreenWidth - kWidth(30)*2 - kWidth(kitemSpace*2)*2)/3.;
    
        return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDelete) {
        
        if (indexPath.item == self.dataSource.count) {
            return;
        }
//        JYImageCacheModel * imageModel = self.dataSource[indexPath.item];
//        [imageModel deleteObject];
//        //        [JYUserImageCache deleteCurrentImageWithIndexPath:indexPath];
//        [JYUserImageCache deleteCurrentImageWithImageKey:imageModel.imageName];
        
        [JYImageCacheModel deleteObjectWithImage:self.dataSource[indexPath.item]];
        [self.dataSource removeObjectAtIndex:indexPath.item];
        [_layoutCollectionView reloadData];
    }else{
        
        if (indexPath.item == self.dataSource.count) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            self.currentCellPoint = cell.center;
//            [self.photoActionSheet showFromTabBar:self.tabBarController.tabBar];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
            [sheet showInView:self.view];
        }else {
            //图片放大浏览
            JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:[JYImageCacheModel getAllImage] frame:self.view.window.frame isLocalImage:YES isNeedBlur:NO userId:nil];
            bigImageView.backgroundColor = [UIColor whiteColor];
            bigImageView.shouldAutoScroll = NO;
            bigImageView.shouldInfiniteScroll = NO;
            bigImageView.pageControlYAspect = 0.8;
            bigImageView.currentIndex = indexPath.item;
            
            @weakify(bigImageView);
            bigImageView.action = ^(id sender){
                @strongify(bigImageView);
                
                [UIView animateWithDuration:0.5 animations:^{
                    bigImageView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    
                    [bigImageView removeFromSuperview];
                }];
                
            };
            [self.view.window addSubview:bigImageView];
            bigImageView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                bigImageView.alpha = 1;
            }];
            
        }
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType type = NSNotFound;
    if (buttonIndex == 0) {
        //相册
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1){//相机
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary || type == UIImagePickerControllerSourceTypeCamera) {
        [JYLocalPhotoUtils shareManager].delegate = self;
        [[JYLocalPhotoUtils shareManager] getImageWithSourceType:type inViewController:self popoverPoint:self.currentCellPoint  isVideo:NO allowsEditing:YES];
    }
    
}

#pragma mark JYLocalPhotoUtilsDelegate 相机相册访问

- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    NSString *imageKey = [JYUserImageCache writeToFileWithImage:info[UIImagePickerControllerOriginalImage] needSaveImageName:NO];
//    BOOL common =  [JYUserImageCache saveImageWithImageName:imageKey];
//    if (common) {
//        JYImageCacheModel *model = [[JYImageCacheModel alloc] init];
//        model.imageName = imageKey;
//        [self.dataSource addObject:model];
//    }
    NSString *imageKey = [JYImageCacheModel saveOrUpdateWithImage:info[UIImagePickerControllerOriginalImage]];
    if (imageKey == nil) {
        [[JYHudManager manager] showHudWithText:@"您的相册已经有了这张图片"];
    }else{
        [self.dataSource addObject:imageKey];
        [_layoutCollectionView reloadData];
    }
}

@end
