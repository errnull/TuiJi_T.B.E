//
//  TJUserInfoTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserInfoTool.h"
#import "TJUserInfo.h"
#import "TJAccount.h"

#import "TJURLList.h"

@interface TJUserInfoTool ()

@end

@implementation TJUserInfoTool

/**
 *  取用户信息
 */
+ (TJUserInfo *)userInfo
{
    return [self userInfoSuccess:^() {} failure:^(NSError *error) {}];
}

+ (TJUserInfo *)userInfoSuccess:(void (^)())success failure:(void (^)(NSError *))failure
{
    if (success) {
        success();
    }

    TJUserInfo *userInfo = [[TJUserInfo alloc] init];
    
    userInfo.uUsername      = @"developZHAN";
    userInfo.uSignature     = @"孤独是一个人的狂欢";
    userInfo.uRealname      = @"詹铎坚";
    userInfo.uEmail         = @"developZHAN@163.com";
    userInfo.uPicture       = @"http://tvax3.sinaimg.cn/crop.0.0.512.512.180/d8262c5cly8fdbze3w3vmj20e80e80tk.jpg";
    userInfo.uTel           = @"15622777959";
    userInfo.uCountry       = @"中国·广州_&CHI";
    userInfo.uSex           = NIMUserGenderMale;
    userInfo.uPublic        = @"1";
    userInfo.uNickname      = @"詹瞻要去哪😑";
    userInfo.background     = TJAccountCurrent.token;
    userInfo.userId         = @"12345678";
    
    return userInfo;
}

+ (void)modifyUserInfoWithParam:(NSDictionary *)param Success:(void (^)())success failure:(void (^)(NSError *))failure
{
    NSString *URLStr = [TJUrlList.modifyUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    paramDic[@"username"] = TJAccountCurrent.account;
    
    [TJHttpTool POST:URLStr
          parameters:paramDic
             success:^(id responseObject) {
                
                 if ([responseObject[@"code"] isEqualToString:TJStatusSussess]) {
                     if (success) {
                         success();
                     }
                 }
                 
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
}


@end
