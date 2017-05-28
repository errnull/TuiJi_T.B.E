//
//  TJNewUserInfoCard.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNewUserInfoCard : NSObject

/**
 *  userId
 */
@property (nonatomic ,copy) NSString *userId;

/**
 *  用户推己号
 */
@property (nonatomic ,copy) NSString *username;

/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *nickName;

/**
 *  用户头像
 */
@property (nonatomic ,copy) NSString *picture;

/**
 *  个性签名
 */
@property (nonatomic ,copy) NSString *signature;

/**
 *  地区
 */
@property (nonatomic ,copy) NSString *country;

/**
 *  返回参数
 */
@property (nonatomic ,copy) NSString *code;

@end
