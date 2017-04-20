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

//#define YFB_ACTIVATION_URL              @"/mfwcps/jihuo.htm"                     //激活
//#define YFB_ACCESS_URL                  @"/mfwcps/userAccess.htm"                //登录次数
//#define YFB_SYSTEM_CONFIG_URL           @"/mfwcps/systemConfig.htm"              //系统配置
#define YFB_USERCREATE_URL              @"reg.service"                          //注册
#define YFB_GREETINFO_URL               @"oneKeyUserList.service"               //获取一键打招呼用户列表
#define YFB_GREET_URL                   @"oneKeyGreet.service"                 //一键打招呼
#define YFB_RMDNEARBY_URL               @"rmdNearby.service"                    //推荐和附近的人
#define YFB_RANK_URL                    @"fengyun.service"                      //风云榜
#define YFB_DETAIL_URL                  @"personDtl.service"                    //详情页
#define YFB_MSGLIST_URL                 @"msgList.service"                      //消息列表
#define YFB_MY_GIFT_URL                 @"recvOrSendGiftList.service"           //我的礼物
#define YFB_GIFTLIST_URL                @"giftList.service"                     //获取礼物列表
#define YFB_DIAMONLIST_URL              @"dpcList.service"                      //获取钻石数量和价格列表
#define YFB_ATTENTIONLIST_URL           @"concernList.service"                  //用户关注列表
#define YFB_CONCERN_URL                 @"concern.service"                      //关注
#define YFB_CANCELCONCERN_URL           @"cancelConcern.service"                //取消关注
#define YFB_FEEDBACK_URL                @"feedback.service"                     //意见反馈


#define YFB_ENCRYPT_PASSWORD            @"qb%Fr@2016_&"
#define YFB_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define YFB_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define YFB_UMENG_APP_ID                @"587ad129ae1bf845be000294"
#define YFB_QQ_APP_ID                   @""

#define YFB_WEXIN_APP_ID                @"wx2b2846687e296e95"
#define YFB_WECHAT_TOKEN                @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define YFB_WECHAT_SECRET               @"812993d98872f297bd11486512bf6141"
#define YFB_WECHAT_USERINFO             @"https://api.weixin.qq.com/sns/userinfo?"

#define YFB_UPLOAD_SCOPE                @"mfw-image"
#define YFB_UPLOAD_SECRET_KEY           @"JIWlLAM3_bGrfTyU16XKjluzYKcsHOB--yDFB4zt"
#define YFB_UPLOAD_ACCESS_KEY           @"9mmo2Dd9oca-2SJ5Uou9qQ1d2XjNIoX9EdrPQ6Xj"


#endif /* YFBConfig_h */
