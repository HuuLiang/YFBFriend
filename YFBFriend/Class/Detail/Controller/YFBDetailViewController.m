//
//  YFBDetailViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailViewController.h"
#import "YFBDetailCell.h"
#import "YFBDetailHeaderView.h"
#import "YFBDetailFooterView.h"

typedef NS_ENUM(NSUInteger, YFBDetailSection) {
    YFBDetailSpace = 0, //个人空间
    YFBDetailBaseInfo, //基本资料
    YFBDetailContactInfo,//联系方式
    YFBDetailDetailInfo,//详细资料
    YFBDetailCount
};

typedef NS_ENUM(NSUInteger, YFBDetailSpaceSection) {
    YFBSpaceSectionTitle = 0, //个人空间
    YFBSpaceSectionRecent,   //最近上线时间
    YFBSpaceSectionPurpose,  //交友目的
    YFBSpaceSectionIdea,   //恋爱观念
    YFBSpaceSectionMeeting,  //首次见面希望
    YFBSpaceSectionSite,  //喜欢约会的地点
    YFBSpaceSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailBaseInfoSection) {
    YFBBaseInfoSectionTitle = 0, //基本资料
    YFBBaseInfoSectionNickName, // 昵称
    YFBBaseInfoSectionSex, // 性别
    YFBBaseInfoSectionAge, //年龄
    YFBBaseInfoSectionLive, //居住地
    YFBBaseInfoSectionTall, //身高
    YFBBaseInfoSectionIncome, //收入
    YFBBaseInfoSectionMarr, //婚姻状况
    YFBBaseInfoSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailContactInfoSection) {
    YFBContactInfoSectionTitle = 0, //联系方式
    YFBContactInfoSectionQQ, //qq
    YFBContactInfoSectionPhone, //手机
    YFBContactInfoSectionWX, //微信
    YFBContactInfoSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailDetailInfoSection) {
    YFBDetailInfoSectionTitle = 0, //详细资料
    YFBDetailInfoSectionEdu, //学历
    YFBDetailInfoSectionJob, //职业
    YFBDetailInfoSectionBirth, //生日
    YFBDetailInfoSectionWeight,//体重
    YFBDetailInfoSectionStar, //星座
    YFBDetailInfoSectionCount
};

static NSString *const kYFBDetailCellReusableIdentifier = @"YFBDetailCellReusableIdentifier";

@interface YFBDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YFBDetailHeaderView *headerView;
@property (nonatomic,strong) YFBDetailFooterView *footerView;
@end

