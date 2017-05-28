//
//  TJLocationName.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMapAOI;

@interface TJLocationName : NSObject

/**
 *  地址名称
 */
@property (nonatomic ,copy) NSString *locationName;

/**
 *  地址详细位置
 */
@property (nonatomic ,copy) NSString *locationDetail;

/**
 *  地址距离
 */
@property (nonatomic ,copy) NSString *locationDistant;

/**
 *  所在城市
 */
@property (nonatomic ,copy) NSString *locationCity;

@end

