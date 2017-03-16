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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            
        } else if (indexPath.row == YFBSpaceSectionRecent) {
            
        } else if (indexPath.row == YFBSpaceSectionPurpose) {
            
        } else if (indexPath.row == YFBSpaceSectionIdea) {
            
        } else if (indexPath.row == YFBSpaceSectionMeeting) {
            
        } else if (indexPath.row == YFBSpaceSectionSite) {
            
        }
    } else if (indexPath.section == YFBDetailBaseInfo) {
        if (indexPath.row == YFBBaseInfoSectionTitle) {
            
        } else if (indexPath.row == YFBBaseInfoSectionNickName) {
            
        } else if (indexPath.row == YFBBaseInfoSectionSex) {
            
        } else if (indexPath.row == YFBBaseInfoSectionAge) {
            
        } else if (indexPath.row == YFBBaseInfoSectionLive) {
            
        } else if (indexPath.row == YFBBaseInfoSectionTall) {
            
        } else if (indexPath.row == YFBBaseInfoSectionIncome) {
            
        } else if (indexPath.row == YFBBaseInfoSectionMarr) {
            
        }
    } else if (indexPath.section == YFBDetailContactInfo) {
        if (indexPath.row == YFBContactInfoSectionTitle) {
            
        } else if (indexPath.row == YFBContactInfoSectionQQ) {
            
        } else if (indexPath.row == YFBContactInfoSectionPhone) {
            
        } else if (indexPath.row == YFBContactInfoSectionWX) {
            
        }
    } else if (indexPath.section == YFBDetailDetailInfo) {
        if (indexPath.row == YFBDetailInfoSectionTitle) {
            
        } else if (indexPath.row == YFBDetailInfoSectionEdu) {
            
        } else if (indexPath.row == YFBDetailInfoSectionJob) {
            
        } else if (indexPath.row == YFBDetailInfoSectionBirth) {
            
        } else if (indexPath.row == YFBDetailInfoSectionWeight) {
            
        } else if (indexPath.row == YFBDetailInfoSectionStar) {
            
        }
    }
    return cell;
}


@end
