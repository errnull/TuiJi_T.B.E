//
//  TJSquareNewsTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/10/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquareNewsTool.h"
#import "TJSquareNews.h"
#import "TJSquarespecialtweets.h"

#import "TJURLList.h"
#import "TJAccount.h"
#import "TJUserInfo.h"

#import "TJUserExtData.h"

#import "TJSquareCommentModel.h"

#import "TJSquarespecialtweets.h"



@implementation TJSquareNewsTool

static NSString *_currentOldTweetID;
static NSString *_currentOldSpecialTweetID;

+ (void)loadNewSquareNewSuccess:(void(^)(NSArray *squareNewsList))success failure:(void(^)(NSError *error))failure
{
    //跟服务器获取当前浏览进度
    NSString *getUserEXTURl = [TJUrlList.getUserEXT stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool POST:getUserEXTURl
          parameters:@{@"uid":TJAccountCurrent.userId}
             success:^(id responseObject) {

                 TJUserExtData *userExtData = [TJUserExtData mj_objectWithKeyValues:responseObject[@"data"]];
                 NSString *URLStr = nil;
                 NSString *TweetID = nil;
                 NSString *SpecialTweetID = nil;
                 
                 if (TJStringIsNull(userExtData.SpecialTweetID)) {
                     //初始化
                     URLStr = [TJUrlList.loadSquareNews stringByAppendingString:TJAccountCurrent.jsessionid];
                     
                 }else{
                     //刷新
                     URLStr = [TJUrlList.loadNewSquareNews stringByAppendingString:TJAccountCurrent.jsessionid];
                     TweetID = userExtData.TweetID;
                     SpecialTweetID = userExtData.SpecialTweetID;
                 }
                 
                 NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
                 dicParam[@"TweetID"] = TweetID;
                 dicParam[@"SpecialTweetID"] = SpecialTweetID;
                 
                 [TJHttpTool GET:URLStr
                      parameters:dicParam
                         success:^(id responseObject) {
                             
                             NSMutableArray *squareNewsList = [NSMutableArray array];
                             
                             NSDictionary *list = [[responseObject firstObject][@"list"] firstObject];

                             NSArray *squarespecialtweets = list[@"squarespecialtweets"];
                             for(NSDictionary *dic in squarespecialtweets) {
                                 
                                 TJSquareNews *squareNews = [TJSquarespecialtweets mj_objectWithKeyValues:dic];
                                 squareNews.squareNewsType = @"1";
                                 
                                 if (!TJStringIsNull(squareNews.imageUrl)) {
                                     [squareNewsList addObject:squareNews];
                                 }
                             }
                             
                             userExtData.SpecialTweetID = [NSString stringWithFormat:@"%@",[squarespecialtweets lastObject][@"id"]];
                             
                             if (TJStringIsNull(_currentOldSpecialTweetID)) {
                                 _currentOldSpecialTweetID = [NSString stringWithFormat:@"%@",[squarespecialtweets firstObject][@"id"]];
                             }
                             
                             NSArray *squareTweets = list[@"squareTweets"];
                             for (NSDictionary *dic in squareTweets) {
                                 NSDictionary *squareTweet = dic[@"squareTweet"];
                                 NSMutableArray *pictureList = dic[@"pictureList"];
                                 
                                 TJSquareNews *squareNews = [TJSquareNews mj_objectWithKeyValues:squareTweet];
                                 squareNews.squareNewsType = @"0";
                                 
                                 if ([squareNews.pictureid isEqualToString:@"1"]) {
                                     squareNews.imageUrl = [pictureList lastObject][@"pictureurl"];
                                 }
                                 if (!TJStringIsNull(squareNews.imageUrl)) {
                                     [squareNewsList addObject:squareNews];
                                 }
                             }
                             
                             NSNumber *newSquareTweetNum = [squareTweets lastObject][@"squareTweet"][@"id"];
                             NSString *newSquareTweet = nil;
                             if (newSquareTweetNum) {
                                 newSquareTweet = [NSString stringWithFormat:@"%@",newSquareTweetNum];
                             }
                             
                             
                             if (!TJStringIsNull(newSquareTweet)) {
                                 userExtData.TweetID = newSquareTweet;
                             }
                             
                             if (TJStringIsNull(_currentOldTweetID)) {
                                 _currentOldTweetID = [squareTweets firstObject][@"squareTweet"][@"id"] ? [NSString stringWithFormat:@"%@",[squareTweets firstObject][@"squareTweet"][@"id"]] : userExtData.TweetID;
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
                                 success(squareNewsList);
                             }

                         } failure:^(NSError *error) {
                             if (failure) {
                                 failure(error);
                             }
                         }];
            
             } failure:^(NSError *error) {}];
}

