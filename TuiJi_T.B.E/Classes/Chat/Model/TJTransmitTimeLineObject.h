//
//  TJTransmitTimeLineObject.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJTransmitTimeLineObject : NSObject


/**
 *  推文ID
 */
@property (nonatomic ,copy) NSString *tuiwenID;

/**
 *  推文类型
 */
@property (nonatomic ,copy) NSString *tType;

/**
 *  头像
 */
@property (nonatomic ,copy) NSString *headImage;

/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *nickname;

/**
 *  文本内容
 */
@property (nonatomic ,copy) NSString *context;

/**
 *  图片url
 */
@property (nonatomic ,copy) NSString *imgUrl;

/**
 *  视频url
 */
@property (nonatomic ,copy) NSString *videoUrl;

@end
