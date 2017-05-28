//
//  TJDeviceTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJDeviceTool : NSObject

/**
 *  使用KeyChain保存 生成的UDID
 */
+ (BOOL)setUDIDTokeyChain:(NSString *)udid;

/**
 *  获取keyChain中保存的UDID
 */

+ (NSString *)getUDIDFromKeyChain;


@end
