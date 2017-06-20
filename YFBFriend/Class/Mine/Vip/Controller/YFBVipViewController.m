//
//  YFBVipViewController.m
//  YFBFriend
//
//  Created by ylz on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVipViewController.h"

@interface YFBVipViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_needReturn) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"开通VIP";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
