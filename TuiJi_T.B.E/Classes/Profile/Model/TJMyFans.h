//
//  TJMyFans.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMyFans : NSObject

/**
 *  粉丝uid
 */
@property (nonatomic ,copy) NSString *fanid;

/**
 *  粉丝昵称
 */
@property (nonatomic ,copy) NSString *fanname;

/**
 *  粉丝头像
 */
@property (nonatomic ,copy) NSString *fanspicture;

/**
 *  粉丝id
 */
@property (nonatomic ,copy) NSString *fansId;

/**
 *  用户id
 */
@property (nonatomic ,copy) NSString *userid;
@end
