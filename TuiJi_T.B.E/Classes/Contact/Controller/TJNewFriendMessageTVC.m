//
//  TJNewFriendMessageTVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewContactRequest.h"
#import "TJNewFriendMessageTVC.h"
#import "TJSearchController.h"
#import "TJContactSearchResultController.h"
#import "TJNewContactCell.h"

#import "TJFriendCardVC.h"
#import "TJPersonalCardViewController.h"
#import "TJNewUserInfoCard.h"

#import "TJURLList.h"
#import "TJAccount.h"
#import "TJReciveNewFriendRequestParam.h"
#import "TJStatusParams.h"

#import "NIMMessageMaker.h"

@interface TJNewFriendMessageTVC ()<UISearchBarDelegate, TJNewContactCellDelegate>

@property (nonatomic, strong) TJSearchController *searchController;
@property (nonatomic, strong) NSMutableArray *addNewContactsList;

@end

@implementation TJNewFriendMessageTVC

#pragma mark - private method

- (NSMutableArray *)addNewContactsList{
    if (!_addNewContactsList) {
        _addNewContactsList = [TJNewContactRequestTool NewContactRequestListSuccess:^{} failure:^(NSError *error) {}];
    }
    return _addNewContactsList;
}

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
        //取消分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.view.backgroundColor = TJColorGrayBg;
        self.tableView.backgroundColor = TJColorGrayBg;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllSubViews];
    
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"新的好友"
                                                   textColor:TJColorAutoTitle 
                                                 sysFontSize:19];
    self.navigationItem.titleView = titleView;

    
    
}

#pragma mark - private method
- (void)setUpAllSubViews
{
    TJContactSearchResultController *searchResultController = [[TJContactSearchResultController alloc] init];
    self.searchController = [[TJSearchController alloc] initWithSearchResultsController:searchResultController];
    self.searchController.view.backgroundColor = [TJColorWhite colorWithAlphaComponent:0.9];
    
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

#pragma mark - tableView delegate
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

/**
 *  返回多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 * 每一组各多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
    if (self.addNewContactsList.count == 0) {
        [TJRemindTool showError:@"空空如也."];
    }
        return self.addNewContactsList.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    TJNewContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!contactCell) {
        contactCell = [[TJNewContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
//    if (indexPath.section == 0) {
//        [contactCell.titleView setText:@"添加手机好友"];
//        [contactCell.iconView setImage:[UIImage imageNamed:@"contact_phone"]];
//        contactCell.cellType = TJNewFriendCellTypeNULL;
//        
//        contactCell.nameView.hidden = YES;
//        contactCell.rightView.hidden = YES;
//        contactCell.detailView.hidden = YES;
//        contactCell.titleView.hidden = NO;
//        
//        
//        
//        
//        
//    }else{
        TJNewContactRequest *model = self.addNewContactsList[indexPath.row];
        contactCell.addNewContact = model;
//    }
    contactCell.delegate = self;
    return contactCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJNewContactRequest *model = self.addNewContactsList[indexPath.row];
    
    if ([model.deputyuserid isConnectWithMe]) {
        
        TJFriendCardVC *friendCard = [[TJFriendCardVC alloc] init];
        
        TJContact *contact = [TJContact contactWithUserId:model.deputyuserid];
        friendCard.contact = contact;
        
        friendCard.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendCard animated:YES];
        
        
    }else{
        
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:model.deputyuserid];
        
        TJPersonalCardViewController *personalCardVC = [[TJPersonalCardViewController alloc] init];
        
        TJNewUserInfoCard *newUserInfo = [[TJNewUserInfoCard alloc] init];
        
        
        newUserInfo.userId = user.userId;
        
        //        newUserInfo.username = ;
        
        newUserInfo.nickName = user.userInfo.nickName;
        
        newUserInfo.picture = user.userInfo.avatarUrl;
        
        //        newUserInfo.signature = ;
        
        //        newUserInfo.country = user.userInfo.;
        
        personalCardVC.userInfo = newUserInfo;
        
        [self.navigationController pushViewController:personalCardVC animated:YES];
    }

}

- (void)tableViewCell:(TJNewContactCell *)tableViewCell agreeViewClick:(UIButton *)sender{
    NSString *URLStr = [TJUrlList.reciveNewContactRequest stringByAppendingString:TJAccountCurrent.jsessionid];
    TJReciveNewFriendRequestParam *receiveParam = [[TJReciveNewFriendRequestParam alloc] init];
    receiveParam.userID = TJAccountCurrent.userId;
    receiveParam.friendID = tableViewCell.addNewContact.deputyuserid;
    receiveParam.state = @"1";
    
    [TJHttpTool GET:URLStr
         parameters:receiveParam.mj_keyValues
            success:^(id responseObject) {
                TJStatusParams *params = [TJStatusParams mj_objectWithKeyValues:[responseObject firstObject]];
                if ([params.code isEqualToString:TJStatusSussess]) {
                    [TJRemindTool showSuccess:@"添加成功."];
                    tableViewCell.cellType = TJNewFriendCellTypeDidAdd;
                    
                    [[RLMRealm defaultRealm] beginWriteTransaction];
                    tableViewCell.addNewContact.addNewFriendCellType = TJNewFriendCellTypeDidAdd;
                    [[RLMRealm defaultRealm] commitWriteTransaction];
                    
                    NIMSession *session = [NIMSession session:tableViewCell.addNewContact.deputyuserid type:NIMSessionTypeP2P];
                    //模拟一条添加消息
                    NIMMessage *message = [NIMMessageMaker msgWithText:@"对方已经将您添加为好友."];
                    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
                }
            } failure:^(NSError *error) {}];
}
@end
