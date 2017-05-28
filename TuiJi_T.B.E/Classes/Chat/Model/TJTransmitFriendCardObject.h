//
//  TJTransmitFriendCardObject.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJTransmitFriendCardObject : NSObject

/**
 *  头像
 */
@property (nonatomic ,copy) NSString *headUrl;

/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *nickname;

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *userId;

/**
 *  推己号
 */
@property (nonatomic ,copy) NSString *username;

@end
