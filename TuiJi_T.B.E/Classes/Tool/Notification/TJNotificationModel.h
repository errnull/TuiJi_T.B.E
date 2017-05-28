//
//  TJNotificationModel.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNotificationModel : NSObject

/**
 *  返回代码 
 *  1000 好友请求
 *  1001 好友请求回复
 *  1002 收到赞
 *  1003 收到新评论
 */
@property (nonatomic ,copy) NSString *code;

@end
