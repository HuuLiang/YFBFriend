//
//  YFBBaseViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"
#import "YFBDetailViewController.h"

@interface YFBBaseViewController ()

@end

@implementation YFBBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushIntoDetailVC:(NSString *)userID {
    YFBDetailViewController *detailVC = [[YFBDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
