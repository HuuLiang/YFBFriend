//
//  YFBTabBarController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBTabBarController.h"
#import "YFBNavigationController.h"
#import "YFBDiscoverViewController.h"
#import "YFBContactViewController.h"
#import "YFBMineViewController.h"


#define WakeGiftManagerTimeInterval (60 * 5)

@interface YFBTabBarController () <UITabBarControllerDelegate>

@end

@implementation YFBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.tabBar.layer.borderWidth = 0.5;
    [self setChildViewControllers];

    [self performSelector:@selector(wakeAskGiftManager) withObject:nil afterDelay:WakeGiftManagerTimeInterval];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)wakeAskGiftManager {
    
}

- (void)setChildViewControllers {
    YFBDiscoverViewController *discoverVC = [[YFBDiscoverViewController alloc] initWithTitle:@"发现"];
    YFBNavigationController *discoverNav = [[YFBNavigationController alloc] initWithRootViewController:discoverVC];
    discoverNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:discoverVC.title
                                                          image:[[UIImage imageNamed:@"discover_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                  selectedImage:[[UIImage imageNamed:@"discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YFBContactViewController *contactVC = [[YFBContactViewController alloc] initWithTitle:@"消息"];
    YFBNavigationController *contactNav = [[YFBNavigationController alloc] initWithRootViewController:contactVC];
    contactNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:contactVC.title
                                                           image:[[UIImage imageNamed:@"contact_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"contact_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    YFBMineViewController *mineVC = [[YFBMineViewController alloc] initWithTitle:@"我的"];
    YFBNavigationController *mineNav = [[YFBNavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                          image:[[UIImage imageNamed:@"mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[discoverNav,contactNav,mineNav];
}


@end
