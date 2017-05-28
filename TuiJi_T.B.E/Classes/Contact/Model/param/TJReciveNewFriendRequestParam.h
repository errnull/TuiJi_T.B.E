//
//  TJReciveNewFriendRequestParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJReciveNewFriendRequestParam : NSObject

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *userID;

/**
 *  好友id
 */
@property (nonatomic ,copy) NSString *friendID;

/**
 *  状态码 0为拒绝1为允许添加
 */
@property (nonatomic ,copy) NSString *state;


@end
