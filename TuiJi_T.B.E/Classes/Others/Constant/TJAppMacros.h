//
//  TJAppMacros.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//
/**
 *  此类定义所有的宏
 */

#ifndef TJAppMacros_h
#define TJAppMacros_h

//use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

/** *  ----------------------- 系统全局变量------------------------ */
#define TJMainScreen [UIScreen mainScreen]
#define TJKeyWindow [UIApplication sharedApplication].keyWindow

/** *  ----------------------- 屏幕宽高定义------------------------ */
#define TJHeightNavigationBar 64
#define TJHeightTabBar 45
#define TJSectionBarH 39

#define TJWidthDevice TJMainScreen.bounds.size.width
#define TJHeightDevice TJMainScreen.bounds.size.height
#define TJWidthFullView self.frame.size.width
#define TJHeightFullView self.frame.size.height
#define TJRectFullVC CGRectMake(0, 0, TJWidthDevice, TJHeightDevice - TJHeightNavigationBar)

//满屏CGRect
#define TJRectFullScreen TJMainScreen.bounds

//自动布局Size
#define TJAutoSizeMake(a, b) CGSizeMake((a/375.0)*TJWidthDevice,(b/667.0)*TJHeightDevice)

#define TJSizeWithWidth(a) TJAutoSizeMake(a, 0)
#define TJSizeWithHeight(a) TJAutoSizeMake(0, a)

/** *  ------------------------- 颜色定义 ------------------------- */
#define TJColorSingle(a) TJColor(a,a,a)
#define TJColorSingalp(a,b) TJColorWithAlpha(a,a,a,b)
#define TJColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define TJColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TJColorWithRandomAlpha(a) [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:a]
#define TJColorWithRandomListAlpha(a) [UIColor randomColorInListWithAlpha:a]

//通用视觉规范
#define TJColorBlackFont        TJColorSingle(0)                                  //黑色 字体颜色
#define TJColorGrayFontDark     TJColorSingle(76)                                 //深灰 字体颜色
#define TJColorGrayFontLight    TJColorSingle(153)                                //浅灰 字体颜色
#define TJColorWhiteFont        TJColorSingle(255)                                //白色 字体颜色
#define TJColorBlueFont         TJColor(0, 92, 179)                               //蓝色 字体颜色

#define TJColorGrayBg           TJColorSingle(250)                                //灰色 背景颜色
#define TJColorWhiteBg          TJColorSingle(255)                                //白色 背景颜色


#define TJColorTranslucent      TJColorSingalp(0, 0.55)                           //半透明颜色
#define TJColorClear            [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0]                            //无色

#define TJColorWhite            TJColor(255, 255, 255)                            //纯白
#define TJColorRed              TJColor(255, 0, 0)                                //红色
#define TJColorOrange           TJColor(253, 106, 60)                             //橙色
#define TJColorYellow           TJColor(239, 166, 68)                             //黄色
#define TJColorGreen            TJColor(0, 255, 0)                                //绿色
#define TJColorBlue             TJColor(0, 153, 255)                              //蓝色
#define TJColorBlack            TJColor(0, 0, 0)                                  //黑色
#define TJColorGray             TJColor(153, 153, 153)                            //灰色
#define TJColorlightGray        TJColor(197, 197, 202)                            //浅灰色
#define TJColorCoffee           TJColor(185,152,99)                               //咖啡色

#define TJColorLine             TJColorSingle(204)                                //线 灰色

#define TJColorTabNavBg              TJColor(37, 46, 75)                                 //tabBar 和 navigationBar 颜色
#define TJColorTabNavBgLight         TJColorGrayBg                                       //tabBar 和 navigationBar 颜色 (白色主题)

#define TJColorDeleteView   TJColor(230, 66, 64)
#define TJColorDeleteView_H TJColor(238, 123, 122)

#define TJColorRedPoint TJColor(255, 59, 48)

#define TJColorAutoTabNavBg [TJUserInfoCurrent.background intValue] ? TJColorTabNavBgLight : TJColorTabNavBg //自动选择
#define TJColorAutoTabBtnH  [TJUserInfoCurrent.background intValue] ? TJColorWithAlpha(230, 230, 230, 1) : TJColorWithAlpha(26, 33, 53, 1)
#define TJColorAutoTitle [TJUserInfoCurrent.background intValue] ? TJColorWithAlpha(38, 38, 38, 1) : TJColorWhiteFont

#define TJAutoChooseThemeImage(str) [TJUserInfoCurrent.background intValue] ? [@"dark_" stringByAppendingString:str] : str

/** *  ------------------------- 字体定义 ------------------------- */
#define TJFontSize(s) [UIFont systemFontOfSize:s]
#define TJFontName @"STXihei"
#define TJBlodFont(s) [UIFont boldSystemFontOfSize:s]
#define TJTextFont [UIFont fontWithName:TJFontName size:16]
#define TJFontWithSize(a) [UIFont fontWithName:TJFontName size:a]


/** *  ------------------------- 状态码定义 ------------------------- */
#define TJStatusSussess             @"200"	// 操作成功
#define TJStatusBan                 @"301"	// 用户被禁用
#define TJStatusPwdError            @"302"	// 用户名密码错误
#define TJStatusNameExisted         @"333"	// 用户名已被注册
#define TJStatusIPBan               @"315"	// IP/设备禁用
#define TJStatusUsrLMT              @"403"	// 权限不够
#define TJStatusNullObj             @"404"	// 找不到对象
#define TJStatusUnConnect           @"415"	// 客户端网络问题
#define TJStatusDataBaseError       @"501"	// 服务器操作数据库出错
#define TJStatusFilemultiplyError   @"502"	// 文件上传出错
#define TJStatusUserNeedSetUpInfo   @"274"  // 用户需要初始化个人资料
#endif /* TJAppMacros_h */

#define TJFlagRange @"_&"
#define TJLocationPoint @"·"
#define TJShowRedPoint @"showRedPoint"

#define TJSpecialMark @"slakljhdksudhsjaskhdbw"

#define KEY_TYPE        @"KEY_TYPE"
#define KEY_USER_ID     @"KEY_USER_ID"
#define KEY_HEAD_URL    @"KEY_HEAD_URL"
#define KEY_NICKNAME    @"KEY_NICKNAME"
#define KEY_TEXT        @"KEY_TEXT"
#define KEY_PHOTO       @"KEY_PHOTO"
#define KEY_VIDEO       @"KEY_VIDEO"

#define CARD_HEAD_URL           @"headUrl"
#define CARD_USER_ID            @"id"
#define CARD_NICK_NAME          @"nickname"
#define CARD_TUIJI              @"tuijihao"


#define DDLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DDLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
