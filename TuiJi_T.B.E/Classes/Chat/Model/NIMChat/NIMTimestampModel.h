//
//  NIMTimestampModel.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/27.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMTimestampModel : NSObject

- (CGFloat)height;

/**
 *  时间戳
 */
@property (nonatomic, assign) NSTimeInterval messageTime;

@end
