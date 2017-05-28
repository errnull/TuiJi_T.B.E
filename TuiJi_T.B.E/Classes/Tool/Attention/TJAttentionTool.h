//
//  TJAttentionTool.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJAttention;
@interface TJAttentionTool : NSObject

+ (void)loadAttentionListSuccess:(void (^)(NSMutableArray *attentionList))success failure:(void (^)(NSError *error))failure;

/**
 *  读取用户关注列表
 */
+ (NSMutableArray *)attentionList;

+ (BOOL)isMyAttention:(NSString *)friendId;

+ (void)payAttntionToSB:(NSString *)friendId where:(NSInteger)type Success:(void (^)())success failure:(void (^)(NSError *error))failure;

+ (void)unPayAttntionToSB:(NSString *)friendId where:(NSInteger)type Success:(void (^)())success failure:(void (^)(NSError *error))failure;
@end
