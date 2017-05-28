//
//  TJSquareCommentModel.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquareCommentModel.h"

@implementation TJSquareCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"commentId"                       :@"id",
             @"time"                            :@"tine"
            };
}


- (NSMutableAttributedString *)realComments{
    
    NSMutableAttributedString *abs = nil;
    NSString *totalStr = nil;
    
    if (![_fathercommentid isEqualToString:@"-1"]) {
        
        totalStr = [NSString stringWithFormat:@"回复%@: %@",_lnterlocutortwoname,_commentcontent];
        abs = [[NSMutableAttributedString alloc] initWithString:totalStr];
        
        //range
        NSRange keyRange = [totalStr rangeOfString:_lnterlocutortwoname];
        //颜色
        [abs addAttribute:NSForegroundColorAttributeName value:TJColorBlueFont range:keyRange];
        
    }else{
        
        abs = [[NSMutableAttributedString alloc] initWithString:_commentcontent];
    }
    
    return abs;
}

@end
