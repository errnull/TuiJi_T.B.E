//
//  TJUserExtData.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

@interface TJUserExtData : NSObject

/**
 *  粉丝数
 */
@property (nonatomic ,copy) NSString *fansNumber;

/**
 *  关注数
 */
@property (nonatomic ,copy) NSString *attentionNumber;

/**
 *  推文数
 */
@property (nonatomic ,copy) NSString *tuiwenNumber;

/**
 *  当前 推文ID
 */
@property (nonatomic ,copy) NSString *TweetID;

/**
 *  当前 Instagram推文id
 */
@property (nonatomic ,copy) NSString *SpecialTweetID;

/**
 *  世界 浏览进度
 */
@property (nonatomic ,copy) NSString *worldRequestJson;

@end

