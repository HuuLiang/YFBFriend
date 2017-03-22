//
//  YFBMineDataInfoViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineDataInfoViewController.h"
#import "YFBUserDataInfoCell.h"
#import "XHPhotographyHelper.h"

typedef NS_ENUM(NSUInteger,YFBUserInfoSection) {
    YFBUserInfoSectionIntro = 0,
    YFBUserInfoSectionSignature,
    YFBUserInfoSectionBaseInfo,
    YFBUserInfoSectionCantact,
    YFBUserInfoSectionDetail,
    YFBUserInfoSectionCount
};

typedef NS_ENUM(NSUInteger,YFBUserInfoIntroSection) {
    YFBUserInfoIntroSectionNickName = 0,
    YFBUserInfoIntroSectionSex,
    YFBUserInfoIntroSectionAge,
    YFBUserInfoIntroSectionLiveCity,
    YFBUserInfoIntroSectionHeight,
    YFBUserInfoIntroSectionIncome,
    YFBUserInfoIntroSectionMarrying,
    YFBUserInfoIntroSectionCount
};

typedef NS_ENUM(NSUInteger,YFBUserInfoContactSection) {
    YFBUserInfoContactSectionQQ = 0,
    YFBUserInfoContactSectionWX,
    YFBUserInfoContactSectionPhone,
    YFBUserInfoContactSectionCount
};

typedef NS_ENUM(NSUInteger,YFBUserInfoDetailSection) {
    YFBUserInfoDetailSectionEdu = 0,
    YFBUserInfoDetailSectionJob,
    YFBUserInfoDetailSectionBirth,
    YFBUserInfoDetailSectionWeight,
    YFBUserInfoDetailSectionStar,
    YFBUserInfoDetailSectionCount
};

static NSString *const kYFBMineDataInfoCellReusableIdentifier = @"YFBMineDataInfoCellReusableIdentifier";

@interface YFBMineDataInfoViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *avatarView;
@property (nonatomic,strong) UIImageView *userImageView;
@property (nonatomic,strong) UILabel *userIdLabel;
@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;
@end

