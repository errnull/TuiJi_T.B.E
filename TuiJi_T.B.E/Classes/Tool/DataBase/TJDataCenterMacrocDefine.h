//
//  TJDataCenterMacrocDefine.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

/**
 *  文件描述
 *
 *  各种数据文件/文件夹 路径宏定义
 */


#import "TJDataCenter.h"

/** *  ------------------------- 路径定义 ------------------------- */

#define TJDocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
#define TJCacheDirectory     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define TJLibraryDirectory   [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]

/**
 *  用户数据根目录
 */
#define TJMainDataFolderName [TJDataCenter mainDataFolderName]

/**
 *  用户数据文件夹
 */
#define TJUserInfoFolderName [TJMainDataFolderName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",TJAccountCurrent.token]]

/**
 *  缓存数据库
 */
#define TJMainDataBase [TJDataCenter userRealm]
