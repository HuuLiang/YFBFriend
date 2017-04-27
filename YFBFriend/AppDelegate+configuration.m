//
//  AppDelegate+configuration.m
//  YFBFriend
//
//  Created by Liang on 2017/3/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate+configuration.h"
#import "YFBSystemConfigModel.h"
#import <QBPaymentManager.h>
#import <QBPaymentConfig.h>
#import <WXApi.h>
#import "YFBAccountManager.h"
#import "YFBImageUploadManager.h"
#import "YFBDiamondManager.h"
#import "YFBGiftManager.h"

static NSString *const kAliPaySchemeUrl = @"YFBFriendAliPayUrlScheme";

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate (configuration)

- (void)checkNetworkInfoState {
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = YFB_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([YFB_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = YFB_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = YFB_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = NO;
    [QBNetworkingConfiguration defaultConfiguration].encryptedType = QBURLEncryptedTypeNew;
    [QBNetworkingConfiguration defaultConfiguration].encryptionPasssword = YFB_ENCRYPT_PASSWORD;
#ifdef DEBUG
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:YFB_REST_APPID
                                                     paymentPv:@([YFB_PAYMENT_PV integerValue])
                                                     channelNo:YFB_CHANNEL_NO
                                                     urlScheme:kAliPaySchemeUrl
                                                 defaultConfig:[self setDefaultPaymentConfig]];
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        [self showHomeViewController];
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![YFBUtil isRegisteredUUID] || ![YFBSystemConfigModel sharedModel].loaded)) {
            if ([YFBUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
            }else{
                [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
            }
        }
    };
}

- (void)showHomeViewController {
    //设置默认配置信息  微信注册  七牛注册  加载钻石 礼物信息
    [WXApi registerApp:YFB_WEXIN_APP_ID];
    [YFBImageUploadManager registerWithSecretKey:YFB_UPLOAD_SECRET_KEY accessKey:YFB_UPLOAD_ACCESS_KEY scope:YFB_UPLOAD_SCOPE];
    [[YFBDiamondManager manager] getDiamondListCache];
    [[YFBGiftManager manager] getGiftListCache];
    
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
}

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3009833585";
    iAppPayConfig.privateKey = @"MIICXAIBAAKBgQCUQdOH7B8xMBvAv2W+4qGtIQnVEIPEMic+T2GYYGCtx9VCoFXB/flUv6SPGkbUcvkafk9Goh2+Qk6jPzTBYt0FlrbJg1BBs0XcKaR/YE+P8eaQVuOgdaffD4G38kMwwJBbOFzyg/n4ovQx3tyURn4Cz/4AKeiV7pyoDFhvUxfXkQIDAQABAoGAbi19RkXz6FoYReX3dyR1gnRLGkxroCKlh2j23obBUmRv2FPPZ5uW76R8ZtzgRoIrHcVApP1VnU8poagXTKBsH9lYcjuDXDx3nGkop7K69oddzwMvR+RiMva5ryBjAD8kZZYGP/1ZqNts6Hg+vXGLn4gRdrXCHFcEpaqVZeR55QECQQDKnCDUaN9c9MEtctf40JeMMRatKaMP/73BvsyXD1jfjdFJw5tER/AUTMC9omyds93rY6nPZJI0qfmQy48Q5U1LAkEAu1Mc+PdoDo81Y3ElEuClS1zicjrFya68QL5Y4q0cqU+3tjCa2J9UpBG5Qqk4j9kxPHtlHgBjIbjWmjBHkL9xEwJAU/Ql1l4uT8JLWZ3AyCUG5txgXRhnrPV3l5SMCfweA2QsWLho2f5FCORU6T8oaqBhUGxXrMwrmQ7ljo4KliGtyQJAeohaWkzTpzpsDNk1DA0gcpSWl2v0dwGyqJMaZ2QfbGz12dofX/WREyV4zq8MjaPfvhVlRmOwdJ2I2yEbnwZrOwJBAKE+Xh5mXoGv+IFaKPbenlTmk38Zcxaokx8gvdzHaJQOQtFhkf/eFOhXGGufpeQOHIdGFTjjoOKKPh5y7XzMrLc=";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQClu8EKXBq54ne+/GGxa09a6xa/8rKJZDnQ8CFe6D9xQLdV9P84kna6A5kqSZOiz3WnWGXDeCL+4M6N+5SiVPkF1cY5Im+eFevsIi2zGO3xUQ5SuVMrEeV86jNS/2VOgWlFWlWHVYndWxAZW7S0QdY0b/Fd+B40r2gwbMAXznsu5QIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = kQBIAppPayConfigName;
    payConfig.wechat = @"kQBIAppPayConfigName";
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    [config setAsCurrentConfig];
    
    return config;
}

- (void)setCommonStyle {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UINavigationBar appearance] setBarTintColor:kColor(@"#8458D0")];
    [[UINavigationBar appearance] setBackgroundColor:kColor(@"#8458D0")];
    [[UINavigationBar appearance] setTranslucent:YES];
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navi_back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navi_back"]];
    
//    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
//                              withOptions:AspectPositionAfter
//                               usingBlock:^(id<AspectInfo> aspectInfo){
//                                   UIViewController *thisVC = [aspectInfo instance];
//                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"  " style:UIBarButtonItemStylePlain handler:nil];
//                                   thisVC.navigationController.navigationBar.translucent = NO;
//                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
     {
         UIViewController *thisVC = [aspectInfo instance];
         BOOL hidesBottomBar = NO;
         if (thisVC.navigationController.viewControllers.count > 1) {
             hidesBottomBar = YES;
         }
         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
     } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    QBLog(@"%@",req);
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [[YFBAccountManager manager] sendAuthRespCode:(SendAuthResp *)resp];
    }
}

#pragma mark - QQApiInterfaceDelegate



@end
