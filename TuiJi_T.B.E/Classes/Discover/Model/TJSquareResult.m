//
//  TJSquareResult.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquareResult.h"

#import "TJSquareTweet.h"

@implementation TJSquareResult

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"squareTweet":[TJSquareTweet class]};
}

@end
