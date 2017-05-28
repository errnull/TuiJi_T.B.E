//
//  TJUpLoadResult.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUpLoadResult : NSObject

/**
 *  请求结果状态码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  头像在服务器的相对路径
 */
@property (nonatomic ,copy) NSString *path;
@end
