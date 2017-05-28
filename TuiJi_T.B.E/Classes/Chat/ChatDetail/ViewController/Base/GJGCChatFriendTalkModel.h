//
//  GJGCChatFriendTalkModel.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCChatFriendContentModel.h"

@class TJContact;
@class NIMSession;
@class NIMTeam;

#define GJGCTalkTypeString(talkType) [GJGCChatFriendTalkModel talkTypeString:talkType]

@interface GJGCChatFriendTalkModel : NSObject

@property (nonatomic,copy)NSString *toId;

@property (nonatomic,copy)NSString *toUserName;

@property (nonatomic,assign)GJGCChatFriendTalkType talkType;

@property (nonatomic,strong)NSArray *msgArray;

@property (nonatomic,assign)NSInteger msgCount;


@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) TJContact *contact;
@property (nonatomic, strong) NIMTeam *team;


+ (NSString *)talkTypeString:(GJGCChatFriendTalkType)talkType;

@end
