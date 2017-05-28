//
//  TJSquarespecialtweets.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquarespecialtweets.h"

@implementation TJSquarespecialtweets

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"content"      :@"context",
             @"time"         :@"date",
             @"squareNewsID" :@"id",
             @"userIcon"     :@"picture",
             @"imageUrl"     :@"photourl",
             
             };
}

@end
