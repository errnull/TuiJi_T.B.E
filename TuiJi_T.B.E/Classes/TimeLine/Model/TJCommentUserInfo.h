//
//  TJCommentUserInfo.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJCommentUserInfo : NSObject

/**
 *  用户id
 */
//@property (nonatomic ,copy) NSString *deputyuserid;
@property (nonatomic ,copy) NSString *userId;

/**
 *  用户备注名称
 */
//@property (nonatomic ,copy) NSString *remarks;
@property (nonatomic ,copy) NSString *remark;

/**
 *  用户名称
 */
//@property (nonatomic ,copy) NSString *deputyusername;
@property (nonatomic ,copy) NSString *nickname;

/**
 *  用户头像url地址
 */
//@property (nonatomic, copy) NSString *deputyuserpictrue;
@property (nonatomic ,copy) NSString *headImage;



@end
