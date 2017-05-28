//
//  TJCommentParam.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJCommentParam : NSObject
/**
 *  评论内容
 */
@property (nonatomic ,copy) NSString *comments;

/**
 *  评论者ID
 */
@property (nonatomic ,copy) NSString *commUId;

/**
 *  推文ID
 */
@property (nonatomic ,copy) NSString *tId;

/**
 *  引用评论ID （二级评论时必填）
 */
@property (nonatomic ,copy) NSString *refCommId;

/**
 *  引用评论者ID （二级评论时必填）
 */
@property (nonatomic ,copy) NSString *refCommUId;
@end
