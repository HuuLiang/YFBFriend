//
//  YFBContactViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactViewController.h"
#import "YFBContactCell.h"
#import "YFBMessageViewController.h"
#import "YFBContactManager.h"
#import "YFBVisiteModel.h"
#import "YFBVisitemeViewController.h"

static NSString *const kYFBContactCellReusableIdentifier = @"kYFBContactCellReusableIdentifier";

@interface YFBContactViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_notiLabel;
    UIButton *_deleteButton;
    UIButton *_readButton;
    NSInteger visitemeCount;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *editingView;
@property (nonatomic) NSMutableArray <YFBContactModel *>*dataSource;
@property (nonatomic) NSMutableArray *selectedIndexPathes;
@property (nonatomic) YFBVisiteModel *visiteModel;
@end

@implementation YFBContactViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, selectedIndexPathes)
QBDefineLazyPropertyInitialization(YFBVisiteModel, visiteModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[YFBContactCell class] forCellReuseIdentifier:kYFBContactCellReusableIdentifier];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];

    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"编辑" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //进入编辑模式
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            [self animationEditingViewHidden:NO];
            [_tableView setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"全选" style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"全选"]) {
                    //全选
                    //获取表格视图内容的尺寸
                    CGSize size = self.tableView.contentSize;
                    CGRect rect = CGRectMake(0, 0, size.width, size.height);
                    //获取指定区域的cell的indexPath
                    NSArray * indexPathes = [self.tableView indexPathsForRowsInRect:rect];
                    for (NSIndexPath * indexPath in indexPathes) {
                        //使用代码方式选中一行
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }
                    [self.selectedIndexPathes removeAllObjects];
                    [self.selectedIndexPathes addObjectsFromArray:indexPathes];

                } else if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"全不选"]) {
                    for (NSIndexPath * indexPath in self.selectedIndexPathes) {
                        //使用代码方式取消选中一行
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                    //清空选中cell的记录数组
                    [self.selectedIndexPathes removeAllObjects];
                    self.navigationItem.leftBarButtonItem.title = @"全选";
                }
                
            }];
        } else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]) {
            [self.selectedIndexPathes removeAllObjects];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self animationEditingViewHidden:YES];
            [self->_tableView setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem = nil;
        }
    }];
    
    [self loadVisitemeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateBadgeNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeNumber) name:KUpdateContactUnReadMessageNotification object:nil];
}

- (void)loadVisitemeData {
    @weakify(self);
    [self.visiteModel fetchVisitemeInfoWithCompletionHandler:^(BOOL success, YFBVisiteResponse * visiteResponse) {
        @strongify(self);
        if (success) {
            self->visitemeCount = visiteResponse.userList.count;
            self->_tableView.tableHeaderView = [self configHeaderView];
        }
    }];
}

- (void)loadContactData {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[[YFBContactManager manager] loadAllContactInfo]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateBadgeNumber {
    
    __block NSInteger unreadMessages = 0;
    [[[YFBContactManager manager] loadAllContactInfo] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unreadMessages += obj.unreadMsgCount;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadContactData];

        if (unreadMessages > 0) {
            if (unreadMessages < 100) {
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
            } else {
                self.navigationController.tabBarItem.badgeValue = @"99+";
            }
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    });
                
}

- (void)animationEditingViewHidden:(BOOL)hidden {
    if (!_editingView) {
        self.editingView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kWidth(98))];
        [self.view addSubview:_editingView];
        [self.view bringSubviewToFront:_editingView];
        
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
        
        @weakify(self);
        [_deleteButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            //删除数组的元素会影响后面的顺序，需要倒序删除
            NSArray * newIndexPathes = [self.selectedIndexPathes sortedArrayUsingSelector:@selector(compare:)];
            for (NSInteger i = newIndexPathes.count-1; i>= 0 ; i--) {
                NSIndexPath * indexPath = newIndexPathes[i];
                //删除数据源中的数据
                YFBContactModel *contactModel = self.dataSource[indexPath.row];
                [contactModel deleteObject];
                [self.dataSource removeObjectAtIndex:indexPath.row];
            }
            [self.tableView deleteRowsAtIndexPaths:self.selectedIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.selectedIndexPathes removeAllObjects];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_readButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.unreadMsgCount = 0;
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        
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
    _notiLabel.text = [NSString stringWithFormat:@"今天共有%ld位女性访问你",self->visitemeCount];
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
    
    @weakify(self);
    [headerView bk_whenTapped:^{
        @strongify(self);
        YFBVisitemeViewController *visiteVC = [[YFBVisitemeViewController alloc] initWithTitle:@"最近访客"];
        [self.navigationController pushViewController:visiteVC animated:YES];
    }];
    
    return headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBContactCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBContactModel *contactModel = self.dataSource[indexPath.row];
        cell.userImgUrl = contactModel.portraitUrl;
        cell.nickName = contactModel.nickName;
        cell.recentTime = contactModel.messageTime;
        cell.msgType = contactModel.messageType;
        cell.unreadMsg = contactModel.unreadMsgCount;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = self.dataSource[indexPath.row];
    }
    if (tableView.isEditing) {
        [self.selectedIndexPathes addObject:indexPath];
        if (self.selectedIndexPathes.count == self.dataSource.count) {
            self.navigationItem.leftBarButtonItem.title = @"全不选";
        }
    } else {
        //进入聊天界面
        model.unreadMsgCount = 0;
        [model saveOrUpdate];
        [self updateBadgeNumber];
        [self pushIntoMessageVCWithUserId:model.userId nickName:model.userId avatarUrl:model.portraitUrl];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self.selectedIndexPathes removeObject:indexPath];
        if (self.selectedIndexPathes.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            self.navigationItem.leftBarButtonItem.title = @"全选";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(138);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20);
}

@end