@implementation YFBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[YFBDetailCell class] forCellReuseIdentifier:kYFBDetailCellReusableIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#efefef");
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self configTableHeaderView];
    [self configFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTableHeaderView {
    self.headerView = [[YFBDetailHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(418));
    _headerView.backImageUrl = @"http://hwimg.jtd51.com/wysy/video/imgcover/20160818dj53.jpg";
    _headerView.userImageUrl = @"http://hwimg.jtd51.com/wysy/video/imgcover/20160818dj53.jpg";
    _headerView.nickName = @"Dior女孩";
    _headerView.userId = @"ID:55157130";
    _headerView.userLocation = @"所在地：杭州市";
    _headerView.distance = @"3km以内";
    _headerView.albumCount = @"相册:5";
    _headerView.followCount = @"关注:127701";
    _tableView.tableHeaderView = _headerView;
}

- (void)configFooterView {
    self.footerView = [[YFBDetailFooterView alloc] init];
    @weakify(self);
    _footerView.infoType = ^(YFBFooterFunction infoType) {
        @strongify(self);
        if (infoType == YFBFunctionSendMsg) {
            //发信
            
        } else if (infoType == YFBFunctionSendGreet) {
            //打招呼
            
        } else if (infoType == YFBFunctionSendFollow) {
            //关注
            
        }
    };
    [self.view addSubview:_footerView];
    
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(50));
            make.height.mas_equalTo(kWidth(120));
        }];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBDetailCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBDetailSpace) {
        return YFBSpaceSectionCount;
    } else if (section == YFBDetailBaseInfo) {
        return YFBBaseInfoSectionCount;
    } else if (section == YFBDetailContactInfo) {
        return YFBContactInfoSectionCount;
    } else if (section == YFBDetailDetailInfo) {
        return YFBDetailInfoSectionCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section == YFBDetailSpace) {
        if (indexPath.row == YFBSpaceSectionTitle) {
            cell.title = @"个人空间";
            cell.isTitle = YES;
        } else if (indexPath.row == YFBSpaceSectionRecent) {
            cell.title = @"最近上线时间";
            cell.content = @"2017-03-02 20：36：28";
        } else if (indexPath.row == YFBSpaceSectionPurpose) {
            cell.title = @"交友目的";
            cell.content = @"找对象";
        } else if (indexPath.row == YFBSpaceSectionIdea) {
            cell.title = @"恋爱观念";
            cell.content = @"顺气自然";
        } else if (indexPath.row == YFBSpaceSectionMeeting) {
            cell.title = @"首次见面希望";
            cell.content = @"喝喝茶";
        } else if (indexPath.row == YFBSpaceSectionSite) {
            cell.title = @"喜欢约会的地点";
            cell.content = @"咖啡馆";
        }
    } else if (indexPath.section == YFBDetailBaseInfo) {
        if (indexPath.row == YFBBaseInfoSectionTitle) {
            cell.title = @"基本资料";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBBaseInfoSectionNickName) {
            cell.title = @"昵称";
            cell.content = @"Dior女孩";
        } else if (indexPath.row == YFBBaseInfoSectionSex) {
            cell.title = @"性别";
            cell.content = @"女";
        } else if (indexPath.row == YFBBaseInfoSectionAge) {
            cell.title = @"年龄";
            cell.content = @"24岁";
        } else if (indexPath.row == YFBBaseInfoSectionLive) {
            cell.title = @"居住市";
            cell.content = @"杭州市";
        } else if (indexPath.row == YFBBaseInfoSectionTall) {
            cell.title = @"身高";
            cell.content = @"159cm";
        } else if (indexPath.row == YFBBaseInfoSectionIncome) {
            cell.title = @"月收入";
            cell.content = @"5000-10000";
        } else if (indexPath.row == YFBBaseInfoSectionMarr) {
            cell.title = @"婚姻状况";
            cell.content = @"未婚";
        }
    } else if (indexPath.section == YFBDetailContactInfo) {
        if (indexPath.row == YFBContactInfoSectionTitle) {
            cell.title = @"联系方式";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBContactInfoSectionQQ) {
            cell.title = @"QQ";
            cell.content = @"仅对钻石VIP开放";
        } else if (indexPath.row == YFBContactInfoSectionPhone) {
            cell.title = @"手机号";
            cell.content = @"仅对钻石VIP开放";
        } else if (indexPath.row == YFBContactInfoSectionWX) {
            cell.title = @"微信";
            cell.content = @"仅对钻石VIP开放";
        }
    } else if (indexPath.section == YFBDetailDetailInfo) {
        if (indexPath.row == YFBDetailInfoSectionTitle) {
            cell.title = @"详细资料";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBDetailInfoSectionEdu) {
            cell.title = @"学历";
            cell.content = @"本科";
        } else if (indexPath.row == YFBDetailInfoSectionJob) {
            cell.title = @"职业";
            cell.content = @"未填写";
        } else if (indexPath.row == YFBDetailInfoSectionBirth) {
            cell.title = @"生日";
            cell.content = @"1992-05-24";
        } else if (indexPath.row == YFBDetailInfoSectionWeight) {
            cell.title = @"体重";
            cell.content = @"50-55kg";
        } else if (indexPath.row == YFBDetailInfoSectionStar) {
            cell.title = @"星座";
            cell.content = @"白羊座";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(24);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == YFBDetailDetailInfo ? kWidth(24) : 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *shadowView = (UITableViewHeaderFooterView *)view;
    shadowView.backgroundView.backgroundColor = kColor(@"#efefef");
}




@end