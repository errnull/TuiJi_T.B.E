//
//  TJSettingTeamNicknameCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/25.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSettingTeamNicknameCell.h"

@interface TJSettingTeamNicknameCell ()
@property (weak, nonatomic) IBOutlet UITextField *myTeamNickNameTextField;

@end

@implementation TJSettingTeamNicknameCell

- (NSString *)currentNickname{
    return _myTeamNickNameTextField.text;
}

- (void)setMyTeamInfo:(NIMTeamMember *)myTeamInfo{
    _myTeamInfo = myTeamInfo;
    
    [self.myTeamNickNameTextField setText:_myTeamInfo.nickname];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJSettingTeamNicknameCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJSettingTeamNicknameCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

@end
