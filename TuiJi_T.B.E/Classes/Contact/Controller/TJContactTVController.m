//
//  TJContactTVController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactTVController.h"
#import "TJContactSearchResultController.h"
#import "TJContactCell.h"
#import "TJContact.h"
#import "TJContactAddFriendVC.h"
#import "TJSearchController.h"

#import "TJNewContactRequest.h"

#import "TJNewFriendMessageTVC.h"
#import "TJRecentChatTVC.h"
#import "TJGroupChatTVC.h"
#import "TJTuiMessageTVC.h"

#import "TJFriendCardVC.h"

#import "TJContactAlertView.h"

#import "TJHomeTVController.h"
#import "TJTabBar.h"

#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"

#import "TJNotificationModel.h"

#import "TJContactSettingTVC.h"

#import "TJFriendProfileVC.h"

#import "TJCameraController.h"
#import "SimpleVideoFileFilterViewController.h"

#import "TJNewContactRequest.h"

#import "TJURLList.h"
#import "TJAccount.h"
#import "TJNewUserInfoCard.h"


@interface TJContactTVController ()<UISearchBarDelegate, NIMSystemNotificationManagerDelegate, TJContactAlertViewDelegate,SimpleVideoFileFilterViewControllerDelegate>

@property (nonatomic, strong) TJSearchController *searchController;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

@property (nonatomic, strong) NSMutableArray *contactsList;

@property (nonatomic, strong) NSMutableArray *titleSettingArray;

@property (nonatomic,assign) NSInteger sessionUnreadCount;
@end

@implementation TJContactTVController
{
    NSString *_currentVideoPath;
    TJContact *_currentContact;
}
#pragma mark - system method
/**
 *  懒加载
 */
- (NSInteger)sessionUnreadCount{
    NSInteger count = 0;
    
    NSMutableArray *newContactRequestList = [TJNewContactRequestTool NewContactRequestListSuccess:^{} failure:^(NSError *error) {}];
    for (TJNewContactRequest *newContactRequest in newContactRequestList) {
        if (newContactRequest.addNewFriendCellType == TJNewFriendCellTypeWillAdd) {
            count++;
        }
    }
    
    return count;
}

- (NSMutableArray *)titleSettingArray{
    if (!_titleSettingArray) {
        _titleSettingArray = [NSMutableArray array];
    }
    return _titleSettingArray;
}

- (NSMutableArray *)contactsList{
    return [TJContactTool contactList];
}

- (instancetype)init{
    if (self = [super init]) {
        
        //取消分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView.backgroundColor = TJColorGrayBg;
        
        [self setUpNavgationBar];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   [self setUpTableSection];
    
    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    for (UIView *view in self.tableView.subviews) {
        
        if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            UITableViewHeaderFooterView *footView = (UITableViewHeaderFooterView*)view;
            
            footView.tintColor = TJColorGrayBg;
            footView.textLabel.font = TJFontWithSize(14);
            footView.textLabel.textColor = TJColorGrayFontLight;  
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllSubViews];
    
    [self refreshTabBarBadgeCount];
    
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];

    for (UIView *view in self.tableView.subviews) {
        
        if ([view isKindOfClass:[UIView class]] && view.width == TJWidthDevice && ![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            view.backgroundColor = TJColorGrayBg;
            
            break;
            
        }
    }
}

- (void)refreshTabBarBadgeCount{
    [TJNewContactRequestTool NewContactRequestListSuccess:^{
        NSInteger count = 0;
        NSMutableArray *newContactRequestList = [TJNewContactRequestTool NewContactRequestListSuccess:^{} failure:^(NSError *error) {}];
        for (TJNewContactRequest *newContactRequest in newContactRequestList) {
            if (newContactRequest.addNewFriendCellType == TJNewFriendCellTypeWillAdd) {
                count++;
            }
        }
        if (count > 0) {
            self.tabBarItem.badgeValue = TJShowRedPoint;
        }
    } failure:^(NSError *error) {}];
}

- (void)dealloc{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
}
#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"通讯录"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
    
    //加好友 按钮
    UIBarButtonItem *plusBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(18, 19)
                                                                      Image:TJAutoChooseThemeImage(@"navigation_add_friend")
                                                                  highImage:TJAutoChooseThemeImage(@"navigation_add_friend_highlighted")
                                                                     target:self
                                                                     action:@selector(addFriendItemClick:)
                                                           forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = plusBarBtnItem;
}
/**
 *  加号按钮点击事件监听
 */
