//
//  TJNewContactRealm.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

@interface TJNewContactRequest : RLMObject


/**
 *  用户组id
 */
@property NSString *deputyuserid;
/**
 *  用户名称
 */
@property NSString *deputyusername;
/**
 *  用户头像url地址
 */
@property (nonatomic) NSString *deputyuserpictrue;
/**
 *  请求信息
 */
@property NSString *message;

/**
 *  消息类型
 */
@property (nonatomic ,assign) TJNewFriendCellType addNewFriendCellType;

@end

RLM_ARRAY_TYPE(TJNewContactRequest)
