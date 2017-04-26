//
//  YFBCommonDef.h
//  YFBFriend
//
//  Created by Liang on 2017/3/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef YFBCommonDef_h
#define YFBCommonDef_h

typedef NS_ENUM(NSUInteger, YFBDeviceType) {
    YFBDeviceTypeUnknown,
    YFBDeviceType_iPhone4,
    YFBDeviceType_iPhone4S,
    YFBDeviceType_iPhone5,
    YFBDeviceType_iPhone5C,
    YFBDeviceType_iPhone5S,
    YFBDeviceType_iPhone6,
    YFBDeviceType_iPhone6P,
    YFBDeviceType_iPhone6S,
    YFBDeviceType_iPhone6SP,
    YFBDeviceType_iPhoneSE,
    YFBDeviceType_iPhone7,
    YFBDeviceType_iPhone7P,
    YFBDeviceType_iPad = 100
};

typedef NS_ENUM(NSInteger,YFBRankType) {
    YFBRankTypeSend = 0 ,//土豪榜
    YFBRankTypereceived //魅力榜
};

typedef NS_ENUM(NSInteger,YFBPayType) {
    YFBPayTypeWeiXin = 0, //微信
    YFBPayTypeAliPay //支付宝
};

typedef NS_ENUM(NSInteger,YFBGiftPopViewType) {
    YFBGiftPopViewTypeBlag = 0, //索要礼物
    YFBGiftPopViewTypeList      //赠送礼物
};

typedef NS_ENUM(NSInteger, YFBMessagePopViewType) {
    YFBMessagePopViewTypeVip, // 开通vip界面
    YFBMessagePopViewTypeDiamond //充值钻石界面
};

typedef void (^YFBAction)(void);

//
//typedef NS_ENUM(NSUInteger, YFBDynamicType) {
//    YFBDynamicTypeOnePhoto = 0,  //1张照片
//    YFBDynamicTypeTwoPhotos,     //2张照片
//    YFBDynamicTypeThreePhotos,   //3张照片
//    YFBDynamicTypeVideo,         //视频
//    YFBDynamicTypeCount
//};
//
//typedef NS_ENUM(NSUInteger, YFBMineUsersType) {
//    YFBMineUsersTypeFollow,//关注
//    YFBMineUsersTypeFans, //粉丝
//    YFBMineUsersTypeVisitor, //访客
//    YFBMineUsersTypeHeader,//头像
//    YFBMineUsersTypeCount
//};
//
//typedef NS_ENUM(NSUInteger, YFBUserCreateMessageType) {
//    YFBUserCreateMessageTypeGreet,//打招呼
//    YFBUserCreateMessageTypeFollow, //关注
//    YFBUserCreateMessageTypeChat, //聊天
//    YFBUserCreateMessageTypeCount
//};
////会员等级
//typedef NS_ENUM(NSUInteger,YFBVipType) {
//    YFBVipTypeYear = 0,
//    YFBVipTypeQuarter = 1,
//    YFBVipTypeMonth = 2,
//    YFBVipTypePacket =3 //发红包
//};

#define tableViewCellheight  MAX(kScreenHeight*0.06,44)

#define kPaidNotificationName                   @"YFBFriendPaidNotification"
#define kUserLoginNotificationName              @"YFBFriendUserLoginNotification"
#define KUserChangeInfoNotificationName         @"YFBFriendUserChangeInfoNotificationName"
#define KUpdateContactUnReadMessageNotification @"YFBUpdateContactUnReadMessageNotification"

#define kDateFormatShort                  @"yyyy-MM-dd"
#define kDateFormatChina                  @"yyyy年MM月dd日"
#define KDateFormatLong                   @"yyyyMMddHHmmss"
#define kBirthDayMinDate                  @"1942-01-01"
#define kBirthDayMaxDate                  @"2017-02-01"
#define KBirthDaySeletedDate              @"2000-01-01"

#define kWidth(width)                     kScreenWidth  * width  / 750.
#define kHeight(height)                   kScreenHeight * height / 1334.
#define kColor(hexString)                 [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",hexString]]
#define kCurrentUser                      [YFBUser currentUser]
#define kFont(font)                       [UIFont systemFontOfSize:kWidth(font*2)]
//#define YFB_SYSTEM_CONTACT_NAME_1          @"CONTACT_NAME_1"
//#define YFB_SYSTEM_CONTACT_NAME_2          @"CONTACT_NAME_2"
//#define YFB_SYSTEM_CONTACT_NAME_3          @"CONTACT_NAME_3"
//#define YFB_SYSTEM_CONTACT_SCHEME_1        @"CONTACT_SCHEME_1"
//#define YFB_SYSTEM_CONTACT_SCHEME_2        @"CONTACT_SCHEME_2"
//#define YFB_SYSTEM_CONTACT_SCHEME_3        @"CONTACT_SCHEME_3"
#define YFB_SYSTEM_IMAGE_TOKEN             @"IMG_REFERER"
#define YFB_SYSTEM_PAYPOINT_INFO           @"VIP_PAY_POINT_INFO_100"
//#define YFB_SYSTEM_PAY_HJ_AMOUNT           @"PAY_MONTH_AMOUNT"
//#define YFB_SYSTEM_PAY_ZS_AMOUNT           @"PAY_ZS_AMOUNT"
//#define YFB_SYSTEM_PAY_AMOUNT              @"PAY_AMOUNT"
//#define YFB_SYSTEM_BAIDUYU_CODE            @"BAIDUYU_CODE"
//#define YFB_SYSTEM_BAIDUYU_URL             @"BAIDUYU_URL"


#endif /* YFBCommonDef_h */
