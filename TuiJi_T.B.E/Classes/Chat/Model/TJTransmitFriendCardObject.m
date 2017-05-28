//
//  TJTransmitFriendCardObject.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTransmitFriendCardObject.h"

@implementation TJTransmitFriendCardObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId"                  :CARD_USER_ID,
             @"username"                :CARD_TUIJI
             };
}


@end
