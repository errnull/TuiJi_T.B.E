//
//  TJSpecialtweets.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSpecialtweets : NSObject

/**
 *  收藏数
 */
@property (nonatomic ,copy) NSString *collectnumber;
/**
 *  评论数
 */
@property (nonatomic ,copy) NSString *commentnumber;
/**
 *  正文
 */
@property (nonatomic ,copy) NSString *context;
/**
 *  日期
 */
@property (nonatomic ,copy) NSString *date;
/**
 *  推文id
 */
@property (nonatomic ,copy) NSString *_id;
/**
 *  id
 */
@property (nonatomic ,copy) NSString *igIdStr;
/**
 *  配图
 */
@property (nonatomic ,copy) NSString *photourl;
/**
 *  头像
 */
@property (nonatomic ,copy) NSString *picture;
/**
 *  来源
 */
@property (nonatomic ,copy) NSString *platform;
/**
 *  点赞数
 */
@property (nonatomic ,copy) NSString *praisenumber;
/**
 *  转发数
 */
@property (nonatomic ,copy) NSString *transmitnumber;
/**
 *  点踩数
 */
@property (nonatomic ,copy) NSString *treadnumber;
/**
 *  用户昵称
 */
@property (nonatomic ,copy) NSString *username;

@end
