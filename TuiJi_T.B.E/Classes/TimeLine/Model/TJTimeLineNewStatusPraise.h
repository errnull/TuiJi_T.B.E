//
//  TJTimeLineNewStatusPraise.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJTimeLineNewStatus.h"

@interface TJTimeLineNewStatusPraise : TJTimeLineNewStatus

/**
 *  消息类型
 */
@property (nonatomic ,copy) NSString *code;

@end

RLM_ARRAY_TYPE(TJTimeLineNewStatusPraise)
