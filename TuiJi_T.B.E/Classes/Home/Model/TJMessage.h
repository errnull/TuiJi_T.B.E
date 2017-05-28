//
//  TJMessage.h
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJContact;
@class NIMRecentSession;

@interface TJMessage : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *messageText;

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) TJContact *contact;

@property (nonatomic, strong) NIMTeam *team;


@property (nonatomic, strong) NIMRecentSession *recentSession;

@end
