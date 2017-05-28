//
//  TJGlobalNews.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGlobalNews : NSObject

/**
 *  1是新闻 0不是新闻
 */
@property (nonatomic ,copy) NSString *ifNews;

/**
 *  新闻ID
 */
@property (nonatomic ,copy) NSString *worldTweetId;

/**
 *  国家
 */
@property (nonatomic ,copy) NSString *country;

/**
 *  新闻标题
 */
@property (nonatomic ,copy) NSString *title;

/**
 *  新闻摘要图片
 */
@property (nonatomic ,copy) NSString *titlePicture;

/**
 *  摘要
 */
@property (nonatomic ,copy) NSString *contentCatch;

/**
 *  等同newFrom
 */
@property (nonatomic ,copy) NSString *fromMedia;


/**
 *  内容
 */
@property (nonatomic ,copy) NSString *content;

///**
// *  点赞数目
// */
//@property (nonatomic ,copy) NSString *praisenumber;
//
///**
// *  收藏数目
// */
//@property (nonatomic ,copy) NSString *collectnumber;
//
///**
// *  转发数目
// */
//@property (nonatomic ,copy) NSString *transmitnumber;
//
///**
// *  评论数目
// */
//@property (nonatomic ,copy) NSString *commentnumber;

/**
 *  全球发布时间
 */
@property (nonatomic ,copy) NSString *time;

/**
 *  新闻来源中文名
 */
@property (nonatomic ,copy) NSString *fromMediaCHI;

@end
