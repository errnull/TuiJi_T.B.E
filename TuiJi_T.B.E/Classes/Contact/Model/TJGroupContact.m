//
//  TJGroupContact.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGroupContact.h"

@implementation TJGroupContact

- (BOOL)notifyForNewMsg{
    BOOL flag = [[NIMSDK sharedSDK].teamManager notifyForNewMsg:self.teamId];
    
    return flag;
}

+ (NSMutableArray *)groupContactListWithNIMTeams:(NSArray<NIMTeam *> *)Teams
{
    NSMutableArray *groupContactList = [NSMutableArray array];
    
    for (NIMTeam *team in Teams) {
        [groupContactList addObject:[self groupContactWithTeam:team]];
    }
    return groupContactList;
}

+ (instancetype)groupContactWithTeam:(NIMTeam *)team
{
    TJGroupContact *groupContact = [[TJGroupContact alloc] init];
    
    groupContact.teamId = team.teamId;
    groupContact.teamName = team.teamName;
    groupContact.teamHeadIcon = team.avatarUrl;
    groupContact.thumTeamHeadIcon = team.thumbAvatarUrl;
    groupContact.owner = team.owner;
    groupContact.teamIntro = team.intro;
    groupContact.teamannoun = team.announcement;
    groupContact.memberNumber = team.memberNumber;
    
    return groupContact;
}
@end
