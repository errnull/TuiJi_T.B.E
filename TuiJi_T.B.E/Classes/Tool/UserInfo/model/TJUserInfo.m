//
//  TJUserInfo.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserInfo.h"

@implementation TJUserInfo

+ (instancetype)userInfoWithNIMUser:(NIMUser *)user{

    
    TJUserInfo *userInfo = [TJUserInfo mj_objectWithKeyValues:user.userInfo.ext];
    
    userInfo.uNickname = user.userInfo.nickName;
    userInfo.uPicture = user.userInfo.avatarUrl;
    userInfo.uSignature = user.userInfo.sign;
    userInfo.uSex = user.userInfo.gender;
    userInfo.uEmail = user.userInfo.email;
//    _userInfo.birthday
    userInfo.uTel = user.userInfo.mobile;

    return userInfo;
}

@end

