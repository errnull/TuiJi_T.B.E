//
//  TJGlobalVariables.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//
/**
 *  此类定义全局变量
 */

//位置类型
typedef NS_ENUM(NSInteger,TJLayoutAlignmentType)
{
    AlignmentCenter = 0,               //默认居中
    AlignmentTop,
    AlignmentBottom,
    AlignmentLeft,
    AlignmentRight
};

//输入框类型
typedef NS_ENUM(NSInteger, TJInPutViewType) {
    TJInPutViewTypeAccount = 0,        //账号输入
    TJInPutViewTypePassword,           //密码输入
    TJInPutViewTypeVerification,       //验证码输入
    TJInPutViewTypeNickName
};

//输入框类型
typedef NS_ENUM(NSInteger, TJAccountToolType) {
    TJAccountToolTypeSignIn = 0,        //账号输入
    TJAccountToolTypeSignUp,           //密码输入
    TJAccountToolTypePwdForgot,       //验证码输入
};


//输入框类型
typedef NS_ENUM(NSInteger, TJNewFriendCellType) {
    TJNewFriendCellTypeWillAdd = 0,        //即将添加
    TJNewFriendCellTypeDidAdd,             //已经添加
    TJNewFriendCellTypeNewFriend,          //手机好友
    TJNewFriendCellTypeNULL,               //没有图片
};



