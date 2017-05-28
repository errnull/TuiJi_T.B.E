//
//  TJContactTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJContact;

@interface TJContactTool : NSObject

/**
 *  存储
 */
+ (void)saveContact:(TJContact *)contact;

/**
 *  读取联系人
 */
+ (NSMutableArray *)contactList;

/**
 *  读取群聊列表
 */
+ (NSMutableArray *)groupContactList;

/**
 *  删除本地账户文件
 */
+ (void)deleteContac:(NSString *)contactId Success:(void (^)())success failure:(void (^)(NSError *))failure;


/**
 *  更新联系人资料
 */
+ (void)upDateContact:(TJContact *)contact Success:(void (^)(TJContact *contact))success failure:(void (^)(NSError *error))failure;

/**
 *  创建群聊
 */
+(void)greateGroupContactWithContactList:(NSMutableArray *)contactList Success:(void (^)(NSString *teamId))success failure:(void (^)(NSError *error))failure;

@end
