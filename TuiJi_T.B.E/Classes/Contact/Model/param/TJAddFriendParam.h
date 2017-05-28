//
//  TJAddFriendParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJAddFriendParam : NSObject

/**
 *  用户ID
 */
@property (nonatomic ,copy) NSString *userID;

/**
 *  好友的ID
 */
@property (nonatomic ,copy) NSString *friendID;

/**
 *  请求信息
 */
@property (nonatomic ,copy) NSString *hintMessage;


/**
 *  状态码
 */
@property (nonatomic ,copy) NSString *code;

/**
 *  提示语
 */
@property (nonatomic ,copy) NSString *message;

@end
