//
//  TJAccountTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

/**
 *  专门处理账户的读取和存储业务
 */

#import <Foundation/Foundation.h>

@class TJAccount, TJSignParam;
@interface TJAccountTool : NSObject

/**
 *  存储
 */
+ (void)saveAccount:(TJAccount *)account;

/**
 *  读取
 */
+ (TJAccount *)account;

/**
 * 账户权限请求
 */
+ (void)loginWithAccount:(NSString *)username
                password:(NSString *)password
                    Type:(TJAccountToolType) accountToolType
                 success:(void (^)())success
                 failure:(void (^)())failure;


/**
 *  初始化用户数据
 */
+ (void)loadBaseUserData;

/**
 *  删除本地账户文件
 */
+ (void)deleteAccountData;
@end
