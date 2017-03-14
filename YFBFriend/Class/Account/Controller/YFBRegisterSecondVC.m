//
//  YFBRegisterSecondVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRegisterSecondVC.h"
#import "YFBSetAvatarView.h"
#import "XHPhotographyHelper.h"
#import "YFBRegisterDetailCell.h"
#import "ActionSheetPicker.h"
#import "YFBTabBarController.h"

static NSString *const kYFBRegisterDetailCellReusableIdentifier = @"kYFBRegisterDetailCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, YFBRegisterDetailRow) {
    YFBRegisterDetailJobRow, //职业
    YFBRegisterDetailEduRow, //学历
    YFBRegisterDetailIncomeRow, //收入
    YFBRegisterDetailTallRow, //身高
    YFBRegisterDetailMarrRow, //婚姻
    YFBRegisterDetailCount
};

@interface YFBRegisterSecondVC () <UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton    *registerButton;
@property (nonatomic,strong) YFBSetAvatarView *avatarView;
@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;
@end

@implementation YFBRegisterSecondVC
QBDefineLazyPropertyInitialization(XHPhotographyHelper, photographyHelper)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setSeparatorColor:kColor(@"#D7D7D7")];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setRowHeight:kWidth(88)];
    [_tableView registerClass:[YFBRegisterDetailCell class] forCellReuseIdentifier:kYFBRegisterDetailCellReusableIdentifier];
    _tableView.backgroundColor = kColor(@"#efefef");
    
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self configUserDetailHeaderViewAndFooterView];
}

- (void)configUserDetailHeaderViewAndFooterView {
    @weakify(self);
    _avatarView = [[YFBSetAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(420))
                                                   action:^{
                                                       @strongify(self);
                                                       UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
                                                       [actionSheet showInView:self.view];
                                                   }];
    
    self->_tableView.tableHeaderView = _avatarView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(842), kScreenWidth, kWidth(88))];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    [_registerButton setBackgroundColor:kColor(@"#8558D0")];
    _registerButton.layer.cornerRadius = kWidth(6);
    _registerButton.layer.masksToBounds = YES;
    [footerView addSubview:_registerButton];
    
    [_registerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YFBTabBarController *tabbarController = [[YFBTabBarController alloc] init];
        [self presentViewController:tabbarController animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(kWidth(670), kWidth(88)));
        }];
    }
    
    self->_tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    void (^PickerMediaBlock)(UIImage *image, NSDictionary *editingInfo) = ^(UIImage *image, NSDictionary *editingInfo) {
        if (image) {
            [self->_avatarView setUserImg:image];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return YFBRegisterDetailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRegisterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRegisterDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row == YFBRegisterDetailJobRow) {
        cell.title = @"职业";
    } else if (indexPath.row == YFBRegisterDetailEduRow) {
        cell.title = @"学历";
    } else if (indexPath.row == YFBRegisterDetailIncomeRow) {
        cell.title = @"收入";
    } else if (indexPath.row == YFBRegisterDetailTallRow) {
        cell.title = @"身高";
    } else if (indexPath.row == YFBRegisterDetailMarrRow) {
        cell.title = @"婚姻";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.row == YFBRegisterDetailJobRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"职业"
                                                rows:[YFBUser allUserJob]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                           } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == YFBRegisterDetailEduRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"学历"
                                                rows:[YFBUser allUserEdu]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                           } cancelBlock:nil origin:self.view];

    } else if (indexPath.row == YFBRegisterDetailIncomeRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"收入"
                                                rows:[YFBUser allUserIncome]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                           } cancelBlock:nil origin:self.view];

    } else if (indexPath.row == YFBRegisterDetailTallRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"身高(:cm)"
                                                rows:[YFBUser allUserHeight]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                           } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == YFBRegisterDetailMarrRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"婚姻"
                                                rows:[YFBUser allUserMarr]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                           } cancelBlock:nil origin:self.view];
    }
}

- (void)configRegisterDetailCellWithSelectedValue:(id)selectedValue indexPath:(NSIndexPath *)indexPath {
    YFBRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
    cell.content = selectedValue;
}

@end
