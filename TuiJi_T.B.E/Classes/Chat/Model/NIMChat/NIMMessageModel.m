//
//  NIMMessageModel.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "NIMMessageModel.h"

@implementation NIMMessageModel

- (instancetype)initWithMessage:(NIMMessage*)message
{
    if (self = [self init])
    {
        _message = message;
    }
    return self;
}

@end
