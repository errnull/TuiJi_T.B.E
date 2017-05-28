//
//  TJTimeLineTool.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineTool.h"
#import "TJURLList.h"
#import "TJAccount.h"
#import "TJNewTimeLineParam.h"
#import "TJLikeTimeLineParam.h"
#import "TJCollectTimeLineParam.h"
#import "TJPublicTimeLineParam.h"
#import "TJTimeLine.h"

#import "TJCommentUserInfo.h"
#import "TJCommentModel.h"

#import <CoreLocation/CoreLocation.h>

@implementation TJTimeLineTool

+ (void)loadTimeLineWithSinceID:(NSString *)sinceID
                        orMaxID:(NSString *)maxID
                        success:(void (^)(NSMutableArray *))success
                        failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.loadNewTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    //创建请求参数
    TJNewTimeLineParam *newTimeLineParam = [[TJNewTimeLineParam alloc] init];
    newTimeLineParam.uId = TJAccountCurrent.userId;
    newTimeLineParam.type = @"2";
    newTimeLineParam.since_id = sinceID;
    newTimeLineParam.max_id = maxID;
    
    [TJHttpTool GET:URLStr
         parameters:newTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                
                if (success) {

                    NSMutableArray *timeLineArr = [NSMutableArray array];
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        
                        TJTimeLine *timeLine = [TJTimeLine mj_objectWithKeyValues:dic];
                        
                        timeLine.headImage = dic[@"friendsInfo"][@"deputyuserpictrue"];
                        timeLine.nickname = dic[@"friendsInfo"][@"deputyusername"];
                        timeLine.userId = dic[@"friendsInfo"][@"deputyuserid"];
                        
                        timeLine.isPublic = dic[@"userInfo"][@"uPublic"];
                        
                        timeLine.location = [[CLLocation alloc] initWithLatitude:[dic[@"tLng"] floatValue] longitude:[dic[@"tLat"] floatValue]];
                        
                        if (![timeLine.isTurn isEqualToString:@"0"]) {
                            timeLine.transmitTimeLine = [TJTimeLine mj_objectWithKeyValues:dic[@"turnTweet"]];
                        }
                        
                        [timeLineArr addObject:timeLine];
                    }
                    
                    success(timeLineArr);
    
                }
                
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
}

+ (void)loadTimeLineCommentWithTuiID:(NSString *)tuiID
                             success:(void (^)(NSArray *))success
                             failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.loadTimeLineComment stringByAppendingString:TJAccountCurrent.jsessionid];
    
    success(nil);
    
//    [TJHttpTool GET:URLStr
//         parameters:@{@"tId":tuiID,@"currentUid":TJAccountCurrent.userId}
//            success:^(id responseObject) {
//    
//                NSMutableArray *timeLineCommentList = [TJCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//                
//                if (success) {
//                    success([[timeLineCommentList reverseObjectEnumerator] allObjects]);
//                }
//                
//            } failure:^(NSError *error) {
//                if (failure) {
//                    failure(error);
//                }
//            }];
}

+ (void)likeTimeLineID:(NSString *)timeLineID
               success:(void (^)())success
               failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.userLikeTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJLikeTimeLineParam *likeTimeLineParam = [[TJLikeTimeLineParam alloc] init];
    likeTimeLineParam.hostId = TJAccountCurrent.userId;
    likeTimeLineParam.tId = timeLineID;
    
    [TJHttpTool GET:URLStr
         parameters:likeTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                
                if (success) {
                    success();
                }
                
            } failure:^(NSError *error) {
                if(failure){
                    failure(error);
                }
            }];
}

