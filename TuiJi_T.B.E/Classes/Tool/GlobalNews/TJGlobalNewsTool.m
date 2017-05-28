//
//  TJGlobalNewsTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGlobalNewsTool.h"
#import "TJGlobalNewsParam.h"
#import "TJGlobalNews.h"
#import "TJURLList.h"
#import "TJAccount.h"

#import "TJUserExtData.h"

@implementation TJGlobalNewsTool

static NSString *_currentOldsLocation;

+ (void)loadGlobalNewsIfSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //从服务器获取当前进度
    NSString *getUserEXTURl = [TJUrlList.getUserEXT stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool POST:getUserEXTURl
          parameters:@{@"uid":TJAccountCurrent.userId}
             success:^(id responseObject) {
                 TJUserExtData *userExtData = [TJUserExtData mj_objectWithKeyValues:responseObject[@"data"]];
                 NSString *URLStr = nil;
                  NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                 
                 if (TJStringIsNull(userExtData.worldRequestJson) || [userExtData.worldRequestJson rangeOfString:@"id"].location == NSNotFound) {
                     //调用初始化接口
                     URLStr = [TJUrlList.loadGlobalNews stringByAppendingString:TJAccountCurrent.jsessionid];
                 }else{
                     //刷新
                     URLStr = [TJUrlList.loadMoreGlobalNews stringByAppendingString:TJAccountCurrent.jsessionid];
                     paramDic[@"requestJson"] = userExtData.worldRequestJson;
                 }
                 
                
                 
                 
                 [TJHttpTool GET:URLStr
                      parameters:paramDic
                         success:^(id responseObject) {
                             
                             TJGlobalNewsParam *globalNewsParam = [TJGlobalNewsParam mj_objectWithKeyValues:responseObject];
                             if ([globalNewsParam.code isEqualToString:TJStatusSussess]) {
                                 NSArray *globalNewsList = [TJGlobalNews mj_objectArrayWithKeyValuesArray:globalNewsParam.worldTweetVOs];
                                 
                                 userExtData.worldRequestJson = [globalNewsParam.newsFromAndIDs mj_JSONString];
                                 
                                 if (TJStringIsNull(_currentOldsLocation)) {
                                     _currentOldsLocation = [globalNewsParam.newsFromAndIDs mj_JSONString];
                                 }
                                 
                                 //将当前浏览进度保存回服务器
                                 NSMutableDictionary *paramDic = userExtData.mj_keyValues;
                                 [paramDic removeObjectForKey:@"objectSchema"];
                                 
                                 if (!paramDic) {
                                     paramDic = [NSMutableDictionary dictionary];
                                 }
                                 
                                 NSString *setUserExtData = [TJUrlList.setUserEXT stringByAppendingString:TJAccountCurrent.jsessionid];
                                 [TJHttpTool GET:setUserExtData
                                      parameters:@{@"uid":TJAccountCurrent.userId, @"ex":[paramDic mj_JSONString]}
                                         success:^(id responseObject) {} failure:^(NSError *error) {}];

                                 if (success) {
                                     success(globalNewsList);
                                 }
                             }
                             
                             
                         } failure:^(NSError *error) {
                             if (failure) {
                                 failure(error);
                             }
                         }];

             } failure:^(NSError *error) {}];
}

+ (void)loadOldGlobalNewsIfSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.loadOldGlobalNews stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool GET:URLStr
         parameters:@{@"requestJson":_currentOldsLocation}
            success:^(id responseObject) {
                TJGlobalNewsParam *globalNewsParam = [TJGlobalNewsParam mj_objectWithKeyValues:responseObject];
                if ([globalNewsParam.code isEqualToString:TJStatusSussess]) {
                    NSArray *globalNewsList = [TJGlobalNews mj_objectArrayWithKeyValuesArray:globalNewsParam.worldTweetVOs];
                    _currentOldsLocation = [globalNewsParam.newsFromAndIDs mj_JSONString];
                    if (success) {
                        success(globalNewsList);
                    }
                }
            } failure:^(NSError *error) {}];
}
@end
