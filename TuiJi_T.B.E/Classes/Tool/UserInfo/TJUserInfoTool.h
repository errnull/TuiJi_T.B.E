//
//  TJUserInfoTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJUserInfo;

@interface TJUserInfoTool : NSObject

/**
 *  读取
 */
+ (TJUserInfo *)userInfo;

+ (TJUserInfo *)userInfoSuccess:(void(^)())success
                        failure:(void(^)(NSError *error))failure;

/**
 *  修改用户资料
 */
+ (void)modifyUserInfoWithParam:(NSDictionary *)param
                        Success:(void(^)())success
                        failure:(void(^)(NSError *error))failure;


/**
 *  删除本地账户文件
 */
+ (void)deleteUserInfo;

@end
