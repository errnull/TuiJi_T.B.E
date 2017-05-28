//
//  TJLocationTool.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@interface TJLocationTool : NSObject

+ (void)setupAMapServicesApiKey:(NSString *)apiKey;

/**
 *  单次获取当前位置
 */
+ (void)currentLocationSuccess:(void(^)(CLLocation *location, NSString *locationString))success
                       failure:(void(^)(NSError *error))failure;

/**
 *  获取附近 poi
 *  
 *  如果传入的location是nil 则默认重新获取当前位置
 */
+ (void)reGeocodeSearchWithLocation:(CLLocation *)location
                            success:(void(^)(NSMutableArray *locationNameList))success
                            failure:(void(^)(NSError *error))failure;
@end
