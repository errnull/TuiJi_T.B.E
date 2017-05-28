//
//  TJContactTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactTool.h"
#import "TJContact.h"
#import "TJGroupContact.h"
#import "TJURLList.h"
#import "TJAccount.h"
#import "TJUserInfo.h"

@implementation TJContactTool

+ (void)saveContact:(TJContact *)contact
{
//    [TJDataCenter addSingleObject:contact];
}

/**
 *  读取联系人
 */
+ (NSMutableArray *)contactList
{
    NSMutableArray *arr = [NSMutableArray array];
    
    TJContact *contact = [[TJContact alloc] init];
    contact.headImage = @"http://tva4.sinaimg.cn/crop.0.2.1242.1242.180/65dc76a3jw8exkme9y57dj20yi0ymabn.jpg";
    contact.remark = @"唐巧_boy";
    contact.username = @"tangQiao_boy";
    
    TJContact *contact01 = [[TJContact alloc] init];
    contact01.headImage = @"http://tva4.sinaimg.cn/crop.0.0.440.440.180/714d99e5jw8ei7x1qwzvuj20c80c83yu.jpg";
    contact01.remark = @"MJ向前冲";
    contact01.username = @"MJ_boy";
    
    TJContact *contact02 = [[TJContact alloc] init];
    contact02.headImage = @"http://tva1.sinaimg.cn/crop.0.0.180.180.180/61e52e09jw1e8qgp5bmzyj2050050aa8.jpg";
    contact02.remark = @"bang";
    contact02.username = @"bang_boy";
    
    TJContact *contact03 = [[TJContact alloc] init];
    contact03.headImage = @"http://tva2.sinaimg.cn/crop.125.0.263.263.180/51530583jw8enrkkdsb0dj20dw0afjse.jpg";
    contact03.remark = @"我就叫Sunny怎么了";
    contact03.username = @"Sunny_boy";
    
    TJContact *contact04 = [[TJContact alloc] init];
    contact04.headImage = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
    contact04.remark = @"董宝君_iOS";
    contact04.username = @"dongBao_boy";
    
    TJContact *contact05 = [[TJContact alloc] init];
    contact05.headImage = @"http://tva2.sinaimg.cn/crop.92.33.478.478.180/9e913c67gw1erwn0j6kqxj20ic0fodgv.jpg";
    contact05.remark = @"React-Native";
    contact05.username = @"RN_boy";
    
    TJContact *contact06 = [[TJContact alloc] init];
    contact06.headImage = @"http://tva2.sinaimg.cn/crop.0.0.180.180.180/693eeff4jw1e8qgp5bmzyj2050050aa8.jpg";
    contact06.remark = @"StackOverflowError";
    contact06.username = @"StackOverflowError";
    
    TJContact *contact07 = [[TJContact alloc] init];
    contact07.headImage = @"http://tva3.sinaimg.cn/crop.0.1.1242.1242.180/55c06004jw8f3vayn1zokj20yi0yktcb.jpg";
    contact07.remark = @"叶孤城___";
    contact07.username = @"yeGu_boy";
    
    TJContact *contact08 = [[TJContact alloc] init];
    contact08.headImage = @"http://tva2.sinaimg.cn/crop.0.0.399.399.180/61d238c7jw1ef05lfrbplj20b40b4abh.jpg";
    contact08.remark = @"请叫我汪二";
    contact08.username = @"dog2_boy";
    
    TJContact *contact09 = [[TJContact alloc] init];
    contact09.headImage = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/642c5793jw8es1tzsl205j20hs0hst9g.jpg";
    contact09.remark = @"杨萧玉HIT";
    contact09.username = @"xiaoYu_boy";
    
    TJContact *contact10 = [[TJContact alloc] init];
    contact10.headImage = @"http://tva3.sinaimg.cn/crop.0.2.507.507.180/c46b3efajw8f5yly6jc1kj20e30e875k.jpg";
    contact10.remark = @"李喜猫";
    contact10.username = @"catLike_gril";
    
    [arr addObject:contact01];
    [arr addObject:contact02];
    [arr addObject:contact03];
    [arr addObject:contact04];
    [arr addObject:contact05];
    [arr addObject:contact06];
    [arr addObject:contact07];
    [arr addObject:contact08];
    [arr addObject:contact09];
    [arr addObject:contact10];
    
    return arr;
}

/**
 *  读取群聊列表
 */
+ (NSMutableArray *)groupContactList
{
    NSMutableArray *arr = [NSMutableArray array];
    
    return arr;
}

/**
 *  删除本地账户文件
 */
+ (void)deleteContac:(NSString *)contactId Success:(void (^)())success failure:(void (^)(NSError *error))failure
{
    
    NSString *URLStr = [TJUrlList.deleteAFriend stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool GET:URLStr
         parameters:@{@"userID":TJAccountCurrent.userId, @"friendID":contactId}
            success:^(id responseObject) {
                if (success) {
                    success();
                }
                
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
    
    
}

+(void)greateGroupContactWithContactList:(NSMutableArray *)contactList Success:(void (^)(NSString *teamId))success failure:(void (^)(NSError *error))failure
{

    NSDate *date = [NSDate date]; // 获得时间对象
    
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    
    NSString *dateStr = [forMatter stringFromDate:date];
    
    NIMCreateTeamOption *option = [NIMCreateTeamOption new];
    option.name = [@"群聊" stringByAppendingString:dateStr];
    option.type = NIMTeamTypeAdvanced;
    option.beInviteMode = NIMTeamBeInviteModeNoAuth;
    option.avatarUrl = @"";
    
    [[NIMSDK sharedSDK].teamManager createTeam:option
                                         users:contactList
                                    completion:^(NSError * _Nullable error, NSString * _Nullable teamId) {
                                    
                                        if (error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }else{
                                            if (success) {
                                                success(teamId);
                                            }
                                        }
                                    
                                        
                                    }];
}
@end
