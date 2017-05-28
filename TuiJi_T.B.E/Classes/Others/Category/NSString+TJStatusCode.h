//
//  NSString+TJStatusCode.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TJStatusCode)

/**
 *  解析服务器返回的状态码
 */
+ (NSString *)statusWithCode:(NSString *)code;

/**
 *  判断是否手机号码
 */
- (BOOL)validateMobileNumber;
@end
