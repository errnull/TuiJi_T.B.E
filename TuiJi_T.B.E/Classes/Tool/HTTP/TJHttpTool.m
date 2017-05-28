//
//  TJHttpTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/21.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJHttpTool.h"
#import "AFNetworking.h"
#import "TJUPLoadParam.h"

#import "TJURLList.h"
#import "TJAccount.h"

#import "TJUserInfo.h"

@implementation TJHttpTool

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    //创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //AFN请求成功时调用block
             //将请求成功时做的事情封装成block传递过去
             if (success) {
                 success(responseObject);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(error);
             }else{
                 [TJRemindTool hideHUD];
//                 [TJRemindTool showError:@"网络异常"];
                 NSLog(@"%@",error);
             }
         }];
}


+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    //创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URLString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  success(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [TJRemindTool hideHUD];
//              [TJRemindTool showError:@"网络异常"];
              
              NSLog(@"%@",error);
              if (failure) {
                  failure(error);
              }
          }];
}

+ (void)UPLoad:(NSString *)URLString
    parameters:(id)paramaters
   uploadParam:(TJUPLoadParam *)uploadParam
       success:(void(^)(id responseObject))success
       failure:(void(^)(NSError *error))failure
{
    //创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //发送上传请求
    [manager POST:URLString
       parameters:paramaters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    //将要上传的数据全部拼接到formData中
    [formData appendPartWithFileData:uploadParam.data
                                name:uploadParam.name
                            fileName:uploadParam.fileName
                            mimeType:uploadParam.mimeType];
    
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (success) {
        success(responseObject);
    }
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
        failure(error);
    }
}];
}

+ (void)upLoadData:(NSData *)data
           success:(void(^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))success
{
    //获取upLoadToken
    NSString *URLStr = [TJUrlList.getUploadToken stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool POST:URLStr
          parameters:@{@"pin":TJAccountCurrent.userId, @"uid":[NSString getAuthCode]}
             success:^(id responseObject) {
                 
                 if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:TJStatusSussess]) {
                     //获取成功,开始上传
                     NSString *token = responseObject[@"data"];
                     QNUploadManager *manager = [[QNUploadManager alloc] init];
                     [manager putData:data
                                  key:[TJAccountCurrent.jsessionid stringByAppendingString:[TJStringCurrentTimeStamp stringByAppendingString:@".png"]]
                                token:token
                             complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                 
                                 if (success) {
                                     success(info, key, resp);
                                 } 
                             } option:nil];
                 }
                 
                 
             } failure:^(NSError *error) {}];
}
@end
