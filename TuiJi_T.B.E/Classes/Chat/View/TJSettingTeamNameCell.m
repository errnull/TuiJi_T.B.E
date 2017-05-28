//
//  TJSettingTeamNameCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSettingTeamNameCell.h"

@interface TJSettingTeamNameCell ()

@property (weak, nonatomic) IBOutlet UITextField *settingTeamNameView;


@end

@implementation TJSettingTeamNameCell

- (NSString *)currentTeamName{
    return _settingTeamNameView.text;
}

- (void)setTeam:(NIMTeam *)team{
    _team = team;
    
    [self.settingTeamNameView setText:self.team.teamName];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJSettingTeamNameCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJSettingTeamNameCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
@end
