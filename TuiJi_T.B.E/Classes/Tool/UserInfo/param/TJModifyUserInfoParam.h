//
//  TJModifyUserInfoParam.h
//  TuiJi_T.B.E
//
//  Created by 繁轩 on 16/10/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJModifyUserInfoParam : NSObject

/**
 * 用户名
 */
@property (nonatomic, copy) NSString *username;

/**
 * 要修改的密码
 */
@property (nonatomic, copy) NSString *password;

/**
 * 要修改的昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 * 已上传的头像的路径
 */
@property (nonatomic, copy) NSString *iconImage;

/**
 * 签名
 */
@property (nonatomic, copy) NSString *signature;

/**
 * 真实姓名
 */
@property (nonatomic, copy) NSString *realName;

/**
 * Email
 */
@property (nonatomic, copy) NSString *email;

/**
 * 电话
 */
@property (nonatomic, copy) NSString *tel;

/**
 * 性别
 */
@property (nonatomic, assign) NIMUserGender sex;

/**
 * 国家
 */
@property (nonatomic, copy) NSString *region;

/**
 * 是否称为公众
 */
#warning variates illegal
@property (nonatomic, copy) NSString *_public;

/**
 * 身份证
 */
@property (nonatomic, copy) NSString *idcard;

/**
 * 坐标
 */
@property (nonatomic, copy) NSString *location;

/**
 * 个性背景
 */
@property (nonatomic, copy) NSString *background;



/**
 *  坐标集
 */
@property (nonatomic, strong) NSMutableDictionary *locationList;
@end
