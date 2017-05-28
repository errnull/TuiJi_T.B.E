//
//  TJUserCollectionModel.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUserCollectionModel : NSObject

/**
 *  图片资源
 */
@property (nonatomic ,copy) NSString *imgsUrl;

/**
 *  文本内容
 */
@property (nonatomic ,copy) NSString *tContent;

/**
 *  推文id
 */
@property (nonatomic ,copy) NSString *tId;
/**
 *  推文所在广场id
 */
@property (nonatomic ,copy) NSString *squareId;

/**
 *  收藏的id
 */
@property (nonatomic ,copy) NSString *collectionId;


/**
 *  头像
 */
@property (nonatomic ,copy) NSString *userIcon;

/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *username;

/**
 *  类型type 0为普通推文 1为instagram推文
 */
@property (nonatomic ,copy) NSString *squareType;

@end
