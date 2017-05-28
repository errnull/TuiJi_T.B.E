//
//  TJPublicTimeLineParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJPublicTimeLineParam : NSObject
/**
 *  发布推文的用户ID
 */
@property (nonatomic ,copy) NSString *authorId;

/**
 *  推文文本内容
 */
@property (nonatomic ,copy) NSString *tContent;

/**
 *  推文类型
 */
@property (nonatomic ,copy) NSString *tType;

/**
 *  图片资源的路径列表
 */
@property (nonatomic ,copy) NSString *pathJson;

/**
 *  音，小视频的url
 */
@property (nonatomic ,copy) NSString *mulmediaUrl;

/**
 *  是否为私密推文
 */
@property (nonatomic ,copy) NSString *tPrivate;

/**
 *  地址
 */
@property (nonatomic ,copy) NSString *address;

/**
 *  经度
 */
@property (nonatomic ,copy) NSString *lat;

/**
 *  纬度
 */
@property (nonatomic ,copy) NSString *lng;

/**
 *  ait
 */
@property (nonatomic ,copy) NSString *at;

/**
 *  json数组	选择好友列表
 */
@property (nonatomic ,copy) NSString *filter;

/**
 *   //公开(所有朋友可见) 0
 *   //私有(仅自己可见)1
 *   //部分可见(选择的朋友可见) 2
 *   //不给谁看(选择的朋友不可见) 3
 */
@property (nonatomic ,copy) NSString *filtertype;

@end
