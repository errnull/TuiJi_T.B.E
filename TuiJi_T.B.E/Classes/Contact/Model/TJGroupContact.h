//
//  TJGroupContact.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGroupContact : NSObject

/**
 *  群ID
 */
@property (nonatomic,copy)      NSString *teamId;

/**
 *  群名称
 */
@property (nonatomic,copy)               NSString *teamName;

/**
 *  群头像
 */
@property (nonatomic,copy)               NSString *teamHeadIcon;

/**
 *  群缩略头像
 *  @discussion 仅适用于使用云信上传服务进行上传的资源，否则无效。
 */
@property (nonatomic,copy)               NSString *thumTeamHeadIcon;

/**
 *  群拥有者ID
 *  @discussion 普通群拥有者就是群创建者,但是高级群可以进行拥有信息的转让
 */
@property (nonatomic,copy)      NSString *owner;

/**
 *  群介绍
 */
@property (nonatomic,copy)              NSString *teamIntro;

/**
 *  群公告
 */
@property (nullable,nonatomic,copy)              NSString *teamannoun;

/**
 *  群成员人数
 *  @discussion 这个值表示是上次登录后同步下来群成员数据,并不实时变化,必要时需要调用fetchTeamInfo:completion:进行刷新
 */
@property (nonatomic,assign)   NSInteger memberNumber;

/**
 *  群创建时间
 */
@property (nonatomic,assign)    NSTimeInterval createTime;

/**
 *  修改群信息权限
 *  @discussion 只有高级群有效
 */
@property (nonatomic,assign)    NIMTeamUpdateInfoMode updateInfoMode;

/**
 *  修改群客户端自定义字段权限
 *  @discussion 只有高级群有效
 */
@property (nonatomic,assign)    NIMTeamUpdateClientCustomMode updateClientCustomMode;


/**
 *  群服务端自定义信息
 *  @discussion 应用方可以自行拓展这个字段做个性化配置,客户端不可以修改这个字段
 */
@property (nullable,nonatomic,copy,readonly)      NSString *serverCustomInfo;


/**
 *  群客户端自定义信息
 *  @discussion 应用方可以自行拓展这个字段做个性化配置,客户端可以修改这个字段
 */
@property (nullable,nonatomic,copy,readonly)     NSString *clientCustomInfo;


/**
 *  群消息是否需要通知
 *  @discussion 这个设置影响群消息的 APNS 推送
 */
@property (nonatomic,assign,readonly) BOOL notifyForNewMsg;

+ (NSMutableArray *)groupContactListWithNIMTeams:(NSArray<NIMTeam *> *)Teams;

@end
