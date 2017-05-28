//
//  TJStatusParams.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJStatusParams : NSObject

/**
 *  识别码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  反馈信息
 */
@property (nonatomic ,copy) NSString *message;
@end
