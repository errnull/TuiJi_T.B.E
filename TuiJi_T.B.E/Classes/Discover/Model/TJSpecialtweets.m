//
//  TJSpecialtweets.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSpecialtweets.h"

@implementation TJSpecialtweets


- (NSString *)date{
        if (TJStringNumOnly(_date)) {
            _date = [NSString timeWithTimeIntervalString:_date];
        }
        return _date;
}
@end
