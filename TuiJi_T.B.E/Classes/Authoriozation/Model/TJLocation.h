//
//  TJLocation.h
//  TJXMLUncode
//
//  Created by zhanZhan on 16/6/22.
//  Copyright © 2016年 zhanZhanMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLocation : NSObject

@property (nonatomic ,copy) NSString *regionType;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *Code;
@property (nonatomic, strong) NSMutableArray *subLocations;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)locationWithDic:(NSDictionary *)dic;

@end
