//
//  TJDataCenter.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//



#import "TJURLList.h"
#import "TJAccount.h"
#import "TJUserInfo.h"
#import "TJContact.h"
#import "TJNewContactRequest.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

static NSFileManager *_dataFileManager;

@interface TJDataCenter ()



@end

@implementation TJDataCenter

static RLMRealm *_userRealm;

/**
 *  懒创建 缓存数据库
 */
+ (RLMRealm *)userRealm
{
    if (!_userRealm) {
         NSString *path = [TJUserInfoFolderName stringByAppendingPathComponent:@"cache.realm"];
        
        //判断文件夹是否存在
        if ([self.dataFileManager fileExistsAtPath:path]) {
            _userRealm = [RLMRealm realmWithURL:[NSURL URLWithString:path]];
        }else{
            _userRealm = [self createRealmWithPath:path];
        }
        //设置默认realm数据库
        [RLMRealmConfiguration setDefaultConfiguration:_userRealm.configuration];
    }
    return _userRealm;
}

+ (NSString *)mainDataFolderName
{
    return [TJCacheDirectory stringByAppendingPathComponent:@"TuiJiData"];
}

+ (NSFileManager *)dataFileManager
{
    if (!_dataFileManager) {
        _dataFileManager = [NSFileManager defaultManager];
    }
    return _dataFileManager;
}

+ (void)createMainDataFolder
{
    //判断文件夹是否存在
    if ([self.dataFileManager fileExistsAtPath:TJMainDataFolderName]) {
        return;
    }
    
    NSError *error = nil;
    [[self dataFileManager] createDirectoryAtPath:TJMainDataFolderName withIntermediateDirectories:NO attributes:nil error:&error];
    
//    //设置不主动备份到iTunes
//    NSURL *url = [NSURL fileURLWithPath:TJMainDataFolderName];
//    [url setResourceValue:[NSNumber numberWithBool:YES]
//                   forKey:NSURLIsExcludedFromBackupKey
//                    error:&error];
}

+ (void)createUserInfoFolder
{
    //判断文件夹是否存在
    if ([self.dataFileManager fileExistsAtPath:TJUserInfoFolderName]) {
        return;
    }
    
    NSError *error = nil;
    [[self dataFileManager] createDirectoryAtPath:TJUserInfoFolderName withIntermediateDirectories:NO attributes:nil error:&error];
    
}

+ (RLMRealm *)createRealmWithPath:(NSString *)path
{
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = [NSURL URLWithString:path];
    
    NSError *error = nil;

    return [RLMRealm realmWithConfiguration:config error:&error];
}

/**
 *  添加不重复数据
 */
+ (void)addSingleObject:(RLMObject *)object
{
    [TJMainDataBase beginWriteTransaction];
    [[object class] createOrUpdateInRealm:TJMainDataBase withValue:object];
    [TJMainDataBase commitWriteTransaction];
}

+ (void)addAObject:(RLMObject *)object
{
    [TJMainDataBase beginWriteTransaction];
    [TJMainDataBase addObject:object];
    [TJMainDataBase commitWriteTransaction];
}

+ (void)deleteAObject:(RLMObject *)object
{
    [TJMainDataBase beginWriteTransaction];
    [TJMainDataBase deleteObject:object];
    [TJMainDataBase commitWriteTransaction];
}

+ (void)deleteAObjectWithClassName:(NSString *)className conditions:(NSString *)conditions
{
    //查询该类在数据库中满足条件的数据
    RLMResults *result = [NSClassFromString(className) objectsWhere:conditions];
    
    [TJMainDataBase beginWriteTransaction];
    [TJMainDataBase deleteObjects:result];
    [TJMainDataBase commitWriteTransaction];
}

+ (void)deleteAllObjectWithClassName:(NSString *)className{
    
    //查询该类在数据库中的全部数据
    RLMResults *result = [NSClassFromString(className) allObjects];

    [TJMainDataBase beginWriteTransaction];
    [TJMainDataBase deleteObjects:result];
    [TJMainDataBase commitWriteTransaction];
    
}

+ (void)deleteAllData
{
    [TJMainDataBase beginWriteTransaction];
    [TJMainDataBase deleteAllObjects];
    [TJMainDataBase commitWriteTransaction];
}

+ (NSMutableArray *)dataListForClass:(Class)className
{
    RLMResults *results = [className allObjects];
    
    return (NSMutableArray *)results;
}

+(void)saveImage:(UIImage *)image Success:(void (^)())success failure:(void (^)(NSError *))failure{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library saveImage:image toAlbum:@"TuiJi" completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            if (success) {
                success();
            }
            [TJRemindTool showSuccess:@"保存成功."];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
