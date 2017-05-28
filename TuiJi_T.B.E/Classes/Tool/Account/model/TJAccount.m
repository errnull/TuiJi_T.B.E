//
//  TJAccount.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAccount.h"

@implementation TJAccount
/**
 *  重写有效期的setter方法计算过期时间
 */
- (void)setSessiontime:(NSString *)sessiontime{
    _sessiontime = sessiontime;
    
    
    _expires_date = [NSDate dateWithTimeIntervalSinceNow:[sessiontime longLongValue]];
}

//MJCode
MJCodingImplementation

@end
