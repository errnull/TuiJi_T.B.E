//
//  TJSettingTeamNicknameCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/25.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJSettingTeamNicknameCell : UITableViewCell

@property (nonatomic, strong) NIMTeamMember *myTeamInfo;

@property (nonatomic ,copy) NSString *currentNickname;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
