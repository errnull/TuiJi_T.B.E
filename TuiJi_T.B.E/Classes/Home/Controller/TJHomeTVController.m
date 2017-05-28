//
//  TJHomeTVController.m
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/13.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJHomeTVController.h"
#import "TJMessageCell.h"
#import "TJMessage.h"
#import "TJDropDownMenu.h"
#import "TJURLList.h"
#import "TJAccount.h"
#import "TJUserInfo.h"
#import "TJContact.h"

#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCChatGroupViewController.h"

#import "TJDropDownCellModel.h"

#import "TJCreateGroupContactTVC.h"

#import "HMScannerController.h"

#import "TJNewUserInfoCard.h"
#import "TJPersonalCardViewController.h"

#import "TJContactAddFriendVC.h"

#import "TJFriendCardVC.h"

#import<AudioToolbox/AudioToolbox.h>

#import "TJExtensionMessage.h"


@interface TJHomeTVController ()<NIMConversationManagerDelegate,NIMSystemNotificationManagerDelegate,TJCreateGroupContactTVCDelegate>
/**
 *  模型数组
 */
@property (nonatomic, strong) NSMutableArray *messagesList;

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@end

@implementation TJHomeTVController

TJMessageCell *_currentSelectCell;

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
        
        self.sessionUnreadCount  = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
        [self refreshSessionBadge];
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
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadViewChatList];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"聊天"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    //右边按钮
    UIBarButtonItem *searchBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(18, 18)
                                                                        Image:TJAutoChooseThemeImage(@"navigationbar_search")
                                                                    highImage:TJAutoChooseThemeImage(@"navigationbar_search_highlighted")
                                                                       target:self
                                                                       action:@selector(searchItemClick:)
                                                             forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fixSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixSpaceItem.width = 23;
    UIBarButtonItem *plusBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(18, 18)
                                                                      Image:TJAutoChooseThemeImage(@"navigationbar_plus")
                                                                  highImage:TJAutoChooseThemeImage(@"navigationbar_plus_highlighted")
                                                                     target:self
                                                                     action:@selector(plusItemClick:)
                                                           forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[plusBarBtnItem, fixSpaceItem, searchBarBtnItem];
}

/**
 *  按钮事件点击监听
 */
- (void)searchItemClick:(UIBarButtonItem *)sender
{
   
}

- (void)plusItemClick:(UIBarButtonItem *)sender
{
    TJDropDownMenu *dropMenu = [[TJDropDownMenu alloc] initWithBtnPressedByWindowFrame:((UIButton *)sender).frame
                                                                               Pressed:^(NSInteger index) {
                                                                                   
                                                                                   
                                                                                   [self dropDownBtnClick:index];
                                                                                   
                                                                               }];
    
    dropMenu.direction = TJDirectionTypeBottom;
    
    TJDropDownCellModel *model1 = [TJDropDownCellModel dropDownMenuWithIcon:@"chat_dropDown_createGroupChat" text:@"创建群聊"];
    TJDropDownCellModel *model2 = [TJDropDownCellModel dropDownMenuWithIcon:@"chat_dropDown_addFriend" text:@"添加好友"];
    TJDropDownCellModel *model3 = [TJDropDownCellModel dropDownMenuWithIcon:@"chat_dropDown_scan" text:@"扫一扫"];
    TJDropDownCellModel *model4 = [TJDropDownCellModel dropDownMenuWithIcon:@"chat_dropDown_batchdelete" text:@"同意加群"];
    
    dropMenu.dropDownMenuModel = @[model1, model2, model3, model4];
    
    [self.navigationController.view addSubview:dropMenu];

}

