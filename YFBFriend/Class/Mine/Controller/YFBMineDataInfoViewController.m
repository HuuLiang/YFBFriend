//
//  YFBMineDataInfoViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineDataInfoViewController.h"
#import "YFBUserDataInfoCell.h"
#import "ActionSheetPicker.h"
#import "YFBUserInfoEditView.h"
#import "YFBPhotoManager.h"
#import "YFBImageUploadManager.h"

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

@interface YFBMineDataInfoViewController () <UITableViewDelegate,UITableViewDataSource,ActionSheetMultipleStringPickerDelegate>
{
    __block YFBUserInfoEditView * _editingView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *avatarView;
@property (nonatomic,strong) UIImageView *userImageView;
@property (nonatomic,strong) UILabel *userIdLabel;
@end

@implementation YFBMineDataInfoViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[YFBUser currentUser] saveOrUpdate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (UIView *)userHeaderView {
    if (_avatarView) {
        return _avatarView;
    }
    
    self.avatarView = [[UIView alloc] init];
    _avatarView.size = CGSizeMake(kScreenWidth, kWidth(185*2));
    _avatarView.backgroundColor = kColor(@"#7FAFF6");
    
    self.userImageView = [[UIImageView alloc] init];
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:[YFBUser currentUser].userImage] placeholderImage:[UIImage imageNamed:@"mine_default_avatar_icon"]];
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
        [[YFBPhotoManager manager] getImageInCurrentViewController:self handler:^(UIImage *pickerImage, NSString *keyName) {
//            [[SDImageCache sharedImageCache] storeImage:pickerImage forKey:kYFBCurrentUserImageCacheKeyName];
            NSString *name = [NSString stringWithFormat:@"%@_avatar.jpg", [[NSDate date] stringWithFormat:KDateFormatLong]];
            [YFBImageUploadManager uploadImage:pickerImage withName:name completionHandler:^(BOOL success, id obj) {
                
            }];
            @strongify(self);
            self->_userImageView.image = pickerImage;
        }];
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
        NSString *content = [NSString stringWithFormat:@"%@,%ld,%ld,%@",[YFBUser currentUser].userSex == YFBUserSexMale?@"男" :@"女",[YFBUser currentUser].age,[YFBUser currentUser].height,[YFBUser currentUser].liveCity];
        [cell setDescTitle:content font:kFont(14)];
    } else if (indexPath.section == YFBUserInfoSectionSignature) {
        [cell setDescTitle:[YFBUser currentUser].signature font:kFont(14)];
    } else if (indexPath.section == YFBUserInfoSectionBaseInfo) {
        if (indexPath.row == YFBUserInfoIntroSectionNickName) {
            cell.title = @"昵称";
            cell.subTitle = [YFBUser currentUser].nickName;
        } else if (indexPath.row == YFBUserInfoIntroSectionSex) {
            cell.title = @"性别";
            cell.subTitle = [YFBUser currentUser].userSex == YFBUserSexMale ? @"男" : @"女";
        } else if (indexPath.row == YFBUserInfoIntroSectionAge) {
            cell.title = @"年龄";
            cell.subTitle = [NSString stringWithFormat:@"%ld岁",(long)[YFBUser currentUser].age];
        } else if (indexPath.row == YFBUserInfoIntroSectionLiveCity) {
            cell.title = @"居住市";
            cell.subTitle = [YFBUser currentUser].liveCity;
        } else if (indexPath.row == YFBUserInfoIntroSectionHeight) {
            cell.title = @"身高";
            cell.subTitle = [NSString stringWithFormat:@"%ldcm",[YFBUser currentUser].height];
        } else if (indexPath.row == YFBUserInfoIntroSectionIncome) {
            cell.title = @"月收入";
            cell.subTitle = [YFBUser currentUser].income;
        } else if (indexPath.row == YFBUserInfoIntroSectionMarrying) {
            cell.title = @"婚姻状况";
            cell.subTitle = [YFBUser currentUser].marriageStatus == YFBUserfiance ? @"未婚" : @"已婚";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.section == YFBUserInfoSectionIntro) {
        
    } else if (indexPath.section == YFBUserInfoSectionSignature) {
        [self showEditingViewWithTitle:@"个性签名" handler:^(NSString *editingInfo) {
            [YFBUser currentUser].signature = editingInfo;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else if (indexPath.section == YFBUserInfoSectionBaseInfo) {
        if (indexPath.row == YFBUserInfoIntroSectionNickName) {
            [self showEditingViewWithTitle:@"昵称" handler:^(NSString *editingInfo) {
                [YFBUser currentUser].nickName = editingInfo;
            }];
        } else if (indexPath.row == YFBUserInfoIntroSectionSex) {
            [self showActionSheetPickerWithTitle:@"性别" rows:[YFBUser allUserSex] defaultSelection:0 atIndexPath:indexPath block:^(NSString * selectedValue) {
                if ([selectedValue isEqualToString:@"男"]) {
                    [YFBUser currentUser].userSex = YFBUserSexMale;
                } else if ([selectedValue isEqualToString:@"女"]) {
                    [YFBUser currentUser].userSex = YFBUserSexFemale;
                }
            }];
        } else if (indexPath.row == YFBUserInfoIntroSectionAge) {
            [self showActionSheetPickerWithTitle:@"年龄" rows:[YFBUser allUserAge] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].age = selectedValue;
            }];
        } else if (indexPath.row == YFBUserInfoIntroSectionLiveCity) {
            ActionSheetMultipleStringPicker *picker = [[ActionSheetMultipleStringPicker alloc] initWithTitle:@"家乡"
                                                                                                        rows:[YFBUser defaultHometown]
                                                                                            initialSelection:@[@0,@0]
                                                                                                   doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
                                                       {
                                                           @strongify(self);
                                                           NSString *liveCity = [NSString stringWithFormat:@"%@%@",[selectedValues firstObject],[selectedValues lastObject]];
                                                           [YFBUser currentUser].liveCity = liveCity;
                                                           [self configRegisterDetailCellWithSelectedValue:liveCity indexPath:indexPath];
                                                       } cancelBlock:nil origin:self.view];
            picker.actionSheetDelegate = self;
            [picker showActionSheetPicker];
        } else if (indexPath.row == YFBUserInfoIntroSectionHeight) {
            [self showActionSheetPickerWithTitle:@"身高" rows:[YFBUser allUserHeight] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].height = [selectedValue integerValue];
            }];
        } else if (indexPath.row == YFBUserInfoIntroSectionIncome) {
            [self showActionSheetPickerWithTitle:@"收入" rows:[YFBUser allUserIncome] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].income = selectedValue;
            }];
        } else if (indexPath.row == YFBUserInfoIntroSectionMarrying) {
            [self showActionSheetPickerWithTitle:@"婚姻状况" rows:[YFBUser allUserMarr] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].marriageStatus = [selectedValue isEqualToString:@"未婚"] ? YFBUserfiance : YFBUserMarried;
            }];
        }
    } else if (indexPath.section == YFBUserInfoSectionCantact) {
        if (indexPath.row == YFBUserInfoContactSectionQQ)  {
            [self showEditingViewWithTitle:@"QQ" handler:^(NSString *editingInfo) {
                [YFBUser currentUser].QQNumber = editingInfo;
                [self configRegisterDetailCellWithSelectedValue:editingInfo indexPath:indexPath];
            }];
        } else if (indexPath.row == YFBUserInfoContactSectionWX) {
            [self showEditingViewWithTitle:@"微信" handler:^(NSString *editingInfo) {
                [YFBUser currentUser].WXNumber = editingInfo;
                [self configRegisterDetailCellWithSelectedValue:editingInfo indexPath:indexPath];
            }];
        } else if (indexPath.row == YFBUserInfoContactSectionPhone) {
            [self showEditingViewWithTitle:@"手机号" handler:^(NSString *editingInfo) {
                [YFBUser currentUser].phoneNumber = editingInfo;
                [self configRegisterDetailCellWithSelectedValue:editingInfo indexPath:indexPath];
            }];
        }
    } else if (indexPath.section == YFBUserInfoSectionDetail) {
        if (indexPath.row == YFBUserInfoDetailSectionEdu) {
            [self showActionSheetPickerWithTitle:@"学历" rows:[YFBUser allUserEdu] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].education = selectedValue;
            }];
        } else if (indexPath.row == YFBUserInfoDetailSectionJob) {
            [self showActionSheetPickerWithTitle:@"职业" rows:[YFBUser allUserJob] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].job = selectedValue;
            }];
        } else if (indexPath.row == YFBUserInfoDetailSectionBirth) {
            [ActionSheetDatePicker showPickerWithTitle:@"生日选择"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[YFBUtil dateFromString:KBirthDaySeletedDate WithDateFormat:kDateFormatShort]
                                           minimumDate:[YFBUtil dateFromString:kBirthDayMinDate WithDateFormat:kDateFormatShort]
                                           maximumDate:[YFBUtil dateFromString:kBirthDayMaxDate WithDateFormat:kDateFormatShort]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 @strongify(self);
                                                 NSDate *newDate = [selectedDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:selectedDate]];
                                                 if (newDate) {
                                                     NSString *newDateStr = [YFBUtil timeStringFromDate:newDate WithDateFormat:kDateFormatChina];
                                                     [YFBUser currentUser].birthday = newDateStr;
                                                     [self configRegisterDetailCellWithSelectedValue:newDateStr indexPath:indexPath];
                                                 }
                                             } cancelBlock:nil origin:self.view];

        } else if (indexPath.row == YFBUserInfoDetailSectionWeight) {
            [self showActionSheetPickerWithTitle:@"体重" rows:[YFBUser allUserWeight] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].weight = selectedValue;
            }];
        } else if (indexPath.row == YFBUserInfoDetailSectionStar) {
            [self showActionSheetPickerWithTitle:@"星座" rows:[YFBUser allUserStars] defaultSelection:0 atIndexPath:indexPath block:^(id selectedValue) {
                [YFBUser currentUser].star = selectedValue;
            }];
        }
    }
}

