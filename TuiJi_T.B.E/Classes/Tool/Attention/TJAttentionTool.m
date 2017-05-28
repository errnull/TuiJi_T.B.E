//
//  TJAttentionTool.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAttentionTool.h"
#import "TJAttention.h"
#import "TJURLList.h"
#import "TJAccount.h"

@implementation TJAttentionTool

+ (void)loadAttentionListSuccess:(void (^)(NSMutableArray *attentionList))success failure:(void (^)(NSError *))failure{
    
    NSString *URLStr = [TJUrlList.loadAllMyAttention stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool POST:URLStr
          parameters:@{@"userID":TJAccountCurrent.userId}
             success:^(id responseObject) {
                 
                 NSArray *attentionArr = [[responseObject firstObject][@"list"] firstObject][@"attentionList"];
                 NSArray *squareAttentionArr = [[responseObject firstObject][@"list"] firstObject][@"squareAttentionList"];
                 
                 NSMutableArray *attentionList = [TJAttention mj_objectArrayWithKeyValuesArray:attentionArr];
                 [attentionList addObjectsFromArray:[TJAttention mj_objectArrayWithKeyValuesArray:squareAttentionArr]];
                 
                 //更新到数据库
                 for (TJAttention *attention in attentionList) {
                     [TJDataCenter addSingleObject:attention];
                 }
                 
                 if (success) {
                     success(attentionList);
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                }
             
             }];
    
}

+ (NSMutableArray *)attentionList{
    
    //从数据库中获取关注着列表
    RLMResults<TJAttention *> *attentionArr = [TJAttention allObjects];
    
//    NSMutableArray *attentionList = [NSMutableArray arrayWithArray:(NSArray *)attentionArr];
    NSMutableArray *arr = [NSMutableArray array];
    for (TJAttention *att in attentionArr) {
        [arr addObject:att];
    }
    
    return arr;
}


+ (BOOL)isMyAttention:(NSString *)friendId{
    
    RLMResults<TJAttention *> *resultArr = [TJAttention objectsWhere:[NSString stringWithFormat:@"attentionid = '%@'",friendId]];
    
    if (resultArr.count) {
        return YES;
    }
    return NO;
}

+ (void)payAttntionToSB:(NSString *)friendId where:(NSInteger)type Success:(void (^)())success failure:(void (^)(NSError *))failure{
    
    if (friendId.length != TJAccountCurrent.userId.length) {
        type = 1;
    }
    
    NSString *URLStr = [TJUrlList.payAttentionTo stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool POST:URLStr
          parameters:@{@"userID":TJAccountCurrent.userId, @"attentionID":friendId, @"type":@(type).stringValue}
             success:^(id responseObject) {
                 
                 if ([[responseObject firstObject][@"code"] isEqual: @200]) {
                     if (success) {
                         success();
                     }
                 }else{
                     failure(nil);
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
}

+ (void)unPayAttntionToSB:(NSString *)friendId where:(NSInteger)type Success:(void (^)())success failure:(void (^)(NSError *error))failure{

    if (friendId.length != TJAccountCurrent.userId.length) {
        type = 1;
    }
    
    NSString *URLStr = [TJUrlList.unPayAttentionTo stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool POST:URLStr
          parameters:@{@"userID":TJAccountCurrent.userId, @"attentionID":friendId, @"type":@(type).stringValue}
             success:^(id responseObject) {
                 if ([[responseObject firstObject][@"code"] isEqual: @200]) {
                     if (success) {
                         success();
                     }
                 }else{
                     failure(nil);
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
    
}
@end
