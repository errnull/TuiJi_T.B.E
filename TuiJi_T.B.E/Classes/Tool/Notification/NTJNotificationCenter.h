//
//  NTJNotificationCenter.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTJNotificationCenter : NSObject

+ (instancetype)sharedCenter;
- (void)start;

@end