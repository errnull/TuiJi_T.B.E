//
//  TJGroupChatDetailTVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJGroupChatDetailTVC : UITableViewController

+ (instancetype)groupChatDetailTVC;

@property (nonatomic, strong) NSMutableArray *groupContactMemberList;

@property (nonatomic, strong) NIMTeam *team;
@end
