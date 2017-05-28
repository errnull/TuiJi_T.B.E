//
//  TJNewContactRequestTool.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNewContactRequestTool : NSObject

/**
 *  存储
 */
//+ (void)saveNewContact:(TJNewContactRequest *)NewContactRequest;

/**
 *  读取
 */
+ (NSMutableArray *)NewContactRequestListSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  直接从数据库读取
 */
+ (NSMutableArray *)newContactRequestList;

/**
 *  删除本地账户文件
 */
+ (void)deleteNewContact;

@end
