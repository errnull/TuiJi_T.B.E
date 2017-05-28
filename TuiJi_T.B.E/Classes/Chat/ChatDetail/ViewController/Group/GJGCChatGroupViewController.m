//
//  GJGCChatGroupViewController.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatGroupViewController.h"
#import "GJGCChatGroupDataSourceManager.h"
//#import "GJGCGroupInformationViewController.h"
//#import "GJGCPersonInformationViewController.h"

#import "TJGroupChatDetailTVC.h"
#import "TJGroupContactMenber.h"

@interface GJGCChatGroupViewController ()


@end

@implementation GJGCChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationBar];

}


/**
 *  初始化导航
 */
- (void)setUpNavigationBar
{
    //标题
    UIView *subTitleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                           text:self.taklInfo.team.teamName
                                                      textColor:TJColorAutoTitle
                                                    sysFontSize:18];
    self.navigationItem.titleView = subTitleView;
    
    //右边
    UIBarButtonItem *personBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                        Image:TJAutoChooseThemeImage(@"navigationbar_team")
                                                                    highImage:TJAutoChooseThemeImage(@"navigationbar_team_highlighted")
                                                                       target:self
                                                                       action:@selector(rightButtonPressed:)
                                                             forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = personBarBtnItem;
}

#pragma mark - 数据源

- (void)initDataManager
{
    self.dataSourceManager = [[GJGCChatGroupDataSourceManager alloc]initWithTalk:self.taklInfo withDelegate:self];
}

- (void)rightButtonPressed:(id)sender
{
    
    
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.taklInfo.team.teamId
                                          completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
                                              
                                              TJGroupChatDetailTVC *groupChatDetailTVC = [TJGroupChatDetailTVC groupChatDetailTVC];
                                         
                                              NSMutableArray *groupContactMenberList = [TJGroupContactMenber groupContactMenberListWithMenbers:members];
                                              
                                              groupChatDetailTVC.team = self.taklInfo.team;
                                              groupChatDetailTVC.groupContactMemberList = groupContactMenberList;
                                              [(TJNavigationController *)self.navigationController pushToLightViewController:groupChatDetailTVC animated:YES];
                                              
                                          }];

    
    
    
}

#pragma mark - 群聊的时候加个@功能

- (void)chatCellDidLongPressOnHeadView:(GJGCChatBaseCell *)tapedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tapedCell];
    GJGCChatFriendContentModel *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
    [self.inputPanel appendFocusOnOther:[NSString stringWithFormat:@"@%@",contentModel.senderName.string]];
    
}

/**
 *  点击新人欢迎card
 *
 *  @param tappedCell
 */
- (void)chatCellDidTapOnWelcomeMemberCard:(GJGCChatBaseCell *)tappedCell
{
    NSIndexPath *tapIndexPath = [self.chatListTable indexPathForCell:tappedCell];
    GJGCChatFriendContentModel  *contentModel = (GJGCChatFriendContentModel *)[self.dataSourceManager contentModelAtIndex:tapIndexPath.row];
    
//    GJGCPersonInformationViewController *informationVC = [[GJGCPersonInformationViewController alloc]initWithUserId:[contentModel.userId longLongValue] reportType:GJGCReportTypePerson];
//    [[GJGCUIStackManager share]pushViewController:informationVC animated:YES];

}


@end
