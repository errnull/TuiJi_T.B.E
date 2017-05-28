//
//  TJUPLoadParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUPLoadParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  上传文件的文件名称
 */
@property (nonatomic ,copy) NSString *name;

/**
 *  上传到服务器中的文件名称
 */
@property (nonatomic ,copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic ,copy) NSString *mimeType;



/**
 *  上传文件名
 */
@property (nonatomic, copy) NSString *userpath;

@end
