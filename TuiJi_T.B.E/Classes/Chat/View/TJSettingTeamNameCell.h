//
//  TJSettingTeamNameCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJSettingTeamNameCell : UITableViewCell

@property (nonatomic, strong) NIMTeam *team;

@property (nonatomic ,copy) NSString *currentTeamName;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
