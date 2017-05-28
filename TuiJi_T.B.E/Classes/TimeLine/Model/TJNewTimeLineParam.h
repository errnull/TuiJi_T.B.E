//
//  TJNewTimeLineParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNewTimeLineParam : NSObject
/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *uId;

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *uid;

/**
 *  好友id
 */
@property (nonatomic ,copy) NSString *fuid;

/**
 *  要查询推文列表的对象类型 (*必填 0:自己 1：个人, 2：所有好友)
 */
@property (nonatomic ,copy) NSString *type;

/**
 *  则返回ID比since_id大的推文
 */
@property (nonatomic ,copy) NSString *since_id;

/**
 *  则返回ID小于max_id
 */
@property (nonatomic ,copy) NSString *max_id;
@end
