//
//  TJTimeLineNewStatus.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJTimeLineNewStatus : RLMObject

/**
 *  消息正文
 */
@property (nonatomic ,copy) NSString *message;
/**
 *  消息所在推文id
 */
@property (nonatomic ,copy) NSString *tId;
/**
 *  消息所在用户id
 */
@property (nonatomic ,copy) NSString *uId;

@end
