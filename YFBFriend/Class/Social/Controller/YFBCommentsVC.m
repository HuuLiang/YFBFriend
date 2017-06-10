//
//  YFBCommentsVC.m
//  YFBFriend
//
//  Created by Liang on 2017/6/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBCommentsVC.h"
#import "YFBSocialModel.h"
#import "YFBCommentCell.h"

static NSString *const kYFBSocialCommentCellReusableIdentifier = @"kYFBSocialCommentCellReusableIdentifier";

@interface YFBCommentsVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray <YFBCommentModel *> * dataSource;
@property (nonatomic) NSMutableArray *heights;
@end

@implementation YFBCommentsVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, heights);

- (instancetype)initWithComments:(NSArray *)comments {
    self = [super init];
    if (self) {
        [self.dataSource addObjectsFromArray:comments];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评价";
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#efefef");
    [_tableView registerClass:[YFBCommentCell class] forCellReuseIdentifier:kYFBSocialCommentCellReusableIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];

    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self calculateCommentHeight];
    
    [_tableView reloadData];
}

- (void)calculateCommentHeight {
    [self.dataSource enumerateObjectsUsingBlock:^(YFBCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat commentContentHeight = [obj.content sizeWithFont:kFont(12) maxWidth:kWidth(690)].height;
        CGFloat commentHeight = kWidth(30) + kFont(14).lineHeight + kWidth(10) + kFont(12).lineHeight + kWidth(30) + commentContentHeight + kWidth(40);
        [self.heights addObject:@(commentHeight)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSocialCommentCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBCommentModel *commentModel = self.dataSource[indexPath.row];
        cell.nickName = commentModel.nickName;
        cell.serverOption = commentModel.serv;
        cell.timeStr = commentModel.time;
        cell.commentStr = commentModel.content;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.heights.count) {
        return [self.heights[indexPath.row] floatValue];
    }
    return 0;
}

@end
