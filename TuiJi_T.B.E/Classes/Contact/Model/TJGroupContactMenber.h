//
//  TJGroupContactMenber.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGroupContactMenber : NSObject

/**
 *  群ID
 */
@property (nonatomic,copy)         NSString *teamId;

/**
 *  邀请者ID
 *  @dicusssion 此字段仅当该成员为自己时有效。不允许查看其他群成员的邀请者
 */
@property (nonatomic,copy)         NSString *invitor;

/**
 *  群成员ID
 */
@property (nonatomic,copy)         NSString *userId;

/**
 *  用户头像
 */
@property (nonatomic ,copy)        NSString *headImage;

/**
 *  群成员类型
 */
@property (nonatomic,assign)       NIMTeamMemberType  type;


/**
 *  群昵称
 */
@property (nonatomic,copy)         NSString *nickname;


/**
 *  被禁言
 */
@property (nonatomic,assign)       BOOL isMuted;

/**
 *  进群时间
 */
@property (nonatomic,assign)       NSTimeInterval createTime;


/**
 *  新成员群自定义信息
 */
@property (nonatomic,copy)         NSString *customInfo;


@property (nonatomic ,copy) NSString *remark;

@property (nonatomic ,assign) BOOL contactSelected;

+ (NSMutableArray *)groupContactMenberListWithMenbers:(NSArray *)members;


@end