+ (void)collectTimeLineID:(NSString *)timeLineID
                  success:(void (^)())success
                  failure:(void (^)(NSError *))failure
{
    NSString *URLString = [TJUrlList.collectTuiTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJCollectTimeLineParam *param = [[TJCollectTimeLineParam alloc] init];
    param.collectorId = TJAccountCurrent.userId;
    param.tId = timeLineID;
    
    [TJHttpTool POST:URLString
          parameters:param.mj_keyValues
             success:^(id responseObject) {
                 
                 if (success) {
                     success();
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
    
}

+ (void)publicTimeLineWithText:(NSString *)text
                 imageDataList:(NSMutableArray *)imageDataList
                     audioData:(NSData *)audioData
                     videoData:(NSData *)videoData
             remindSomeFriends:(NSMutableArray *)friendIDList
                        region:(NSString *)region
                      location:(CLLocation *)location
                    filterlist:(NSMutableArray *)filterlist
                    filtertype:(NSString *)filtertype
                       success:(void (^)())success
                       failure:(void (^)(NSError *error))failure
{
    //类型匹配
    TJPublicTimeLineParam *param = [[TJPublicTimeLineParam alloc] init];
    
    param.authorId = TJAccountCurrent.userId;
    param.tContent = text;
    param.address = region;
    param.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    param.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    param.at = [friendIDList mj_JSONString];
    param.filter = [filterlist mj_JSONString];
    param.filtertype = filtertype;
    
    if (videoData) {
        param.tType = @"4";
        
        //上传视频
        [TJTimeLineTool upLoadMedia:videoData
                          imageData:[imageDataList firstObject]
                            success:^(NSString *mulmediaUrl, NSString *pathJson) {
                                param.mulmediaUrl = mulmediaUrl;
//                                param.pathJson = pathJson;
                                
                                
                                //提交推文
                                NSString *URLStr = [TJUrlList.publicTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
                                [TJHttpTool GET:URLStr
                                     parameters:param.mj_keyValues
                                        success:^(id responseObject) {
                                            
                                            if (success) {
                                                success();
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
                                
                                
                                
                            } failure:^(NSError *error) {}];
        
        
        
        
        
    }else if(audioData){
        param.tType = @"3";
    }else if (!imageDataList.count){
        
        //当推文只有文本时, 判断文本是否有效
        if (TJStringIsNull(text) || TJStringIsAllWhiteSpace(text)) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"不能发送空推己圈哦." code:0 userInfo:nil];
                failure(error);
            }
            return;
        }else{
            param.tType = @"0";
            param.tContent = text;

            //提交推文
            NSString *URLStr = [TJUrlList.publicTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
            [TJHttpTool GET:URLStr
                 parameters:param.mj_keyValues
                    success:^(id responseObject) {
                        
                        if (success) {
                            success();
                        }
                        
                    } failure:^(NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];

            
            
            
        }
    }else{
        //有图
        if(TJStringIsNull(text)){
            
            param.tType = @"2";

        }else{
            param.tType = @"1";
            param.tContent = text;
        }
        
        //上传图片
        [TJHttpTool upLoadData:[imageDataList firstObject]
                       success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           if (resp[@"key"]) {
                               NSString *imagePath = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
                               param.pathJson = [@[imagePath] mj_JSONString];
                           }
                           //提交推文
                           NSString *URLStr = [TJUrlList.publicTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
                           [TJHttpTool GET:URLStr
                                parameters:param.mj_keyValues
                                   success:^(id responseObject) {
                                       
                                       if ([responseObject[@"code"] isEqual: @200]) {
                                           if (success) {
                                               success();
                                           }
                                       }else{
                                           if (failure) {
                                               failure(nil);
                                           }
                                       }
                                       

                                       
                                   } failure:^(NSError *error) {
                                       if (failure) {
                                           failure(error);
                                       }
                                   }];
                       }];
        
        
}
    

    
    
    
    
    
    
    
    
    
//        if (self.timeLineTextView.text.length) {
//    
//            TJPublicTimeLineParam *publicTimeLineParam = [[TJPublicTimeLineParam alloc] init];
//            publicTimeLineParam.authorId = TJAccountCurrent.userId;
//            publicTimeLineParam.tContent = self.timeLineTextView.text;
//            publicTimeLineParam.tType = @"0";
//            publicTimeLineParam.tPrivate = @"0";
//    
//            if (self.heightForLocationCell.constant != 0) {
//               publicTimeLineParam.address = self.locationResultBtn.titleLabel.text;
//            }
//    
//            NSString *URLStr = [TJUrlList.publicTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
//            [TJHttpTool GET:URLStr
//                 parameters:publicTimeLineParam.mj_keyValues
//                    success:^(id responseObject) {
//    
//                        [TJRemindTool showSuccess:@"发布成功😊.."];
//    
//                    } failure:^(NSError *error) {
//                        [TJRemindTool showError:@"发布失败"];
//                        [self.navigationController pushViewController:self animated:YES];
//                    }];
//    
//            [self.navigationController popViewControllerAnimated:YES];
//    
//        }else{
//            
//            [TJRemindTool showError:@"发空的推己圈没人看哦😯..."];
//            
//        }
}

+ (void)upLoadMedia:(NSData *)mediaData
          imageData:(NSData *)imageData
            success:(void (^)(NSString *mulmediaUrl, NSString *pathJson))success
            failure:(void (^)(NSError *error))failure
{
    [TJHttpTool upLoadData:mediaData
                   success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                       if(resp[@"key"]){
                           NSString *mulmediaUrl = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
                           //上传图片
                           if (imageData) {
                               [TJHttpTool upLoadData:imageData
                                              success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                                  if (resp[@"key"]) {
                                                      NSString *imagePath = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
                                                      if (success) {
                                                          success(mulmediaUrl, imagePath);
                                                      }
                                                  }}];
                           }else{
                               if (success) {
                                   success(mulmediaUrl, nil);
                               }
                           }}}];
}

+ (void)deleteATimeLineWithTimeLineId:(NSString *)timeLineId
                              success:(void (^)())success
                              failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.deleteATimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":TJAccountCurrent.userId, @"tId":timeLineId}
            success:^(id responseObject) {
                
                if (success) {
                    success();
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
}
@end
