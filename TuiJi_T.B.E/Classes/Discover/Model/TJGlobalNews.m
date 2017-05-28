//
//  TJGlobalNews.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGlobalNews.h"

#define TJFromMediaKeyVideo @"video"

@implementation TJGlobalNews

- (NSString *)fromMediaCHI{
    if (!_fromMediaCHI) {
        _fromMediaCHI = [self fromMediaAnalysWithMedia:self.fromMedia];
    }
    return _fromMediaCHI;
}


- (NSString *)fromMediaAnalysWithMedia:(NSString *)fromMedia
{
    
    if ([fromMedia isEqualToString:@"youtube"]) {
        return TJFromMediaKeyVideo;
    }else if ([fromMedia isEqualToString:@"edinburghnews"]){
        return @"英国爱丁堡晚报";
    }else if ([fromMedia isEqualToString:@"TouTiao"]){
        return @"今日头条";
    }else if ([fromMedia isEqualToString:@"dailynews"]){
        return @"泰国每日新闻";
    }else if ([fromMedia isEqualToString:@"saudigazette"]){
        return @"沙特公报";
    }else if ([fromMedia isEqualToString:@"dispatch"]){
        return @"韩国dispatch新闻网";
    }else if ([fromMedia isEqualToString:@"tuoitre"]){
        return @"越南青年报";
    }else{
        return [NSString stringWithFormat:@"来自: %@",fromMedia];
    }
}

- (NSString *)time{
    if (TJStringNumOnly(_time)) {
        _time = [NSString timeWithTimeIntervalString:_time];
    }
    return _time;
}
@end
