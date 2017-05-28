//
//  TJLocationMessageObject.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/24.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLocationMessageObject : NSObject

/**
 *  位置实例对象初始化方法
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param title   地理位置描述
 *  @return 位置实例对象
 */
- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude
                           title:(NSString *)title;

/**
 *  维度
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度
 */
@property (nonatomic, assign) double longitude;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

@end
