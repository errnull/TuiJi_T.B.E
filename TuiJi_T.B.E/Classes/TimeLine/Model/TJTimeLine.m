//
//  TJTimeLine.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLine.h"

@implementation TJTimeLine

- (NSString *)tTime{
    if (TJStringNumOnly(_tTime)) {
        _tTime = [NSString timeWithTimeIntervalString:_tTime];
    }
    return _tTime;
}

@end
