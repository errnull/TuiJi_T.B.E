//
//  TJTimeLineTool.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJTimeLineTool : NSObject

/**
 *  加载推己圈数据
 */
+ (void)loadTimeLineWithSinceID:(NSString *)sinceID
                        orMaxID:(NSString *)maxID
                        success:(void(^)(NSMutableArray *timeLineList))success
                        failure:(void(^)(NSError *error))failure;

/**
 *  加载推文评论
 */
+ (void)loadTimeLineCommentWithTuiID:(NSString *)tuiID
                             success:(void(^)(NSArray *timeLineCommentList))success
                             failure:(void(^)(NSError *error))failure;

/**
 *  点赞推己圈
 */
+ (void)likeTimeLineID:(NSString *)timeLineID
               success:(void(^)())success
               failure:(void(^)(NSError *error))failure;

/**
 *  收藏推己圈
 */
+ (void)collectTimeLineID:(NSString *)timeLineID
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure;


/**
 *  发布推己圈
 */
+ (void)publicTimeLineWithText:(NSString *)text
                 imageDataList:(NSMutableArray *)imageDataList
                     audioData:(NSData *)audioData
                     videoData:(NSData *)videoData
             remindSomeFriends:(NSMutableArray *)friendIDList
                        region:(NSString *)region
                      location:(CLLocation *)location
                    filterlist:(NSMutableArray *)filterlist
                    filtertype:(NSString *)filtertype
                       success:(void(^)())success
                       failure:(void(^)(NSError *error))failure;

/**
 *  删除推己圈
 */
+ (void)deleteATimeLineWithTimeLineId:(NSString *)timeLineId
                              success:(void(^)())success
                              failure:(void(^)(NSError *error))failure;
@end
