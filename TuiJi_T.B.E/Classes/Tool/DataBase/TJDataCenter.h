//
//  TJDataCenter.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Realm/Realm.h>

@interface TJDataCenter : NSObject
/**
 *  用户数据根目录
 */
+ (NSString *)mainDataFolderName;

/**
 *  创建主数据文件夹
 */
+ (void)createMainDataFolder;

/**
 *  创建用户文件夹
 */
+ (void)createUserInfoFolder;

/**
 *  默认用户数据库
 */
+ (RLMRealm *)userRealm;

/**
 *  文件管理器
 */
+ (NSFileManager *)dataFileManager;

/**
 * 创建一个reaml数据库
 */
+ (RLMRealm *)createRealmWithPath:(NSString *)path;

/**
 *  往数据库中添加一条单一信息
 */
+ (void)addSingleObject:(RLMObject *)object;

/**
 *  往数据库中添加一条信息
 */
+ (void)addAObject:(RLMObject *)object;

/**
 *  从数据库中删除一条数据
 */
+ (void)deleteAObject:(RLMObject *)object;

/**
 *  删除某个类中符合条件的
 */
+ (void)deleteAObjectWithClassName:(NSString *)className conditions:(NSString *)conditions;

/**
 *  删除数据库中一个类型的所有数据
 */
+ (void)deleteAllObjectWithClassName:(NSString *)className;

/**
 *  删除一个默认数据库中的全部数据
 */
+ (void)deleteAllData;

/**
 *  通过类型查找数据
 */
+ (NSMutableArray *)dataListForClass:(Class)className;


+ (void)saveImage:(UIImage *)image Success:(void(^)())success failure:(void(^)(NSError *error))failure;
@end
