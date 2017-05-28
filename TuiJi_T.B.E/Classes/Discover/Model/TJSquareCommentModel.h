//
//  TJSquareCommentModel.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSquareCommentModel : NSObject

/**
 *  评论正文
 */
@property (nonatomic ,copy) NSString *commentcontent;

/**
 *  父评论id 若没有父评论 返回 -1
 */
@property (nonatomic ,copy) NSString *fathercommentid;

/**
 *  评论 id
 */
@property (nonatomic ,copy) NSString *commentId;

/**
 *  主评论人 id
 */
@property (nonatomic ,copy) NSString *interlocutorid;

/**
 *  主评论人 昵称
 */
@property (nonatomic ,copy) NSString *lnterlocutorname;

/**
 *  主评论人 头像
 */
@property (nonatomic ,copy) NSString *interlocutorpicture;

/**
 *  被评论人 id
 */
@property (nonatomic ,copy) NSString *interlocutortwoid;

/**
 *  被评论人 昵称
 */
@property (nonatomic ,copy) NSString *lnterlocutortwoname;

/**
 *  被评论人 头像
 */
@property (nonatomic ,copy) NSString *lnterlocutortwopicture;

/**
 *  评论时间
 */
@property (nonatomic ,copy) NSString *time;

/**
 *  广场 推文 id
 */
@property (nonatomic ,copy) NSString *squaretweetid;

/**
 *  自动生成的评论
 */
@property (nonatomic ,copy) NSMutableAttributedString *realComments;
@end