- (void)addFriendItemClick:(UIBarButtonItem *)sender
{
    TJContactAddFriendVC *addFriendVC = [[TJContactAddFriendVC alloc] init];
    addFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

- (void)setUpAllSubViews
{
    TJContactSearchResultController *searchResultController = [[TJContactSearchResultController alloc] init];
    self.searchController = [[TJSearchController alloc] initWithSearchResultsController:searchResultController];
    self.searchController.view.backgroundColor = TJColorGrayBg;
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    
    UISearchBar *bar = self.searchController.searchBar;
    
    bar.showsCancelButton = NO;
    
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = TJColor(235, 235, 235);       
    bar.tintColor = TJColorBlackFont;
    
    bar.showsBookmarkButton = YES;
    
    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    
    for (UIView *view in bar.subviews) {
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    self.tableView.tableHeaderView = bar;
    self.tableView.sectionIndexColor = TJColorlightGray;
    self.tableView.sectionIndexBackgroundColor = TJColorClear;
}


- (void)setUpTableSection
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (TJContact *model in self.contactsList) {

        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(remark)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(remark)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    NSMutableArray *operrationModels = [NSMutableArray new];
    NSArray *dicts = @[@{@"name" : @"新的好友", @"imageName" : @"contact_add_friend"},
                       @{@"name" : @"最近联系", @"imageName" : @"contact_lately"},
                       @{@"name" : @"群聊", @"imageName" : @"contact_team"  },
                       @{@"name" : @"推信", @"imageName" : @"contact_notification"}];
    for (NSDictionary *dict in dicts) {
        TJContact *model = [TJContact new];
        model.remark = dict[@"name"];
        model.headImage = dict[@"imageName"];
        [operrationModels addObject:model];
    }
    
    [newSectionArray insertObject:operrationModels atIndex:0];
    [self.sectionTitlesArray insertObject:@"" atIndex:0];
    
    self.sectionArray = newSectionArray;
    
}

- (void)refreshSessionBadge{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    TJContactCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [TJNewContactRequestTool NewContactRequestListSuccess:^{
         NSInteger count = 0;
        NSMutableArray *newContactRequestList = [TJNewContactRequestTool NewContactRequestListSuccess:^{} failure:^(NSError *error) {}];
        for (TJNewContactRequest *newContactRequest in newContactRequestList) {
            if (newContactRequest.addNewFriendCellType == TJNewFriendCellTypeWillAdd) {
                count++;
            }
        }
        if (count > 0) {
            self.tabBarItem.badgeValue = TJShowRedPoint;
        }
        
        cell.sessionUnreadCount = count;
    
    } failure:^(NSError *error) {}];
}


#pragma mark - tableView delegate
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

/**
 *  多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitlesArray.count;
}

/**
 * 每一组各多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    TJContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!contactCell) {
        contactCell = [[TJContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }else{

    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    TJContact *contact = self.sectionArray[section][row];
    
    contactCell.contact = contact;
    
    return contactCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一组
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.tabBarItem.badgeValue = nil;
            TJContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.sessionUnreadCount = 0;
            
            TJNewFriendMessageTVC *newFriendMessageTVC = [[TJNewFriendMessageTVC alloc] init];
            
            newFriendMessageTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController: newFriendMessageTVC animated:YES];
        
        }else if(indexPath.row == 1){
            
            TJRecentChatTVC *recentTVC = [[TJRecentChatTVC alloc] init];
            
            recentTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:recentTVC animated:YES];
            
        }else if(indexPath.row == 2){
            
            TJGroupChatTVC *groupChatTVC = [[TJGroupChatTVC alloc] init];
            
            groupChatTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:groupChatTVC animated:YES];
            
        }else if(indexPath.row == 3){
            
            TJTuiMessageTVC *tuiMessageTVC = [[TJTuiMessageTVC alloc] init];
            
            tuiMessageTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:tuiMessageTVC animated:YES];
            
        }
    }else{  // 点击用户
        
        TJContactCell *contactCell = [tableView cellForRowAtIndexPath:indexPath];

        TJContactAlertView *contactAlertView = [TJContactAlertView contactAlertView];
        
        contactAlertView.delegate = self;
        contactAlertView.contact = contactCell.contact;
        
        [contactAlertView alertShow];
        
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 25;
    }
    
    return 25;//section头部高度
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *arr = (NSMutableArray *)self.tableView.subviews;
    [arr removeObjectsInArray:self.titleSettingArray];
    for (UIView *view in arr) {
        if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            UITableViewHeaderFooterView *footView = (UITableViewHeaderFooterView*)view;
            
            footView.tintColor = TJColorGrayBg;
            footView.textLabel.font = TJFontWithSize(14);
            footView.textLabel.textColor = TJColorGrayFontLight;
            
            [self.titleSettingArray addObject:footView];
        }
    }
    
    return [self.sectionTitlesArray objectAtIndex:section];
}

/**
 *  首字母导航条
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;

}

#pragma mark - TJContactAlertView Delegate
- (void)contactAlertView:(TJContactAlertView *)contactAlertView talkViewClick:(UIButton *)sender{
    [contactAlertView dismissAlert];
}

- (void)contactAlertView:(TJContactAlertView *)contactAlertView sendViewClick:(UIButton *)sender{
    [contactAlertView dismissAlert];
    TJHomeTVController *home = self.tabBarController.childViewControllers[0].childViewControllers[0];
    [self.navigationController popViewControllerAnimated:NO];
    
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:[TJTabBar class]]) {
            TJTabBar *tabbar = (TJTabBar*)view;
            [tabbar btnClick:tabbar.buttons[0]];
            break;
        }
    }
    
    NIMSession *session = [NIMSession session:contactAlertView.contact.userId type:NIMSessionTypeP2P];

    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = @"0";
    talk.contact = contactAlertView.contact;
    talk.session = session;
    talk.toUserName = contactAlertView.contact.remark;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];

    privateChat.hidesBottomBarWhenPushed = YES;
    [home.navigationController pushViewController:privateChat animated:NO];
}
- (void)contactAlertView:(TJContactAlertView *)contactAlertView personalViewClick:(UIButton *)sender{
    [contactAlertView dismissAlert];
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":contactAlertView.contact.userId}
            success:^(id responseObject) {
                
               
                TJUserInfo *friendInfo = [TJUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
                friendInfo.userId = contactAlertView.contact.userId;
                
                TJFriendProfileVC *friendProfileVC = [[TJFriendProfileVC alloc] initWithUserInfo:friendInfo];
                friendProfileVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:friendProfileVC animated:YES];
            } failure:^(NSError *error) {}];
}

- (void)contactAlertView:(TJContactAlertView *)contactAlertView videoViewClick:(UIButton *)sender{
    [contactAlertView dismissAlert];
    
    [self pickVideoFromCamera];
    _currentContact = contactAlertView.contact;
}

- (void)pickVideoFromCamera
{
    //获取 storyboard
    TJCameraController *captureVC = [TJCameraController cameraViewController];
    captureVC.isOnlyForVideo = YES;
    
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             //传出的是URL则是视频
             if ([result isKindOfClass:[NSURL class]]) {
                 NSURL *fileURL = result;
                 
                 _currentVideoPath = fileURL.path;
                 
                 [self performSelector:@selector(showS) withObject:self afterDelay:0.2];
                 
             }
         }
         else
         {
             NSLog(@"Video Picker Failed: %@", result);
         }
         //
     }];
    
    [self presentViewController:captureVC animated:YES completion:^{
        NSLog(@"PickVideo present");
    }];
}

- (void)showS{
    
    SimpleVideoFileFilterViewController *newFilter=[SimpleVideoFileFilterViewController new];
    newFilter.inputFilePath=_currentVideoPath;
    
    newFilter.outputFilePath=[self getTmpPath];
    newFilter.vcdelegate=self;
    
    [self presentViewController:newFilter animated:YES completion:nil];
    
}

- (NSString *)getTmpPath
{
    
    NSError *err = nil;
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"] error:&err];
        
    }
    
    return  [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"];
    
}

- (void)videoHandleSuccess:(BOOL)isSuccess resultPath:(NSString *)path
{
    NIMSession *session = [NIMSession session:_currentContact.userId type:NIMSessionTypeP2P];
    if (isSuccess) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:path];
        videoObject.displayName = [NSString stringWithFormat:@"视频发送于%@",dateString];
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject = videoObject;
        message.apnsContent = @"发来了一段视频";
        
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        _currentContact = nil;
        [TJRemindTool showMessage:@"发送成功."];
    }
}


- (void)contactAlertView:(TJContactAlertView *)contactAlertView settingViewClick:(UIButton *)sender{
    [contactAlertView dismissAlert];
    
    TJContactSettingTVC *contactSetting = [TJContactSettingTVC contactSettingTVC];
    contactSetting.currentContact = contactAlertView.contact;
    
    contactSetting.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:contactSetting animated:YES];
}


#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    TJNotificationModel *notificationModel = [TJNotificationModel mj_objectWithKeyValues:notification.content];
    
    if ([notificationModel.code isEqualToString:@"1000"]) {
        
        TJNewContactRequest *newContactRequest = [TJNewContactRequest mj_objectWithKeyValues:notification.content];
        
        [TJDataCenter addSingleObject:newContactRequest];
        
        [self refreshSessionBadge];
    }
}
@end
