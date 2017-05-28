//
//  TJSquareNews.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquareNews.h"

@implementation TJSquareNews

- (void)setPhotourl:(NSString *)photourl{
    _imageUrl = photourl;
    
    if (photourl) {
        _pictureid = @"1";
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
                @"time"         :@"date",
                @"squareNewsID" :@"id",
                @"userIcon"     :@"userpicture",
             };
}

- (NSString *)time{
    if (TJStringNumOnly(_time)) {
        _time = [NSString timeWithTimeIntervalString:_time];
    }
    return _time;
}
@end
