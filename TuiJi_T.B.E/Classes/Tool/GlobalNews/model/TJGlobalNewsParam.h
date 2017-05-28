//
//  TJGlobalNewsParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGlobalNewsParam : NSObject

/**
 *  状态码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  世界推文
 */
@property (nonatomic ,strong) NSArray *worldTweetVOs;

/**
 *  下标
 */
@property (nonatomic ,strong) NSArray *newsFromAndIDs;

@end
