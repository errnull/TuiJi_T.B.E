//
//  TJGlobalNewsTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGlobalNewsTool : NSObject

/**
 *  加载全球数据
 */
+ (void)loadGlobalNewsIfSuccess:(void (^)(NSArray *globalNewsList))success failure:(void (^)(NSError *error))failure;

/**
 *  加载更多旧数据(上拉刷新)
 */
+ (void)loadOldGlobalNewsIfSuccess:(void (^)(NSArray *globalNewsList))success failure:(void (^)(NSError *error))failure;
@end
