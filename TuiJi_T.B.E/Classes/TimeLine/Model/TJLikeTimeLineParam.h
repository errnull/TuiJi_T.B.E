//
//  TJLikeTimeLineParam.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLikeTimeLineParam : NSObject

/**
 *  点赞者ID
 */
@property (nonatomic ,copy) NSString *hostId;

/**
 *  被赞推文ID
 */
@property (nonatomic ,copy) NSString *tId;
@end