- (void)showActionSheetPickerWithTitle:(NSString *)title
                                  rows:(NSArray *)strings
                      defaultSelection:(NSInteger)index
                           atIndexPath:(NSIndexPath *)indexPath block:(void (^)(id selectedValue))handler {
    @weakify(self);
    [ActionSheetStringPicker showPickerWithTitle:title
                                            rows:strings
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           @strongify(self);
                                           handler(selectedValue);
                                           [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                       } cancelBlock:nil origin:self.view];

}

- (void)configRegisterDetailCellWithSelectedValue:(id)selectedValue indexPath:(NSIndexPath *)indexPath {
    YFBUserDataInfoCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
    cell.subTitle = selectedValue;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:YFBUserInfoSectionIntro] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- ActionSheetMultipleStringPickerDelegate

- (NSArray *)refreshDataSource:(NSArray *)dataSource atSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *array = [dataSource firstObject];
    NSString *province = array[row];
    NSArray *cities = [YFBUser allCitiesWihtProvince:province];
    return cities;
}

#pragma mark - UIEditingView

- (void)showEditingViewWithTitle:(NSString *)string handler:(void(^)(NSString *editingInfo))handler {
    [self.view beginLoading];
    @weakify(self);
    _editingView = [[YFBUserInfoEditView alloc] initWithTitle:string hander:^(NSString *textFieldContent) {
        @strongify(self);
        handler(textFieldContent);
    }];
    _editingView.cancel = ^{
        @strongify(self);
        [self->_editingView removeFromSuperview];
        self->_editingView = nil;
        [self.view endLoading];
    };
    _editingView.frame = CGRectMake((kScreenWidth - kWidth(680))/2, (kScreenHeight-kWidth(450))/2-64, kWidth(680), kWidth(450));
    [self.view addSubview:_editingView];
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _editingView.frame = CGRectMake((kScreenWidth - kWidth(680))/2, kScreenHeight - kWidth(450)-endFrame.size.height-64, kWidth(680), kWidth(450));
}


@end