@implementation YFBMineDataInfoViewController
QBDefineLazyPropertyInitialization(XHPhotographyHelper, photographyHelper)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBUserDataInfoCell class] forCellReuseIdentifier:kYFBMineDataInfoCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)userHeaderView {
    if (_avatarView) {
        return _avatarView;
    }
    
    self.avatarView = [[UIView alloc] init];
    _avatarView.size = CGSizeMake(kScreenWidth, kWidth(185*2));
    _avatarView.backgroundColor = kColor(@"#7FAFF6");
    
    self.userImageView = [[UIImageView alloc] initWithImage:[YFBUser currentUser].userImage];
    _userImageView.layer.cornerRadius = kWidth(70);
    _userImageView.layer.masksToBounds = YES;
    _userImageView.userInteractionEnabled = YES;
    [_avatarView addSubview:_userImageView];
    
    self.userIdLabel = [[UILabel alloc] init];
    _userIdLabel.textColor = kColor(@"#ffffff");
    _userIdLabel.font = kFont(17);
    _userIdLabel.text = [YFBUser currentUser].userId;
    [_avatarView addSubview:_userIdLabel];
    
    @weakify(self);
    [_userImageView bk_whenTapped:^{
        @strongify(self);
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
        [actionSheet showInView:self.view];
    }];
    
    {
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_avatarView);
            make.top.equalTo(_avatarView).offset(kWidth(82));
            make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
        }];
        
        [_userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_avatarView);
            make.top.equalTo(_userImageView.mas_bottom).offset(kWidth(30));
            make.height.mas_equalTo(kWidth(34));
        }];
    }
    
    return _avatarView;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    @weakify(self);
    void (^PickerMediaBlock)(UIImage *image, NSDictionary *editingInfo) = ^(UIImage *image, NSDictionary *editingInfo) {
        @strongify(self);
        if (image) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:kYFBCurrentUserImageCacheKeyName];
            self->_userImageView.image = image;
        }
    };
    
    if (buttonIndex == 0) {
        //相册
        [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:PickerMediaBlock];
    } else if (buttonIndex == 1)  {
        //相机
        [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self compled:PickerMediaBlock];
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBUserInfoSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBUserInfoSectionIntro || section == YFBUserInfoSectionSignature) {
        return 1;
    } else if (section == YFBUserInfoSectionBaseInfo) {
        return YFBUserInfoIntroSectionCount;
    } else if (section == YFBUserInfoSectionCantact) {
        return YFBUserInfoContactSectionCount;
    } else if (section == YFBUserInfoSectionDetail) {
        return YFBUserInfoDetailSectionCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBUserDataInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBMineDataInfoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section == YFBUserInfoSectionIntro) {
        [cell setDescTitle:@"男，20岁，未填写，浙江省 杭州市" font:kFont(17)];
    } else if (indexPath.section == YFBUserInfoSectionSignature) {
        [cell setDescTitle:@"我正在构思一个伟大的签名" font:kFont(14)];
    } else if (indexPath.section == YFBUserInfoSectionBaseInfo) {
        if (indexPath.row == YFBUserInfoIntroSectionNickName) {
            cell.title = @"昵称";
            cell.subTitle = [YFBUser currentUser].nickName;
        } else if (indexPath.row == YFBUserInfoIntroSectionSex) {
            cell.title = @"性别";
            cell.subTitle = [YFBUser currentUser].userSex == YFBUserSexMale ? @"男" : @"女";
        } else if (indexPath.row == YFBUserInfoIntroSectionAge) {
            cell.title = @"年龄";
            cell.subTitle = [YFBUser currentUser].age;
        } else if (indexPath.row == YFBUserInfoIntroSectionLiveCity) {
            cell.title = @"居住市";
            cell.subTitle = [YFBUser currentUser].liveCity;
        } else if (indexPath.row == YFBUserInfoIntroSectionHeight) {
            cell.title = @"身高";
            cell.subTitle = [YFBUser currentUser].height;
        } else if (indexPath.row == YFBUserInfoIntroSectionIncome) {
            cell.title = @"月收入";
            cell.subTitle = [YFBUser currentUser].income;
        } else if (indexPath.row == YFBUserInfoIntroSectionMarrying) {
            cell.title = @"婚姻状况";
            cell.subTitle = [YFBUser currentUser].marrying;
        }
    } else if (indexPath.section == YFBUserInfoSectionCantact) {
        if (indexPath.row == YFBUserInfoContactSectionQQ)  {
            cell.title = @"QQ";
            cell.subTitle = [YFBUser currentUser].QQNumber;
        } else if (indexPath.row == YFBUserInfoContactSectionWX) {
            cell.title = @"微信";
            cell.subTitle = [YFBUser currentUser].WXNumber;
        } else if (indexPath.row == YFBUserInfoContactSectionPhone) {
            cell.title = @"手机号";
            cell.subTitle = [YFBUser currentUser].phoneNumber;
        }
    } else if (indexPath.section == YFBUserInfoSectionDetail) {
        if (indexPath.row == YFBUserInfoDetailSectionEdu) {
            cell.title = @"学历";
            cell.subTitle = [YFBUser currentUser].education;
        } else if (indexPath.row == YFBUserInfoDetailSectionJob) {
            cell.title = @"职业";
            cell.subTitle = [YFBUser currentUser].job;
        } else if (indexPath.row == YFBUserInfoDetailSectionBirth) {
            cell.title = @"生日";
            cell.subTitle = [YFBUser currentUser].birthday;
        } else if (indexPath.row == YFBUserInfoDetailSectionWeight) {
            cell.title = @"体重";
            cell.subTitle = [YFBUser currentUser].weight;
        } else if (indexPath.row == YFBUserInfoDetailSectionStar) {
            cell.title = @"星座";
            cell.subTitle = [YFBUser currentUser].star;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(84);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBUserInfoSectionIntro) {
        return kWidth(370);
    }
    return kWidth(60);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == YFBUserInfoSectionIntro) {
        return [self userHeaderView];
    } else {
        UIView *titleHeaderView = [[UIView alloc] init];
        titleHeaderView.backgroundColor = kColor(@"#efefef");
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor(@"#666666");
        titleLabel.font = kFont(14);
        [titleHeaderView addSubview:titleLabel];
        {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleHeaderView);
                make.left.equalTo(titleHeaderView).offset(kWidth(36));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
        if (section == YFBUserInfoSectionBaseInfo) {
            titleLabel.text = @"基本资料";
        } else if (section == YFBUserInfoSectionCantact) {
            titleLabel.text = @"联系方式";
        } else if (section == YFBUserInfoSectionDetail) {
            titleLabel.text = @"详细信息";
        }
        
        return titleHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == YFBUserInfoSectionDetail) {
        return 10;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

@end
