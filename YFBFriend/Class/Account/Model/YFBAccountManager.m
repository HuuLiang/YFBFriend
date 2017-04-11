//
//  YFBAccountManager.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAccountManager.h"
#import <WXApi.h>
#import <AFNetworking.h>

@implementation YFBAccountManager

+ (instancetype)manager {
    static YFBAccountManager *_accountManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountManger = [[YFBAccountManager alloc] init];
    });
    return _accountManger;
}

- (void)loginWithWX {
    SendAuthReq *loginReq = [[SendAuthReq alloc] init];
    loginReq.scope = @"snsapi_userinfo";
    loginReq.state = @"123";
    loginReq.openID = @"100";
    [WXApi sendReq:loginReq];
}

- (void)loginWithAccountAndPassword {
    
}


- (void)sendAuthRespCode:(SendAuthResp *)resp {
    NSString *tokenUrl = [NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code",YFB_WECHAT_TOKEN,YFB_WEXIN_APP_ID,YFB_WECHAT_SECRET,resp.code];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:tokenUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * tokenDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (tokenDic[@"errcode"] != nil) {
            [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",tokenDic[@"errcode"],tokenDic[@"errmsg"]]];
        }
        [self getUserInfoWithTokenDic:tokenDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getUserInfoWithTokenDic:(NSDictionary *)tokenDic {
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@access_token=%@&openid=%@&lang=%@",YFB_WECHAT_USERINFO,tokenDic[@"access_token"],tokenDic[@"openid"],@"zh_CN"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:userInfoUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * userInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        QBLog(@"responseObject:%@ \n userInfoDic:%@",responseObject,userInfoDic);
        if (userInfoDic[@"errcode"] != nil) {
            [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",userInfoDic[@"errcode"],userInfoDic[@"errmsg"]]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];

}

@end
