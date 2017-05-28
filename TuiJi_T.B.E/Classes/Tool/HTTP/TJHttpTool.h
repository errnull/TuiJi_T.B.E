//
//  TJHttpTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/21.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "QiniuSDK.h"

@class TJUPLoadParam;
@interface TJHttpTool : NSObject

/**
 *  发送get请求
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void(^)(id responseObject))success
    failure:(void(^)(NSError *error))failure;

/**
 *  发送post请求
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError *error))failure;

/**
 *  上传请求 _old
 */
+ (void)UPLoad:(NSString *)URLString
    parameters:(id)paramaters
   uploadParam:(TJUPLoadParam *)uploadParam
       success:(void(^)(id responseObject))success
       failure:(void(^)(NSError *error))failure;

/**
 *  上传请求 _new
 */
+ (void)upLoadData:(NSData *)data
           success:(void(^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))success;
@end

