//
//  TJAttention.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJAttention : RLMObject

/**
 *  什么鬼
 */
@property (nonatomic ,copy) NSString *attentionbackground;

/**
 *  关注者id
 */
@property (nonatomic ,copy) NSString *attentionid;

/**
 *  关注者昵称
 */
@property (nonatomic ,copy) NSString *attentionname;

/**
 *  关注者头像
 */
@property (nonatomic ,copy) NSString *attentionpicture;

/**
 *  关注id
 */
@property (nonatomic ,copy) NSString *attentionUid;

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *userid;

@end
