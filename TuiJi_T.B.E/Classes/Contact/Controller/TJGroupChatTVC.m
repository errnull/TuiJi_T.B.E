//
//  TJGroupChatTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGroupChatTVC.h"

#import "TJGroupContact.h"
#import "TJRecentChatCell.h"

#import "TJCreateGroupContactTVC.h"

#import "TJTabBar.h"
#import "TJHomeTVController.h"
#import "TJContactTVController.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatGroupViewController.h"

@interface TJGroupChatTVC ()<TJCreateGroupContactTVCDelegate>

/**
 *  群聊列表
 */
@property (nonatomic, strong) NSMutableArray *groupChatList;

@end

@implementation TJGroupChatTVC
#pragma mark - system method
/**
 *  懒加载
 */
- (NSMutableArray *)groupChatList{
    return [TJContactTool groupContactList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = TJColorGrayBg;
    
    [self setUpNavgationBar];
    
    [self setUpHeadView];
}


#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"群聊"
                                                   textColor:TJColorAutoTitle 
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
}

/**
 *  设置创建群聊按钮
 */
- (void)setUpHeadView
{

    UIView *headView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 45)
                                               bgColor:TJColorGrayBg
                                                radius:0];
    
    UIButton *createGroupBtn = [TJUICreator createButtonWithTitle:@"创建群聊"
                                                             size:CGSizeMake(TJWidthDevice - 20, 45 - 12)
                                                       titleColor:TJColorWhite
                                                             font:TJFontWithSize(14)
                                                           target:self
                                                           action:@selector(createGroupBtnClick:)];
    
    [createGroupBtn setBackgroundColor:TJColor(89, 120, 186)];
    createGroupBtn.layer.cornerRadius = 8;
    createGroupBtn.layer.masksToBounds = YES;
    
    [TJAutoLayoutor layView:createGroupBtn atTheView:headView margins:UIEdgeInsetsMake(6, 10, 6, 10)];
    self.tableView.tableHeaderView = headView;
    
    
}

- (void)createGroupBtnClick:(UIButton *)sender
{
    //创建群聊
    TJCreateGroupContactTVC *createGroupContactTVC = [[TJCreateGroupContactTVC alloc] init];
    
    createGroupContactTVC.hidesBottomBarWhenPushed = YES;
    createGroupContactTVC.delegate = self;
    
    [self.navigationController pushViewController:createGroupContactTVC animated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJGroupContact *groupContact = self.groupChatList[indexPath.row];
    
//    TJHomeTVController *home = self..tabBarController.childViewControllers[0].childViewControllers[0];
    TJContactTVController *contactTVController = [self.navigationController.childViewControllers firstObject];
    TJHomeTVController *home = contactTVController.tabBarController.childViewControllers[0].childViewControllers[0];

    [self.navigationController popViewControllerAnimated:NO];
    
    for (UIView *view in contactTVController.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:[TJTabBar class]]) {
            TJTabBar *tabbar = (TJTabBar*)view;
            [tabbar btnClick:tabbar.buttons[0]];
            break;
        }
    }
    
    NIMSession *session = [NIMSession session:groupContact.teamId type:NIMSessionTypeTeam];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:groupContact.teamId];
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypeGroup;
    talk.toId = groupContact.teamId;
    talk.toUserName = team.teamName;
    talk.team = team;
    talk.session = session;
    
    GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
    groupChat.hidesBottomBarWhenPushed = YES;
    
    [home.navigationController pushViewController:groupChat animated:NO];

    
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groupChatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJGroupContact *groupContact = self.groupChatList[indexPath.row];
    
    TJRecentChatCell *cell = [TJRecentChatCell cellWithTableView:tableView];
    
    cell.groupContact = groupContact;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)createGroupContactTVC:(UIViewController *)createGroupContactTVC didFinishCreate:(NSString *)teamID{
    
    TJHomeTVController *home = [self.navigationController.childViewControllers firstObject].tabBarController.childViewControllers[0].childViewControllers[0];
    [self.navigationController popViewControllerAnimated:NO];
    
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:[TJTabBar class]]) {
            TJTabBar *tabbar = (TJTabBar*)view;
            [tabbar btnClick:tabbar.buttons[0]];
            break;
        }
    }
    
    NIMSession *session = [NIMSession session:teamID type:NIMSessionTypeTeam];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:teamID];
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypeGroup;
    talk.toId = teamID;
    talk.toUserName = team.teamName;
    talk.team = team;
    talk.session = session;
    
    GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
    
    groupChat.hidesBottomBarWhenPushed = YES;
    
    [home.navigationController pushViewController:groupChat animated:NO];
}
@end
