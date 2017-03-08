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
#define YFB_REST_APPID               @"QUBA_2027"
#define YFB_REST_PV                  @"100"
#define YFB_PAYMENT_PV               @"100"
#define YFB_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define YFB_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
//#define YFB_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", YFB_REST_APPID, YFB_CHANNEL_NO]

#define YFB_BASE_URL                    @"http://mcps.dswtg.com"//@"http://iv.zcqcmj.com"
#define YFB_STANDBY_BASE_URL            @"http://sfs.dswtg.com"

#define YFB_ACTIVATION_URL              @"/mfwcps/jihuo.htm"                     //激活
#define YFB_ACCESS_URL                  @"/mfwcps/userAccess.htm"                //登录次数
#define YFB_SYSTEM_CONFIG_URL           @"/mfwcps/systemConfig.htm"              //系统配置
#define YFB_USERCREATE_URL              @"/mfwcps/userCreate.htm"                //注册
#define YFB_CHARACTER_URL               @"/mfwcps/recommend.htm"                 //推荐
#define YFB_CHARACTER_FIGURE_URL        @"/mfwcps/recommendPage.htm"              //人物
#define YFB_DYNAMIC_URL                 @"/mfwcps/moodSection.htm"               //动态
#define YFB_NEAR_PERSON_URL             @"/mfwcps/peopleNearby.htm"              //附近
#define YFB_USER_DETAIL_URL             @"/mfwcps/userDetails.htm"               //详情
#define YFB_INTERACTIVE_URL             @"/mfwcps/interactive.htm"               //交互  关注  粉丝  访问我的
#define YFB_BATCHGREET_URL              @"/mfwcps/batchGreetCreate.htm"          //批量打招呼
#define YFB_MESSAGECREATE_URL           @"/mfwcps/messageCreate.htm"             //消息新增
#define YFB_VIPUPDATE_URL               @"/mfwcps/updateUserVip.htm"             //升级VIP

//#define YFB_TRAIL_URL                   @"/iosvideo/homePage.htm"
//#define YFB_VIPA_URL                    @"/iosvideo/vipVideo.htm"
//#define YFB_VIPB_URL                    @"/iosvideo/zsVipVideo.htm"
//#define YFB_VIPC_URL                    @"/iosvideo/hjVipVideo.htm"
//#define YFB_SEX_URL                     @"/iosvideo/channelRanking.htm"
//#define YFB_HOT_URL                     @"/iosvideo/hotTag.htm"
//#define YFB_SEARCH_URL                  @"/iosvideo/search.htm"
//#define YFB_DETAIL_URL                  @"/iosvideo/detailsg.htm"

#define PP_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define YFB_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define YFB_UMENG_APP_ID                @"587ad129ae1bf845be000294"
#define YFB_WEXIN_APP_ID                @""
#define YFB_QQ_APP_ID                   @""

#endif /* YFBConfig_h */
