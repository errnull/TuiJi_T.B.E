//
//  NTJNotificationCenter.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "NTJNotificationCenter.h"

@interface NTJNotificationCenter ()<NIMSystemNotificationManagerDelegate>

@end

@implementation NTJNotificationCenter

+ (instancetype)sharedCenter
{
    static NTJNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTJNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
//    DDLogInfo(@"Notification Center Setup");
}


#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSLog(@"kjhk");
}
@end
