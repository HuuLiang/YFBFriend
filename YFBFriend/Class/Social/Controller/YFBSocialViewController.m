//
//  YFBSocialViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/6/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSocialViewController.h"
#import "YFBSliderView.h"
#import "YFBSocialModel.h"
#import "YFBSocialCell.h"

static NSString *const kYFBSocialCellReusableIdentifier = @"kYFBSocialCellReusableIdentifier";

@interface YFBSocialViewController ()
@property (nonatomic) YFBSliderView *sliderView;
@end

@implementation YFBSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的礼物";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sliderView = [[YFBSliderView alloc] init];
    NSArray *titles = @[@"全部服务",@"暖心陪聊",@"线上游戏",@"虚拟女朋友"];
    _sliderView.titlesArr = titles;
    [_sliderView setTabbarHeight:49];
    [self.view addSubview:_sliderView];

    YFBSocialContentViewController *allVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeAll];
    YFBSocialContentViewController *chatVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeChat];
    YFBSocialContentViewController *gameVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGame];
    YFBSocialContentViewController *gfVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGF];
    [_sliderView addChildViewController:allVC title:_sliderView.titlesArr[0]];
    [_sliderView addChildViewController:chatVC title:_sliderView.titlesArr[1]];
    [_sliderView addChildViewController:gameVC title:_sliderView.titlesArr[2]];
    [_sliderView addChildViewController:gfVC title:_sliderView.titlesArr[3]];
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end



@interface YFBSocialContentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) YFBSocialType socialType;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray <YFBSocialInfo *> *dataSource;
@property (nonatomic) NSMutableArray *heights;
@property (nonatomic) YFBSocialModel *socialModel;
@end

@implementation YFBSocialContentViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBSocialModel, socialModel)
QBDefineLazyPropertyInitialization(NSMutableArray, heights)

- (instancetype)initWithSocialType:(YFBSocialType)socialType {
    self = [super init];
    if (self) {
        _socialType = socialType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#ffffff");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBSocialCell class] forCellReuseIdentifier:kYFBSocialCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self getSocialContent];
    }];
    
    [_tableView YFB_addPagingRefreshWithNotice:@"—————— 我是有底线的 ——————" Handler:^{
        @strongify(self);
        [self.tableView YFB_endPullToRefresh];
    }];
    
    [_tableView YFB_triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getSocialContent {
    @weakify(self);
    [self.socialModel fetchSocialContentWithType:_socialType CompletionHandler:^(BOOL success, NSArray <YFBSocialInfo *> * cityServices) {
        @strongify(self);
        [self calculateContentHeightWithSource:cityServices];
        [self.tableView YFB_endPullToRefresh];
    }];
}

- (void)calculateContentHeightWithSource:(NSArray <YFBSocialInfo *> *)cityLists {
    [cityLists enumerateObjectsUsingBlock:^(YFBSocialInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat cellHeight = 0;
        cellHeight = cellHeight + kWidth(34) + kWidth(80); // 头像高度
        //文字动态高度
        CGFloat descHeight = [obj.describe sizeWithFont:nil maxWidth:kWidth(560)].height;
        if (descHeight / kFont(14).lineHeight > 3) {
            obj.needShowButton = YES;
            
            //如果文字行数大于3行  则需要隐藏多余的文字 加入查看全文按钮
            cellHeight = cellHeight + kFont(14).lineHeight * 3;
            
            // + 按钮高度
            cellHeight = cellHeight + kWidth(10) + kWidth(28);

        } else {
            cellHeight  = cellHeight + kWidth(10) + descHeight;
        }
        
        cellHeight = cellHeight + kWidth(26)+ (kScreenWidth - kWidth(210))/3; //图片高度
        cellHeight = cellHeight + kWidth(56) + kWidth(28); //服务评价高度
        
        for (NSInteger i = 0; i < obj.comments.count; i ++) {
            YFBCommentModel *commentModel = obj.comments[i];
            if (i <= 1) {
                CGFloat commentContentHeight = [commentModel.content sizeWithFont:kFont(12) maxWidth:kWidth(560)].height;
                CGFloat commentHeight = kWidth(24) + kWidth(34) + kWidth(4) + kWidth(22) + kWidth(20) + commentContentHeight + kWidth(20);
                cellHeight = cellHeight + (i == 0 ? kWidth(20) : 0) + commentHeight ;//第一条评价高度
            }
        }
        
        cellHeight = cellHeight + kWidth(70) ; //查看全部评价高度
        [self.dataSource addObject:obj];
        [self.heights addObject:@(cellHeight)];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSocialCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBSocialInfo *socialInfo = self.dataSource[indexPath.row];
        
        cell.userImgUrl = socialInfo.portraitUrl;
        cell.nickName = socialInfo.nickName;
        cell.serverCount = socialInfo.servNum;
        cell.serverRate = socialInfo.star;
        cell.descStr = socialInfo.describe;
        cell.imgUrlA = socialInfo.imgUrl1;
        cell.imgUrlB = socialInfo.imgUrl2;
        cell.imgUrlC = socialInfo.imgUrl3;
        cell.firstCommentModel = socialInfo.comments[0];
        cell.secondCommentModel = socialInfo.comments[1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.heights.count) {
        return [self.heights[indexPath.row] floatValue];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01f : kWidth(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = kColor(@"#efefef");
    return sectionHeaderView;
}

@end


