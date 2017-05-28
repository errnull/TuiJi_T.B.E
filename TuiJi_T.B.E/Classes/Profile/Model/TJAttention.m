//
//  TJAttention.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAttention.h"

@implementation TJAttention

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"attentionUid"                :@"id"
             };
}

/**
 *  设置主键
 */
+ (NSString *)primaryKey{
    return @"attentionid";
}

- (NSString *)attentionid{
    if (!_attentionid) {
        _attentionid = _attentionname;
    }
    return _attentionid;
}
@end
