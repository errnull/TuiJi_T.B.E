//
//  TJSquareTweet.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSquareTweet : NSObject

/**
 *  推文ID
 */
@property (nonatomic ,copy) NSString *_id;

/**
 *  用户ID
 */
@property (nonatomic ,copy) NSString *userid;

/**
 *  发表者名称
 */
@property (nonatomic ,copy) NSString *username;

/**
 *  发表者头像
 */
@property (nonatomic ,copy) NSString *userpicture;

/**
 *  发表内容
 */
@property (nonatomic ,copy) NSString *content;

/**
 *  是否有照片
 */
@property (nonatomic ,copy) NSString *pictureid;

/**
 *  视频rul地址
 */
@property (nonatomic ,copy) NSString *videourl;

/**
 *  点赞数
 */
@property (nonatomic ,copy) NSString *praisenumber;

/**
 *  点踩数
 */
@property (nonatomic ,copy) NSString *treadnumber;

/**
 *  被收藏数
 */
@property (nonatomic ,copy) NSString *collectnumber;

/**
 *  发表时间
 */
@property (nonatomic ,copy) NSString *time;

/**
 *  被转发数
 */
@property (nonatomic ,copy) NSString *transmitnumber;

/**
 *  评论数
 */
@property (nonatomic ,copy) NSString *commentnumber;

/**
 *  被转发推文ID
 */
@property (nonatomic ,copy) NSString *forwardid;

/**
 *  坐标
 */
@property (nonatomic ,copy) NSString *coordinate;

@end
