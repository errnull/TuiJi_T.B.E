//
//  TJAccount.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJAccount : NSObject<NSCoding>
/**
 *  请求结果状态码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  账户有效期(秒)
 */
@property (nonatomic ,copy) NSString *sessiontime;

/**
 *  后台生成的jsessionid
 */
@property (nonatomic ,copy) NSString *jsessionid;

/**
 *  后台注册网易云信得到的token
 */
@property (nonatomic ,copy) NSString *token;

/**
 *  user的ID
 */
@property (nonatomic ,copy) NSString *userId;

/**
 *  用于自动登录的账号
 */
@property (nonatomic ,copy) NSString *account;

/**
 *  用于自动登陆的密码
 */
@property (nonatomic ,copy) NSString *password;

/**
 *  过期时间 = 当前保存时间 + 有效期
 */
@property (nonatomic, strong) NSDate *expires_date;

/**
 *  短信验证码
 */
@property (nonatomic, copy) NSString *messageCode;

@end