- (void)dropDownBtnClick:(NSInteger)index
{
    if (index == 0) {
        //创建群聊
        TJCreateGroupContactTVC *createGroupContactTVC = [[TJCreateGroupContactTVC alloc] init];
        
        createGroupContactTVC.hidesBottomBarWhenPushed = YES;
        createGroupContactTVC.delegate = self;
        
        [self.navigationController pushViewController:createGroupContactTVC animated:YES];
    }else if (index == 1){
        //添加好友
        /**
         *  加号按钮点击事件监听
         */
        TJContactAddFriendVC *addFriendVC = [[TJContactAddFriendVC alloc] init];
        addFriendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addFriendVC animated:YES];
        
    }else if (index == 2){
        //扫描二维码
        HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
            //将颜色改回主题色
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"navigationBarBackGround")] forBarMetrics:UIBarMetricsDefault];
            
            NSRange range = [stringValue rangeOfString:@"tuiji:"];
            
            if (range.length) {
                NSString *userName = [stringValue substringFromIndex:range.length];

                if ([userName isConnectWithMe]) {
                    
                    TJFriendCardVC *friendCard = [[TJFriendCardVC alloc] init];
                    
                    TJContact *contact = [TJContact contactWithUserName:userName];
                    friendCard.contact = contact;
                    
                    friendCard.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:friendCard animated:YES];
                    
                    
                }else{
                    
                    //通过账户查找用户
                    NSString *URLStr = [TJUrlList.getUserInfoWithNumber stringByAppendingString:TJAccountCurrent.jsessionid];
                    
                    //通过号码请求用户资料
                    [TJHttpTool POST:URLStr
                          parameters:@{@"number":userName}
                             success:^(id responseObject) {
                                 TJNewUserInfoCard *newUserInfoCard = [TJNewUserInfoCard mj_objectWithKeyValues:responseObject];
                                 if ([newUserInfoCard.code isEqualToString:TJStatusSussess]) {
                                     TJPersonalCardViewController *personalCardVC = [[TJPersonalCardViewController alloc] init];
                                     personalCardVC.hidesBottomBarWhenPushed = YES;
                                     personalCardVC.userInfo = newUserInfoCard;
                                     
                                     [(TJNavigationController *)self.navigationController pushToLightViewController: personalCardVC animated:YES];
                                 }else{
                                     [TJRemindTool showError:@"该用户不存在耶..."];
                                 }
                                 
                             } failure:^(NSError *error) {
                                 NSLog(@"");
                                 
                             }];
                }
            }else{
                [TJRemindTool showError:@"暂时只能扫描推己二维码哦."];
                
            }
            
        }];
        
        [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [self showDetailViewController:scanner sender:nil];
        
    }else if (index == 3){
        //同意加群
        
        
    }
}

