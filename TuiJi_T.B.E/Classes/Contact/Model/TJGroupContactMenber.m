//
//  TJGroupContactMenber.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGroupContactMenber.h"

@implementation TJGroupContactMenber

- (NSString *)headImage{
    if (!_headImage) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:_userId];
        _headImage = user.userInfo.avatarUrl;
    }
    return _headImage;
}

- (NSString *)nickname{
    if (!_nickname) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:_userId];
        _nickname = user.userInfo.nickName;
    }
    return _nickname;
}

+ (NSMutableArray *)groupContactMenberListWithMenbers:(NSArray *)members{
    
    NSMutableArray *list = [NSMutableArray array];
    
    if (!members.count) {
        return list;
    }
    
    for (NIMTeamMember *teamMember in members) {
        TJGroupContactMenber *member = [TJGroupContactMenber mj_objectWithKeyValues:teamMember];
        
        [list addObject:member];
    }
    
    return list;
}

- (NSString *)remark{
    if (!TJStringIsNull(_remark))   return _remark;
    if (!TJStringIsNull(_nickname)) return _nickname;
    
    return _userId;
}
@end
