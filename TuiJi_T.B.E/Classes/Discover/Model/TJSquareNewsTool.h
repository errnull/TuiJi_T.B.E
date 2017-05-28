//
//  TJSquareNewsTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/10/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSquareNewsTool : NSObject
/**
 *  获取最新 更前 广场
 */
+ (void)loadNewSquareNewSuccess:(void(^)(NSArray *squareNewsList))success failure:(void(^)(NSError *error))failure;

/**
 *  获取更旧 广场
 */
+ (void)loadOldSquareNewSuccess:(void(^)(NSArray *squareNewsList))success failure:(void(^)(NSError *error))failure;

/**
 *  获取广场评论
 */
+ (void)loadSquareCommentWithID:(NSString *)squareNewsID
                           type:(NSString *)squareNewsType
                        success:(void(^)(NSArray *squareCommentList))success
                        failure:(void(^)(NSError *error))failure;

+ (void)loadSquareNewsWithID:(NSString *)squareNewsID
                        type:(NSString *)type
                     Success:(void(^)(id squareNews))success
                     failure:(void(^)(NSError *error))failure;
@end
