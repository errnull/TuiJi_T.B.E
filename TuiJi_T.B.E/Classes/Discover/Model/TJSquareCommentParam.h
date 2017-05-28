//
//  TJSquareCommentParam.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSquareCommentParam : NSObject
/**
 *  评论人ID
 */
@property (nonatomic ,copy) NSString *userID;

/**
 *  被评论人id
 */
@property (nonatomic ,copy) NSString *user2ID;

/**
 *  评论内容
 */
@property (nonatomic ,copy) NSString *context;

/**
 *  推文ID
 */
@property (nonatomic ,copy) NSString *ID;

/**
 *  父评论id
 */
@property (nonatomic ,copy) NSString *CommentID;

/**
 *  类型type 0为普通推文 1为instagram推文
 */
@property (nonatomic ,copy) NSString *type;
@end
