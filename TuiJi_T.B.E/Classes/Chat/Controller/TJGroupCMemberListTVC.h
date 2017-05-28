//
//  TJGroupCMemberListTVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJGroupCMemberListTVC : UITableViewController

@property (nonatomic, strong) NIMTeam *currentTeam;
@property (nonatomic, strong) NSMutableArray *groupMemberList;

@end
