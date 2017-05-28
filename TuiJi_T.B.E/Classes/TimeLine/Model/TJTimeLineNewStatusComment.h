//
//  TJTimeLineNewStatusComment.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJTimeLineNewStatus.h"

@interface TJTimeLineNewStatusComment : TJTimeLineNewStatus

/**
 *  消息类型
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  评论id
 */
@property (nonatomic ,copy) NSString *commentID;

/**
 *  评论正文
 */
@property (nonatomic ,copy) NSString *comments;
@end

RLM_ARRAY_TYPE(TJTimeLineNewStatusComment)
