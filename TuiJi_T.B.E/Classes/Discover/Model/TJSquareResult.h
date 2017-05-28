//
//  TJSquareResult.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/12.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJSquareTweet.h"

#import "MJExtension.h"

@interface TJSquareResult : NSObject<MJKeyValue>

/**
 *  推文资源
 */
@property (nonatomic, strong) NSArray *pictureList;
@property (nonatomic, strong) TJSquareTweet *squareTweet;

@end
