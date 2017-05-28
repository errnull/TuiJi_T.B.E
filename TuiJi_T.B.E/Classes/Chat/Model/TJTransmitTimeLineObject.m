//
//  TJTransmitTimeLineObject.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTransmitTimeLineObject.h"

@implementation TJTransmitTimeLineObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"tuiwenID"            :KEY_USER_ID,
             @"tType"               :KEY_TYPE,
             @"headImage"           :KEY_HEAD_URL,
             @"nickname"            :KEY_NICKNAME,
             @"context"             :KEY_TEXT,
             @"imgUrl"              :KEY_PHOTO,
             @"videoUrl"            :KEY_VIDEO,
             };
}

@end
