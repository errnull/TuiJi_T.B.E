//
//  NIMMessageModel.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMMessageModel : NSObject

/**
 *  消息数据
 */
@property (nonatomic, strong) NIMMessage *message;

- (instancetype)initWithMessage:(NIMMessage*)message;

@end