- (void)loadViewChatList
{
//    NSMutableArray *recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
//    if (!recentSessions.count) {
//        recentSessions = [NSMutableArray array];
//    }
//    self.messagesList = [NSMutableArray array];
//    
//    for (NIMRecentSession *recentSession in recentSessions) {
//        
//        if (recentSession.session.sessionType == NIMSessionTypeP2P) {
//            if ([recentSession.session.sessionId isEqualToString:TJAccountCurrent.userId]) continue;
//            
//            TJContact *contact = [TJContact contactWithUserId:recentSession.session.sessionId];
//            
//            TJMessage *message = [[TJMessage alloc] init];
//            message.icon = contact.headImage;
//            message.name = contact.remark;
//            message.recentSession = recentSession;
//            
//            NSTimeInterval time = recentSession.lastMessage.timestamp;
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            
//            formatter.dateFormat = @"HH";
//            
//            NSString *hour = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//            
//            formatter.dateFormat = @"mm";
//            NSString *min = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//            
//            if (hour.intValue / 12 == 0) {
//                message.time = [NSString stringWithFormat:@"上午%2.@:%02d",hour,min.intValue];
//            }else{
//                
//                formatter.dateFormat = @"hh";
//                NSString *hour12 = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//                
//                message.time = [NSString stringWithFormat:@"下午%@:%02d",hour12,min.intValue];
//            }
//            
//            //        message.time = timeString;
//            
//            message.contact = contact;
//            message.session = recentSession.session;
//            
//            if (recentSession.lastMessage.messageType == NIMMessageTypeText) {
//                message.messageText = recentSession.lastMessage.text;
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeImage){
//                message.messageText = @"[图片]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeAudio){
//                message.messageText = @"[语音]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeCustom){
//                message.messageText = recentSession.lastMessage.apnsContent;
//            }
//            
//            [self.messagesList addObject:message];
//            
//        }else if (recentSession.session.sessionType == NIMSessionTypeTeam){
//            
//            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
//            
//            TJMessage *message = [[TJMessage alloc] init];
//            
//            message.icon = team.avatarUrl;
//            message.name = team.teamName;
//            message.recentSession = recentSession;
//            
//            NSTimeInterval time = recentSession.lastMessage.timestamp;
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            
//            formatter.dateFormat = @"HH";
//            
//            NSString *hour = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//            
//            formatter.dateFormat = @"mm";
//            NSString *min = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//            
//            if (hour.intValue / 12 == 0) {
//                message.time = [NSString stringWithFormat:@"上午%2.@:%02d",hour,min.intValue];
//            }else{
//                
//                formatter.dateFormat = @"hh";
//                NSString *hour12 = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
//                
//                message.time = [NSString stringWithFormat:@"下午%@:%02d",hour12,min.intValue];
//            }
//            
//            //        message.time = timeString;
//            
//            message.team = team;
//            message.session = recentSession.session;
//            
//            if (recentSession.lastMessage.messageType == NIMMessageTypeText) {
//                message.messageText = recentSession.lastMessage.text;
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeImage){
//                message.messageText = @"[图片]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeAudio){
//                message.messageText = @"[语音]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeVideo){
//                message.messageText = @"[视频]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeLocation){
//                message.messageText = @"[位置]";
//            }else if(recentSession.lastMessage.messageType == NIMMessageTypeCustom){
//                
//                NIMCustomObject *object = (NIMCustomObject *)recentSession.lastMessage.messageObject;
//                TJExtensionMessage *extensionMessage = (TJExtensionMessage *)object.attachment;
//                
//                if (extensionMessage.type == TJExtensionMessageValueCard) {
//                    message.messageText = @"[名片]";
//                }else if (extensionMessage.type == TJExtensionMessageValueTweet){
//                    message.messageText = @"[推文]";
//                }
//            }
//            
//            
//            [self.messagesList addObject:message];
//        }
//
//
//    }
    
//    @property (nonatomic, copy) NSString *icon;
//    @property (nonatomic, copy) NSString *name;
//    @property (nonatomic, copy) NSString *time;
//    @property (nonatomic, copy) NSString *messageText;
    
    self.messagesList = [NSMutableArray array];
    
    TJMessage *message = [[TJMessage alloc] init];
    message.icon = @"http://tva4.sinaimg.cn/crop.0.2.1242.1242.180/65dc76a3jw8exkme9y57dj20yi0ymabn.jpg";
    message.name = @"唐巧_boy";
    message.time = @"           昨天";
    message.messageText = @"深圳 Swift 大会的抽奖结果已经公布​​​​";
    
    TJMessage *message01 = [[TJMessage alloc] init];
    message01.icon = @"http://tva4.sinaimg.cn/crop.0.0.440.440.180/714d99e5jw8ei7x1qwzvuj20c80c83yu.jpg";
    message01.name = @"MJ向前冲";
    message01.time = @"           昨天";
    message01.messageText = @"2016对我而言是很关键的一年啦，加油加油，愿一切顺利~ ​​​​";
    
    TJMessage *message02 = [[TJMessage alloc] init];
    message02.icon = @"http://tva1.sinaimg.cn/crop.0.0.180.180.180/61e52e09jw1e8qgp5bmzyj2050050aa8.jpg";
    message02.name = @"bang";
    message02.time = @"           昨天";
    message02.messageText = @"千年努力抵不上苹果爸爸一句话.";
    
    TJMessage *message03 = [[TJMessage alloc] init];
    message03.icon = @"http://tva2.sinaimg.cn/crop.125.0.263.263.180/51530583jw8enrkkdsb0dj20dw0afjse.jpg";
    message03.name = @"我就叫Sunny怎么了";
    message03.time = @"           昨天";
    message03.messageText = @"百度是世界最大的中文搜索引擎.";
    
    TJMessage *message04 = [[TJMessage alloc] init];
    message04.icon = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
    message04.name = @"董宝君_iOS";
    message04.time = @"           昨天";
    message04.messageText = @"你把我放在这里让我有点尴尬.";
    
    TJMessage *message05 = [[TJMessage alloc] init];
    message05.icon = @"http://tva2.sinaimg.cn/crop.92.33.478.478.180/9e913c67gw1erwn0j6kqxj20ic0fodgv.jpg";
    message05.name = @"React-Native";
    message05.time = @"           昨天";
    message05.messageText = @"原价几十万的代码, 现在统统只要20块.";
    
    TJMessage *message06 = [[TJMessage alloc] init];
    message06.icon = @"http://tva2.sinaimg.cn/crop.0.0.180.180.180/693eeff4jw1e8qgp5bmzyj2050050aa8.jpg";
    message06.name = @"StackOverflowError";
    message06.time = @"           昨天";
    message06.messageText = @"少年, 你知道Pin不❓";
    
    TJMessage *message07 = [[TJMessage alloc] init];
    message07.icon = @"http://tva3.sinaimg.cn/crop.0.1.1242.1242.180/55c06004jw8f3vayn1zokj20yi0yktcb.jpg";
    message07.name = @"叶孤城___";
    message07.time = @"           昨天";
    message07.messageText = @"没错, 我就是个会写代码的饭店老板.";
    
    TJMessage *message08 = [[TJMessage alloc] init];
    message08.icon = @"http://tva2.sinaimg.cn/crop.0.0.399.399.180/61d238c7jw1ef05lfrbplj20b40b4abh.jpg";
    message08.name = @"请叫我汪二";
    message08.time = @"           昨天";
    message08.messageText = @"少年你背地里叫我Dog2别以为我不知道.";
    
    TJMessage *message09 = [[TJMessage alloc] init];
    message09.icon = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/642c5793jw8es1tzsl205j20hs0hst9g.jpg";
    message09.name = @"杨萧玉HIT";
    message09.time = @"           昨天";
    message09.messageText = @"MVVM的文章更新啦, 你看了没.";
    
    TJMessage *message10 = [[TJMessage alloc] init];
    message10.icon = @"http://tva3.sinaimg.cn/crop.0.2.507.507.180/c46b3efajw8f5yly6jc1kj20e30e875k.jpg";
    message10.name = @"李喜猫";
    message10.time = @"           昨天";
    message10.messageText = @"小花猫好像想你啦.";
    
    [self.messagesList addObject:message];
    [self.messagesList addObject:message01];
    [self.messagesList addObject:message02];
    [self.messagesList addObject:message03];
    [self.messagesList addObject:message04];
    [self.messagesList addObject:message05];
    [self.messagesList addObject:message06];
    [self.messagesList addObject:message07];
    [self.messagesList addObject:message08];
    [self.messagesList addObject:message09];
    [self.messagesList addObject:message10];
    
    
    [self.tableView reloadData];
    
}

