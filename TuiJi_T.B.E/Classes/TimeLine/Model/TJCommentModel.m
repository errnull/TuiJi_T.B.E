//
//  TJCommentModel.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCommentModel.h"

@implementation TJCommentModel

- (NSMutableAttributedString *)realComments{

    NSMutableAttributedString *abs = nil;
    NSString *totalStr = nil;
    
    if (_refFriendsInfo) {
        
        totalStr = [NSString stringWithFormat:@"回复%@: %@",_refFriendsInfo.remark,_comments];
        abs = [[NSMutableAttributedString alloc] initWithString:totalStr];
        
        //range
        NSRange keyRange = [totalStr rangeOfString:_refFriendsInfo.remark];
        //颜色
        [abs addAttribute:NSForegroundColorAttributeName value:TJColorBlueFont range:keyRange];

    }else{
        
        abs = [[NSMutableAttributedString alloc] initWithString:_comments];
    }
    
    return abs;
}

@end
