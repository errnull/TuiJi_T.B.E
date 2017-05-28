//
//  TJNewContactRealm.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewContactRequest.h"

@implementation TJNewContactRequest

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

//- (void)setDeputyuserpictrue:(NSString *)deputyuserpictrue{
//    NSString *url = [@"http://120.24.44.99:8080/" stringByAppendingString:deputyuserpictrue];
//    
//    _deputyuserpictrue = url;
//}

/**
 *  设置主键
 */
+ (NSString *)primaryKey{
    return @"deputyuserid";
}
@end
