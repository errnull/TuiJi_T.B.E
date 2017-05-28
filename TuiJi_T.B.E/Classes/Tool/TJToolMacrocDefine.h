//
//  TJToolMacrocDefine.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGuideTool.h"
#import "TJUICreator.h"
#import "TJAutoLayoutor.h"
#import "TJAccountTool.h"
#import "TJHttpTool.h"
#import "TJURLTool.h"
#import "TJRemindTool.h"
#import "TJUserInfoTool.h"
#import "TJUserInfo.h"
#import "TJUserExtData.h"
#import "TJContactTool.h"
//#import "TJContactGroupTool.h"
#import "TJNewContactRequestTool.h"
#import "TJLocationTool.h"
#import "TJTimeLineTool.h"
#import "TJAttentionTool.h"

/**
 *  文件描述
 *
 *  这个工具宏封装了 工具类宏管理
 */


/**
 *  返回当前账号数据
 */
#define TJAccountCurrent [TJAccountTool account]

/**
 *  返回当前用户信息
 */
#define TJUserInfoCurrent [TJUserInfoTool userInfo]

/**
 *  返回 URL 列表
 */
#define TJUrlList [TJURLTool URLList]
