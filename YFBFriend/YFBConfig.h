//
//  YFBConfig.h
//  YFBFriend
//
//  Created by Liang on 2017/3/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef YFBConfig_h
#define YFBConfig_h

#define YFB_CHANNEL_NO               [YFBConfiguration sharedConfig].channelNo
#define YFB_REST_APPID               @"QUBA_2029"
#define YFB_REST_PV                  @"100"
#define YFB_PAYMENT_PV               @"100"
#define YFB_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define YFB_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
//#define YFB_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", YFB_REST_APPID, YFB_CHANNEL_NO]

#define YFB_BASE_URL                    @"http://120.24.252.114/friend"//@"http://mcps.dswtg.com"
#define YFB_STANDBY_BASE_URL            @"http://sfs.dswtg.com"

#define YFB_ACTIVATION_URL              @"/mfwcps/jihuo.htm"                     //激活
#define YFB_ACCESS_URL                  @"/mfwcps/userAccess.htm"                //登录次数
#define YFB_SYSTEM_CONFIG_URL           @"/mfwcps/systemConfig.htm"              //系统配置
#define YFB_USERCREATE_URL              @"reg.service?"                          //注册
#define YFB_CHARACTER_URL               @"/mfwcps/recommend.htm"                 //推荐
#define YFB_CHARACTER_FIGURE_URL        @"/mfwcps/recommendPage.htm"              //人物
#define YFB_DYNAMIC_URL                 @"/mfwcps/moodSection.htm"               //动态
#define YFB_NEAR_PERSON_URL             @"/mfwcps/peopleNearby.htm"              //附近
#define YFB_USER_DETAIL_URL             @"/mfwcps/userDetails.htm"               //详情
#define YFB_INTERACTIVE_URL             @"/mfwcps/interactive.htm"               //交互  关注  粉丝  访问我的
#define YFB_BATCHGREET_URL              @"/mfwcps/batchGreetCreate.htm"          //批量打招呼
#define YFB_MESSAGECREATE_URL           @"/mfwcps/messageCreate.htm"             //消息新增
#define YFB_VIPUPDATE_URL               @"/mfwcps/updateUserVip.htm"             //升级VIP

#define YFB_ENCRYPT_PASSWORD            @"qb%Fr@2016_&"
#define YFB_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define YFB_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define YFB_UMENG_APP_ID                @"587ad129ae1bf845be000294"
#define YFB_QQ_APP_ID                   @""

#define YFB_WEXIN_APP_ID                @"wx2b2846687e296e95"
#define YFB_WECHAT_TOKEN                @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define YFB_WECHAT_SECRET               @"812993d98872f297bd11486512bf6141"
#define YFB_WECHAT_USERINFO             @"https://api.weixin.qq.com/sns/userinfo?"

#define YFB_UPLOAD_SCOPE                @"mfw-photo"
#define YFB_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define YFB_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"


#endif /* YFBConfig_h */
