//
//  TJTimeLine.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TJUserInfo.h"
#import "TJContact.h"

@interface TJTimeLine : NSObject

/**
 *  好友id
 */
@property (nonatomic ,copy) NSString *authorId;

/**
 *  指定好友可见类型 (公开(所有朋友可见) 0 私有(仅自己可见) 1 部分可见(选择的朋友可见) 2 不给谁看(选择的朋友不可见) 3)
 */
@property (nonatomic ,copy) NSString *cfType;

/**
 *  评论数
 */
@property (nonatomic ,copy) NSString *commentNum;

/**
 *  推文的资源url
 */
@property (nonatomic ,strong) NSArray *imgsUrl;

/**
 *  自己有没有点赞（0没有，1有）
 */
@property (nonatomic ,copy) NSString *isMyPraise;

/**
 *  推文来源是否转发（0的时候是原创，如果是转发就保存转发推文所属id）
 */
@property (nonatomic ,copy) NSString *isTurn;

/**
 *  来源者ID
 */
@property (nonatomic ,copy) NSString *originId;

/**
 *  点赞数
 */
@property (nonatomic ,copy) NSString *praiseNum;

/**
 *  推文文本
 */
@property (nonatomic ,copy) NSString *tContent;

/**
 *  推文id
 */
@property (nonatomic ,copy) NSString *tId;

/**
 *  推文坐标
 */
@property (nonatomic, strong) CLLocation *location;

/**
 *  推文地址
 */
@property (nonatomic ,copy) NSString *tAddress;

/**
 *  是否为私密推文（1仅自己可见，0公开）
 */
@property (nonatomic ,copy) NSString *tPrivate;

/**
 *  推文时间
 */
@property (nonatomic ,copy) NSString *tTime;

/**
 *  推文类型 (0文本，1图文，2图，3图音，4小视频)
 */
@property (nonatomic ,copy) NSString *tType;

/**
 *  转发数
 */
@property (nonatomic ,copy) NSString *turnNum;

/**
 *  点踩数
 */
@property (nonatomic ,copy) NSString *unlikeNum;

/**
 *  视频播放次数
 */
@property (nonatomic ,copy) NSString *vSeeNum;

/**
 *  音，小视频的url
 */
@property (nonatomic ,copy) NSString *mulmediaUrl;

/**
 *  是否公众人物
 */
@property (nonatomic ,copy) NSString *isPublic;

/**
 *  头像
 */
@property (nonatomic ,copy) NSString *headImage;

/**
 *  时间
 */
@property (nonatomic ,copy) NSString *nickname;

/**
 *  用户ID
 */
@property (nonatomic ,copy) NSString *userId;

/**
 *  转发推文
 */
@property (nonatomic, strong) TJTimeLine *transmitTimeLine;

/**
 *  广场id
 */
@property (nonatomic ,copy) NSString *worldHide;
@end
