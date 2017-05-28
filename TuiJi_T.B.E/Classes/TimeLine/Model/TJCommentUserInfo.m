//
//  TJCommentUserInfo.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCommentUserInfo.h"

@implementation TJCommentUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId"                      :@"deputyuserid",
             @"remark"                      :@"remarks",
             @"nickname"                    :@"deputyusername",
             @"headImage"                   :@"deputyuserpictrue"
             };
}

- (NSString *)remark{
    if (!TJStringIsNull(_remark))   return _remark;
    if (!TJStringIsNull(_nickname)) return _nickname;
    
    return _userId;
}
@end
