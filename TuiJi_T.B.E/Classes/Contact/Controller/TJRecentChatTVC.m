//
//  TJRecentChatTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJRecentChatTVC.h"

#import "TJMessage.h"
#import "TJContact.h"

#import "TJRecentChatCell.h"

#import "TJAccount.h"

#import "TJHomeTVController.h"
#import "TJTabBar.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"
#import "TJContactTVController.h"

@interface TJRecentChatTVC ()
/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *messagesList;
@end

@implementation TJRecentChatTVC

#pragma mark - system method

/**
 *  懒加载
 */
- (NSMutableArray *)messagesList
{
    if (!_messagesList) {
        _messagesList = [NSMutableArray array];
    }
    return _messagesList;
}
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = TJColorGrayBg;
    
    // 设置导航条内容
    [self setUpNavgationBar];
    
    [self loadViewChatList];
}

#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"最近联系"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
}

- (void)loadViewChatList
{
    NSMutableArray *recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    if (!recentSessions.count) {
        recentSessions = [NSMutableArray array];
    }
    self.messagesList = [NSMutableArray array];
    
    for (NIMRecentSession *recentSession in recentSessions) {
        
        if (recentSession.session.sessionId.length == TJAccountCurrent.userId.length) {
            TJContact *contact = [TJContact contactWithUserId:recentSession.session.sessionId];
            
            if (!contact) continue;
            
            TJMessage *message = [[TJMessage alloc] init];
            message.icon = contact.headImage;
            message.name = contact.remark;
            
            
            message.contact = contact;
            message.session = recentSession.session;
            
            [self.messagesList addObject:message];
        }
    }
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messagesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJMessage *message = self.messagesList[indexPath.row];
    
    TJRecentChatCell *cell = [TJRecentChatCell cellWithTableView:tableView];
    
    cell.message = message;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJMessage *message = self.messagesList[indexPath.row];
    
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
    
    NIMSession *session = [NIMSession session:message.contact.userId type:NIMSessionTypeP2P];
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = @"0";
    talk.contact = message.contact;
    talk.session = session;
    talk.toUserName = message.contact.remark;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    //    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc] initWithSession:message.session
    //                                                                                              contact:message.contact];
    privateChat.hidesBottomBarWhenPushed = YES;
    [home.navigationController pushViewController:privateChat animated:NO];

    
}
@end