- (void)refreshSessionBadge{
    self.tabBarItem.badgeValue = self.sessionUnreadCount ? @(self.sessionUnreadCount).stringValue : nil;
}

#pragma tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesList.count;
}

- (TJMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *resueID = @"cell";
    
    TJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
    
    if (!cell) {
        cell = [[TJMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueID];
    }
    
    cell.message = self.messagesList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJMessage *message = self.messagesList[indexPath.row];
    
    if (message.session.sessionType == NIMSessionTypeP2P) {
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        talk.contact = message.contact;
        talk.session = message.session;
        talk.toUserName = message.name;
        
        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
        
        privateChat.needShowInputPanel = YES;
        privateChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:privateChat animated:YES];
    }else if (message.session.sessionType == NIMSessionTypeTeam){
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypeGroup;
        talk.toId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        talk.toUserName = message.name;
        talk.team = message.team;
        talk.session = message.session;
        
        GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
        
        groupChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupChat animated:YES];
        
        
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        TJMessage *message = self.messagesList[indexPath.row];
        
        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:message.recentSession];
        
        [self.messagesList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标为未读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        //设置未读
        TJMessage *message = self.messagesList[indexPath.row];
        
        message.recentSession.lastMessage.setting.shouldBeCounted = YES;
        
        [self loadViewChatList];
        
        [tableView reloadData];
//
    }];
    //    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    return @[deleteRowAction, moreRowAction];
}

- (void)deleteCurrentCell
{
    TJMessage *message = _currentSelectCell.message;
    
    [[NIMSDK sharedSDK].conversationManager deleteRecentSession:message.recentSession];
}

- (void)createGroupContactTVC:(UIViewController *)createGroupContactTVC didFinishCreate:(NSString *)teamID{
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
    
    [self.navigationController pushViewController:groupChat animated:NO];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
    
    [self loadViewChatList];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
    
    [self loadViewChatList];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];

}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}
@end
