//
//  TJContact.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContact.h"


@implementation TJContact

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"username"                :@"uUsername",
             @"realName"                :@"uRealname",
             @"registTime"              :@"uRegisttime",
             @"region"                  :@"uCountry",
             @"isPublic"                :@"uPublic",
             };
}

- (BOOL)notifyForNewMsg{
    
    BOOL flag = [[NIMSDK sharedSDK].userManager notifyForNewMsg:self.userId];
    
    return flag;
}

- (NSString *)remark{
    if (!TJStringIsNull(_remark))   return _remark;
    if (!TJStringIsNull(_nickname)) return _nickname;
    
    return _userId;
}


+ (NSMutableArray *)contactlistWithNIMUsers:(NSArray<NIMUser *> *)users{
    NSMutableArray *contactList = [NSMutableArray array];
    for (NIMUser *user in users) {
        [contactList addObject:[self contactWithNIMUser:user]];
    }
    return contactList;
}

+ (instancetype)contactWithNIMUser:(NIMUser *)user
{
    TJContact *contact = [TJContact mj_objectWithKeyValues:user.userInfo.ext];
    
    if (!contact) {
        contact = [[TJContact alloc] init];
    }
    
    contact.userId = user.userId;
    contact.remark = user.alias;
    contact.nickname = user.userInfo.nickName;
    contact.headImage = user.userInfo.avatarUrl;
    contact.signature = user.userInfo.sign;
    contact.e_mail = user.userInfo.email;
    contact.phoneNumber = user.userInfo.mobile;
    contact.sex = user.userInfo.gender;
//    contact.background = 
    
    return contact;
}

+ (instancetype)contactWithUserId:(NSString *)userId{
    NSArray *userList = [[NIMSDK sharedSDK].userManager myFriends];
    for (NIMUser *user in userList) {
        if ([user.userId isEqualToString:userId]) {
            return [self contactWithNIMUser:user];
        }
    }
    return nil;
}

+ (instancetype)contactWithUserName:(NSString *)userName{
    NSArray *userList = [[NIMSDK sharedSDK].userManager myFriends];
    for (NIMUser *user in userList) {
        TJContact *contact = [self contactWithNIMUser:user];
        
        if ([contact.username isEqualToString:userName]) {
            return contact;
        }
    }
    return nil;
}
@end
