//
//  TJLocation.m
//  TJXMLUncode
//
//  Created by zhanZhan on 16/6/22.
//  Copyright © 2016年 zhanZhanMac. All rights reserved.
//

#import "TJLocation.h"

@interface TJLocation ()<NSXMLParserDelegate>

@end

@implementation TJLocation

-(NSMutableArray *)subLocations{
    if (!_subLocations) {
        _subLocations = [NSMutableArray array];
    }
    return _subLocations;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)locationWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}



- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> { type : %@, name : %@, Code : %@}", [self class], self, self.regionType,  self.Name, self.Code];
}

@end
