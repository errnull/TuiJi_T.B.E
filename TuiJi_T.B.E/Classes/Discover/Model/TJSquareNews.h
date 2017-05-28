//
//  TJSquareNews.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSquareNews : NSObject

/**
 *  推文ID
 */
@property (nonatomic ,copy) NSString *squareNewsID;

/**
 *  用户ID
 */
@property (nonatomic ,copy) NSString *userid;

/**
 *  instagram的id串
 */
@property (nonatomic ,copy) NSString *igIdStr;

/**
 *  来源平台
 */
@property (nonatomic ,copy) NSString *platform;

/**
 *  发表者名称
 */
@property (nonatomic ,copy) NSString *username;

/**
 *  发表者头像
 */
@property (nonatomic ,copy) NSString *userIcon;

/**
 *  发表内容
 */
@property (nonatomic ,copy) NSString *content;

/**
 *  是否有照片
 */
@property (nonatomic ,copy) NSString *pictureid;

/**
 *  照片url
 */
@property (nonatomic ,copy) NSString *imageUrl;

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
 *  视频被播放次数
 */
@property (nonatomic ,copy) NSString *videoPlayNumber;

/**
 *  被转发推文ID
 */
@property (nonatomic ,copy) NSString *forwardid;

/**
 *  坐标
 */
@property (nonatomic ,copy) NSString *coordinate;

/**
 *  类型type 0为普通推文 1为instagram推文
 */
@property (nonatomic ,copy) NSString *squareNewsType;

@end