+ (void)loadOldSquareNewSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *URLStr = [TJUrlList.loadOldSquareNews stringByAppendingString:TJAccountCurrent.jsessionid];
    
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    dicParam[@"TweetID"] = _currentOldTweetID;
    dicParam[@"SpecialTweetID"] = _currentOldSpecialTweetID;
    
    [TJHttpTool POST:URLStr
          parameters:dicParam
             success:^(id responseObject) {
                 NSMutableArray *squareNewsList = [NSMutableArray array];
                 
                 NSDictionary *list = [[responseObject firstObject][@"list"] firstObject];
                 
                 NSArray *squarespecialtweets = list[@"squarespecialtweets"];
                 for(NSDictionary *dic in squarespecialtweets) {
                     
                     TJSquareNews *squareNews = [TJSquarespecialtweets mj_objectWithKeyValues:dic];
                     squareNews.squareNewsType = @"1";
                     
                     if (!TJStringIsNull(squareNews.imageUrl)) {
                         [squareNewsList addObject:squareNews];
                     }
                 }
                 _currentOldSpecialTweetID = [NSString stringWithFormat:@"%@",[squarespecialtweets lastObject][@"id"]];
                 
                 NSArray *squareTweets = list[@"squareTweets"];
                 for (NSDictionary *dic in squareTweets) {
                     NSDictionary *squareTweet = dic[@"squareTweet"];
                     NSMutableArray *pictureList = dic[@"pictureList"];
                     
                     TJSquareNews *squareNews = [TJSquareNews mj_objectWithKeyValues:squareTweet];
                     squareNews.squareNewsType = @"0";
                     
                     if ([squareNews.pictureid isEqualToString:@"1"]) {
                         squareNews.imageUrl = [pictureList lastObject][@"pictureurl"];
                     }
                     if (!TJStringIsNull(squareNews.imageUrl)) {
                         [squareNewsList addObject:squareNews];
                     }
                 }
                 _currentOldTweetID = [NSString stringWithFormat:@"%@",[squareTweets lastObject][@"squareTweet"][@"id"]];
                 
                 if (success) {
                     success(squareNewsList);
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
}

+ (void)loadSquareCommentWithID:(NSString *)squareNewsID
                           type:(NSString *)squareNewsType
                        success:(void (^)(NSArray *))success
                        failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.loadSquareComment stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool POST:URLStr
          parameters:@{@"ID":squareNewsID,@"type":squareNewsType}
             success:^(id responseObject) {
                
                 NSMutableArray *squareCommentList = [TJSquareCommentModel mj_objectArrayWithKeyValuesArray:[responseObject firstObject][@"list"]];
                 
                 if (success) {
                     success(squareCommentList);
                 }
                 
                 
             } failure:^(NSError *error) {

                 if (failure) failure(error);
             }];
}

+ (void)loadSquareNewsWithID:(NSString *)squareNewsID
                        type:(NSString *)type
                     Success:(void(^)(id squareNews))success
                     failure:(void(^)(NSError *error))failure;
{
    NSString *URLStr = [TJUrlList.getSquareNewsWithID stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool POST:URLStr
          parameters:@{@"ID":squareNewsID, @"type":type}
             success:^(id responseObject) {
                 TJSquareNews *squareNews = nil;
                 
                 if ([type isEqualToString:@"0"]) {
                     NSDictionary *squareTweet = [responseObject[@"list"] firstObject][@"squareTweet"];
                     NSMutableArray *pictureList = [responseObject[@"list"] firstObject][@"pictureList"];
                     
                     squareNews = [TJSquareNews mj_objectWithKeyValues:squareTweet];
                     squareNews.squareNewsType = @"0";
                     
                     if ([squareNews.pictureid isEqualToString:@"1"]) {
                         squareNews.imageUrl = [pictureList lastObject][@"pictureurl"];
                     }

                 }else{
                     squareNews = [TJSquarespecialtweets mj_objectWithKeyValues:[responseObject[@"list"] firstObject]];
                     squareNews.squareNewsType = @"1";
                 }
                 
                 
                 if (success) {
                     success(squareNews);
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
    
}
@end
