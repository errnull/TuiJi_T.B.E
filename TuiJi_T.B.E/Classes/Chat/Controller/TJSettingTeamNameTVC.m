//
//  TJSettingTeamNameTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSettingTeamNameTVC.h"

#import "TJSettingTeamNameCell.h"

@interface TJSettingTeamNameTVC ()

@end

@implementation TJSettingTeamNameTVC

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = TJColorGrayBg;
    
    [self setUpNavgationBar];
}

/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"群聊名称"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
    
    //加好友 按钮
    UIBarButtonItem *rightBtn = [TJUICreator createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                                 text:@"完成"
                                                                 font:TJFontWithSize(14)
                                                                color:TJColorBlackFont
                                                               target:self
                                                               action:@selector(finishSetting)
                                                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

/**
 *  完成 按钮点击事件监听
 */
- (void)finishSetting
{

    TJSettingTeamNameCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"%@",cell.currentTeamName);
    
    [[NIMSDK sharedSDK].teamManager updateTeamName:cell.currentTeamName
                                            teamId:_team.teamId
                                        completion:^(NSError * _Nullable error) {
                                            
                                            if (!error) {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                [TJRemindTool showSuccess:@"修改成功"];
                                            }else{
                                                [TJRemindTool showError:@"修改失败"];
                                            }
                                        
                                        }];
}


#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJSettingTeamNameCell *cell = [TJSettingTeamNameCell cellWithTableView:tableView];
    
    cell.team = _team;
    
    return cell;
    
}

@end
