//
//  NSString+TJString.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TJString)

/**
 *  获取当前时间
 */
+ (NSString *)currentTimeString;

/**
 *  时间戳转换为时间
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

/**
 *  通过文本计算尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 *  获取七牛上传接口验证码
 */
+ (NSString *)getAuthCode;

/**
 *  判断id 对应的联系人是否我的 好友 或者 群聊
 */
- (BOOL)isConnectWithMe;


@end
