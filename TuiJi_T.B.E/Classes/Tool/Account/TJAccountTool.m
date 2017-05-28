//
//  TJAccountTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAccount.h"
#import "TJAccountTool.h"
#import "TJSignParam.h"
#import "TJURLList.h"



#define TJAccountFileName [TJDocumentsDirectory stringByAppendingPathComponent:@"account.data"]

static TJAccount *_account;

@interface TJAccountTool ()

@end

@implementation TJAccountTool


+ (void)saveAccount:(TJAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:TJAccountFileName];
    
}

+ (TJAccount *)account{
    if (!_account) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:TJAccountFileName];
        
        //如果本地没有储存,返回空
        if(!_account){return nil;}
        //判断账号是否过期 过期的话重新获取权限
    }
    
    if ([[NSDate date] compare:_account.expires_date] != NSOrderedAscending) {
        
        //已过期,重新获取权限
        TJSignParam *signParam = [[TJSignParam alloc] init];
        signParam.username = _account.account;
        signParam.password = _account.password;
    
        
        [TJAccountTool loginWithAccount:_account.account
                               password:_account.password
                                   Type:TJAccountToolTypeSignIn
                                success:^{} failure:^{}];
    }

    return _account;
}

+ (void)loginWithAccount:(NSString *)username
                password:(NSString *)password
                    Type:(TJAccountToolType) accountToolType
                 success:(void (^)())success
                 failure:(void (^)())failure
{
    TJAccount *account      = [[TJAccount alloc] init];
    account.code            = TJStatusSussess;
    account.sessiontime     = @"1111111111111";
    account.jsessionid      = @"12345678";
    account.token           = @"12345678";
    account.userId          = @"12345678";
    account.account         = @"12345678";
    account.password        = @"12345678";
    account.messageCode     = @"0000";
    
    account.token = @"0";
    
    [TJAccountTool saveAccount:account];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success();
        }
    });
    
/*

    //根据类型修改url
    NSString *URLStr;
    switch (accountToolType) {
        case TJAccountToolTypeSignIn:
            URLStr = TJUrlList.signIn;
            break;
        case TJAccountToolTypeSignUp:
            URLStr = TJUrlList.signUp;
            break;
        case TJAccountToolTypePwdForgot:
            URLStr = @"";
            break;
        default:
            break;
    }
    
    TJSignParam *param = [[TJSignParam alloc] init];
    param.username = username;
    param.password = password;

    [TJHttpTool POST:URLStr
          parameters:param.mj_keyValues
             success:^(id responseObject) {
                 //字典转模型
                 TJAccount *account = [TJAccount mj_objectWithKeyValues:responseObject];
                 
                 //如果请求失败
                 if (![account.code isEqualToString:TJStatusSussess]) {
                     [TJRemindTool showError:[NSString statusWithCode:account.code]];
                     //账户密码错误重新登录
                     if([account.code isEqualToString:TJStatusPwdError]){
                         [self deleteAccountData];
                     }
                 }else{
                     //请求成功
                     if (accountToolType == TJAccountToolTypeSignIn) {
                         //如果当前请求行为是登陆
                         //登陆成功
                         account.account = username;
                         account.password = password;

                         //保存账号信息
                         [self deleteAccountData];
                         [self saveAccount:account];
                         
                         //登录成功
                         if (success) {
                             success();
                         }
                         
                     }else if(accountToolType == TJAccountToolTypeSignUp){
                         //如果当前行为是注册
                         if (success) {
                             success();
                         }
                     }
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure();
                 }
             }];
*/
}

/**
 *  初始化用户资料
 */
+ (void)loadBaseUserData
{
    //创建默认数据库
    TJMainDataBase;
    
    //加载用户基本资料
    [TJUserInfoTool userInfoSuccess:^() {
        
        //加载通讯录列表
        [TJContactTool contactList];
        
        //加载群聊
        [TJContactTool groupContactList];
        
        //获取用户所有好友请求
        [TJNewContactRequestTool NewContactRequestListSuccess:^{
            
            //加载用户关注列表进数据库
//            [TJAttentionTool loadAttentionListSuccess:^(NSMutableArray *attentionList) {} failure:^(NSError *error) {}];
            
            //初始化成功时切换控制器
            [TJGuideTool guideRootViewController:TJKeyWindow];
            
            [TJRemindTool hideHUD];
            
        } failure:^(NSError *error) {}];
    }failure:^(NSError *error) {}];
}



+ (void)deleteAccountData
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:TJAccountFileName error:nil];
    
    _account = nil;
}

@end
