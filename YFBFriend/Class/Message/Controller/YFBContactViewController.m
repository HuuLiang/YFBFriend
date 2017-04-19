//
//  YFBContactViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactViewController.h"
#import "YFBContactCell.h"
#import "YFBContactModel.h"
#import "YFBMessageViewController.h"

static NSString *const kYFBContactCellReusableIdentifier = @"kYFBContactCellReusableIdentifier";

@interface YFBContactViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_notiLabel;
    UIButton *_deleteButton;
    UIButton *_readButton;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *editingView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableArray *selectedSource;
@property (nonatomic) YFBContactModel *contactModel;
@property (nonatomic) YFBContactResponse *response;
@end

@implementation YFBContactViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, selectedSource)
QBDefineLazyPropertyInitialization(YFBContactModel, contactModel)
QBDefineLazyPropertyInitialization(YFBContactResponse, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_tableView registerClass:[YFBContactCell class] forCellReuseIdentifier:kYFBContactCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_tableView YFB_triggerPullToRefresh];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"编辑" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //进入编辑模式
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            [self animationEditingViewHidden:NO];
            [_tableView setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"全选" style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                //全选
            }];
        } else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]) {
            [self.selectedSource removeAllObjects];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self animationEditingViewHidden:YES];
            [self->_tableView setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem = nil;
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.contactModel fetchContactInfoWithCompletionHandler:^(BOOL success, YFBContactResponse * obj) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            self.response = obj;
            self->_tableView.tableHeaderView = [self configHeaderView];
            [self->_tableView reloadData];
        }
    }];
}

- (void)animationEditingViewHidden:(BOOL)hidden {
    if (!_editingView) {
        self.editingView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kWidth(98))];
        [self.view addSubview:_editingView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _deleteButton.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
        [_editingView addSubview:_deleteButton];
        
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readButton setTitle:@"全部设为已读" forState:UIControlStateNormal];
        _readButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _readButton.backgroundColor = [UIColor colorWithHexString:@"#8458D0"];
        _readButton.layer.cornerRadius = 5;
        _readButton.layer.masksToBounds = YES;
        [_editingView addSubview:_readButton];
        
        {
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_editingView);
                make.left.equalTo(_editingView).offset(kWidth(20));
                make.right.equalTo(_editingView.mas_centerX).offset(-kWidth(7));
                make.height.mas_equalTo(kWidth(72));
            }];
            
            [_readButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_editingView);
                make.right.equalTo(_editingView).offset(-kWidth(20));
                make.left.equalTo(_editingView.mas_centerX).offset(kWidth(7));
                make.height.mas_equalTo(kWidth(72));
            }];
        }
    }
    self.navigationItem.leftBarButtonItem.customView.hidden = hidden;

    if (hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _editingView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kWidth(98));
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _editingView.frame = CGRectMake(0, kScreenHeight-kWidth(98), kScreenWidth, kWidth(98));
        }];
    }
}

- (UIView *)configHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.size = CGSizeMake(kScreenWidth, kWidth(84));
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:@"谁看过我" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"contact_eye"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    [headerView addSubview:titleButton];
    
    UIEdgeInsets imageEdge = titleButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = titleButton.titleEdgeInsets;
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left - 2.5, imageEdge.bottom, imageEdge.right + 2.5);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left + 2.5, titleEdge.bottom, titleEdge.right - 2.5);

    
    _notiLabel = [[UILabel alloc] init];
    _notiLabel.text = [NSString stringWithFormat:@"今天共有%ld位女性访问你",self.response.visitMeCount];
    _notiLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    _notiLabel.textColor = [UIColor colorWithHexString:@"#97BCF0"];
    [headerView addSubview:_notiLabel];
    
    UIImageView *intoImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_into"]];
    [headerView addSubview:intoImageV];
    
    {
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(190), kWidth(40)));
        }];
        
        [intoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView.mas_right).offset(-kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(44)));
        }];
        
        [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(intoImageV.mas_left).offset(-kWidth(26));
            make.height.mas_equalTo(kWidth(36));
        }];
    }
    
    return headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBContactCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.response.userList.count) {
        YFBContactUserModel *userInfo = self.response.userList[indexPath.row];
        cell.userImgUrl = userInfo.portraitUrl;
        cell.nickName = userInfo.nickName;
        cell.recentTime = [userInfo.robotMsgList lastObject].sendTime;
        cell.msgType = [[userInfo.robotMsgList lastObject].msgType integerValue];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactUserModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = self.response.userList[indexPath.row];
    }
    if (tableView.isEditing) {
        if (!model) {
            [self.selectedSource addObject:model];
        }
    } else {
        //进入聊天界面
        [self pushIntoMessageVCWithUserId:model.userId nickName:model.userId avatarUrl:model.portraitUrl];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactUserModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = self.response.userList[indexPath.row];
    }
    if (tableView.isEditing) {
        
    } else {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(138);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20);
}

@end
