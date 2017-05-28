//
//  NSString+TJStatusCode.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "NSString+TJStatusCode.h"

static NSDictionary *_statusList;

@implementation NSString (TJStatusCode)

+ (NSDictionary *)statusList
{
    if (!_statusList) {
        //拼接文件名
        NSString *path = [[NSBundle mainBundle] pathForResource:@"StatusCode" ofType:@"plist"];
        
        _statusList = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _statusList;
}

+(NSString *)statusWithCode:(NSString *)code
{
    return [self statusList][code];
}

- (BOOL)validateMobileNumber
{
    NSString *MOBILE = @"^1[34578]\\d{9}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    if ([regexTestMobile evaluateWithObject:self]) {
        return YES;
    }else {
        return NO;
    }
}

@end
