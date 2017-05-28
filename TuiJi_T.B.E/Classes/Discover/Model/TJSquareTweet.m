//
//  TJSquareTweet.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquareTweet.h"

@implementation TJSquareTweet
- (NSString *)time{
    if (TJStringNumOnly(_time)) {
        _time = [NSString timeWithTimeIntervalString:_time];
    }
    return _time;
}
@end
