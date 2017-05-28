//
//  TJCommentModel.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJCommentUserInfo.h"

@interface TJCommentModel : NSObject

/**
 *  评论id
 */
@property (nonatomic ,copy) NSString *commId;

/**
 *  评论时间
 */
@property (nonatomic ,copy) NSString *commTime;

/**
 *  评论人uid
 */
@property (nonatomic ,copy) NSString *commUId;

/**
 *  推文id
 */
@property (nonatomic ,copy) NSString *tId;

/**
 *  被评论的一级评论id（上一级该值为空时引用父评id,不为空时下一级引用该值）
 */
@property (nonatomic ,copy) NSString *refCommId;

/**
 *  被评人uid
 */
@property (nonatomic ,copy) NSString *refCommUId;

/**
 *  评论内容
 */
@property (nonatomic ,copy) NSString *comments;

/**
 *  主评人信息
 */
@property (nonatomic, strong) TJCommentUserInfo *hostFriendsInfo;

/**
 *  被评人信息
 */
@property (nonatomic, strong) TJCommentUserInfo *refFriendsInfo;

/**
 *  自动生成的评论
 */
@property (nonatomic ,copy) NSMutableAttributedString *realComments;
@end
