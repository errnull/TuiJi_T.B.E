//
//  TJNewContactRequestTool.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewContactRequestTool.h"
#import "TJNewContactRequest.h"

#import "TJURLList.h"
#import "TJAccount.h"

@implementation TJNewContactRequestTool

//+ (void)saveNewContact:(TJNewContactRequest *)NewContactRequest
//{
//    //    // 获取默认的 Realm 实例
//    //    RLMRealm *realm = [RLMRealm defaultRealm];
//    //    // 每个线程只需要使用一次即可
//    //
//    //    // 通过事务将数据添加到 Realm 中
//    //    [realm beginWriteTransaction];
//    //    [realm addObject:NewContactRealm];
//    //    [realm commitWriteTransaction];
//    
//    
//    [TJDataCenter addSingleObject:NewContactRequest];
//    
//}

+ (NSMutableArray *)NewContactRequestListSuccess:(void (^)())success failure:(void (^)(NSError *))failure
{

    if (success) {
        success();
    }

    NSMutableArray *arr = [NSMutableArray array];
    
    return arr;
}

+ (NSMutableArray *)newContactRequestList
{
    return [TJDataCenter dataListForClass:NSClassFromString(@"TJNewContactRequest")];
}

+ (void)addNewContactRequestToDataBaseWithKeyValues:(id)KeyValues
{
    
    //模型转换
    RLMArray<TJNewContactRequest> *newContacts = (RLMArray<TJNewContactRequest> *)[TJNewContactRequest mj_objectArrayWithKeyValuesArray:KeyValues];
    //本地化
    for (TJNewContactRequest *newContactRequest in newContacts) {
        [TJDataCenter addSingleObject:newContactRequest];
    }
}

+ (void)deleteNewContact
{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    if (_newContactList.count != 0 && _newContactList) {
//        [realm deleteObjects:_newContactList];
//    }
//    [realm commitWriteTransaction];
//
//    _newContactList = nil;
}
@end
