//
//  AppDelegate.m
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+configuration.h"
#import "YFBLaunchViewController.h"
#import "YFBNavigationController.h"
#import "YFBLocalNotificationManager.h"
#import "YFBTabBarController.h"

@interface AppDelegate () 

@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    return _window;
}

- (UIViewController *)contentViewController {
    if (_contentViewController) {
        return _contentViewController;
    }
    YFBTabBarController *tabbarVC = [[YFBTabBarController alloc] init];
    _contentViewController = tabbarVC;
    return _contentViewController;
}

- (UIViewController *)launchViewController {
    YFBLaunchViewController *launchVC = [[YFBLaunchViewController alloc] init];
    YFBNavigationController *launchNav = [[YFBNavigationController alloc] initWithRootViewController:launchVC];
    _launchViewController = launchNav;
    return _launchViewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkLocalNotificationWithLaunchOptionsOptions:launchOptions];
    [self checkNetworkInfoState];
    [self setCommonStyle];
    [self showHomeViewController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self setApplicationIconBadgeNumber:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[YFBLocalNotificationManager manager] setAutoNotification];
}


@end
