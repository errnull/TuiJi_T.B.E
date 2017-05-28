//
//  TJUserInfo.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

@interface TJUserInfo : NSObject

/**
 *  请求结果状态码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  用户名推己号
 */
@property (nonatomic ,copy) NSString *uUsername;

/**
 *  用户是否被禁用
 */
@property (nonatomic ,copy) NSString *uEnabled;

/**
 *  预留字段
 */
@property (nonatomic ,copy) NSString *uOpenid;

/**
 *  预留字段
 */
@property (nonatomic ,copy) NSString *uUnionid;

/**
 *  签名
 */
@property (nonatomic ,copy) NSString *uSignature;

/**
 *  真实姓名
 */
@property (nonatomic ,copy) NSString *uRealname;

/**
 *  电邮
 */
@property (nonatomic ,copy) NSString *uEmail;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *uPicture;

/**
 *  手机
 */
@property (nonatomic ,copy) NSString *uTel;

/**
 *  注册时间
 */
@property (nonatomic ,copy) NSString *uRegisttime;

/**
 *  国家
 */
@property (nonatomic ,copy) NSString *uCountry;

/**
 *  性别
 */
@property (nonatomic ,assign) NIMUserGender uSex;

/**
 *  是否公众人物
 */
@property (nonatomic ,copy) NSString *uPublic;

/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *uNickname;

/**
 *  是否改过用户名推己号
 */
@property (nonatomic ,copy) NSString *changeUsername;

/**
 *  背景图片
 */
@property (nonatomic ,copy) NSString *background;

/**
 *  用户当前浏览推文ID
 */
@property (nonatomic ,copy) NSString *TweetID;

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *userId;

/**
 *  用户当前浏览Instagram推文ID
 */
@property (nonatomic ,copy) NSString *SpecialTweetID;

+ (instancetype)userInfoWithNIMUser:(NIMUser *)user;
@end
