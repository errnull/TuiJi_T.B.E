//
//  TJContact.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

@interface TJContact : NSObject

/**
 *  用户id
 */
//@property (nonatomic ,copy) NSString *deputyuserid;
@property (nonatomic ,copy) NSString *userId;

/**
 *  用户备注名称
 */
//@property (nonatomic ,copy) NSString *remarks;
@property (nonatomic ,copy) NSString *remark;

/**
 *  用户名称
 */
//@property (nonatomic ,copy) NSString *deputyusername;
@property (nonatomic ,copy) NSString *nickname;

/**
 *  推己号
 */
@property (nonatomic ,copy) NSString *username;

/**
 *  用户头像url地址
 */
//@property (nonatomic, copy) NSString *deputyuserpictrue;
@property (nonatomic ,copy) NSString *headImage;

/**
 *  个性签名
 */
@property (nonatomic ,copy) NSString *signature;

/**
 *  真实姓名
 */
@property (nonatomic ,copy) NSString *realName;

/**
 *  电子邮箱
 */
@property (nonatomic ,copy) NSString *e_mail;

/**
 *  手机号码
 */
@property (nonatomic ,copy) NSString *phoneNumber;

/**
 *  注册时间
 */
@property (nonatomic ,copy) NSString *registTime;

/**
 *  地区
 */
@property (nonatomic ,copy) NSString *region;

/**
 *  性别
 */
@property (nonatomic ,assign) NIMUserGender sex;

/**
 *  是否公众人物
 */
@property (nonatomic ,copy) NSString *isPublic;

/**
 *  背景图片
 */
@property (nonatomic ,copy) NSString *background;

/**
 *  是否通知新消息
 */
@property (nonatomic,assign) BOOL notifyForNewMsg;


@property (nonatomic ,assign) BOOL contactSelected;

+ (instancetype)contactWithUserId:(NSString *)userId;

+ (NSMutableArray *)contactlistWithNIMUsers:(NSArray<NIMUser *> *)users;

+ (instancetype)contactWithUserName:(NSString *)userName;

@end

