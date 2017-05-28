//
//  TJChatDetailTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJChatDetailTVC.h"

#import "TJContact.h"

#import "TJURLList.h"
#import "TJAccount.h"

#import "TJSingleListSelector.h"
#import "CKAlertViewController.h"
#import "TJExtensionMessage.h"

#import "TJUserFeedBackVC.h"

@interface TJChatDetailTVC ()<TJSingleListSelectorDelegate>

@property (nonatomic, weak) UIButton *deleteFriendView;
@property (weak, nonatomic) IBOutlet UITextField *remarkView;

@property (weak, nonatomic) IBOutlet UISwitch *messageNotiView;
- (IBAction)messageNotiViewChange:(UISwitch *)sender;

@end

@implementation TJChatDetailTVC

#pragma mark - system method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavigationBar];
    
    //设置删除按钮
    [self setUpDeleteBtn];
    
    //设置界面颜色
    [self setUpColor];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.remarkView setText:_currentContact.remark];
    [self.messageNotiView setOn:!_currentContact.notifyForNewMsg];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self backBtnClick];
}

#pragma mark - public method
+ (instancetype)chatDetailTVC
{
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJChat" bundle:nil];
    //获取初始化箭头所指controller
    TJChatDetailTVC *chatDetailTVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJChatDetailTVC class])];

    return chatDetailTVC;
}


#pragma mark - private method
- (void)setUpNavigationBar
{
    
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"聊天详细"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
}

- (void)backBtnClick
{
//    //判断昵称是否更改
//    if (![_remarkView.text isEqualToString:_currentContact.remark]) {
//        //修改资料
//        NSString *URLStr = [TJUrlList.setFriendRemark stringByAppendingString:TJAccountCurrent.jsessionid];
//       
//        [TJHttpTool POST:URLStr
//              parameters:@{@"userID":TJAccountCurrent.userId, @"friendID":_currentContact.userId, @"remark":_remarkView.text}
//                 success:^(id responseObject) {} failure:^(NSError *error) {}];
//    }
}

/**
 *  设置底部删除按钮
 */
- (void)setUpDeleteBtn
{
    UIView *footerView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 60)
                                                 bgColor:TJColorGrayBg
                                                  radius:0];
    
    UIButton *deleteFriendBtn = [TJUICreator createButtonWithTitle:@"删除"
                                                              size:CGSizeMake(TJWidthDevice - 38, 60 - 12)
                                                        titleColor:TJColorWhiteFont
                                                              font:TJFontWithSize(18)
                                                            target:self
                                                            action:@selector(deleteFriendViewClick:)];
    [deleteFriendBtn setBackgroundImage:[UIImage imageWithTJColor:TJColorDeleteView] forState:UIControlStateNormal];
    [deleteFriendBtn setBackgroundImage:[UIImage imageWithTJColor:TJColorDeleteView_H] forState:UIControlStateHighlighted];
    deleteFriendBtn.layer.cornerRadius = 24;
    deleteFriendBtn.layer.masksToBounds = YES;
    
    _deleteFriendView = deleteFriendBtn;
    [TJAutoLayoutor layView:_deleteFriendView atTheView:footerView margins:UIEdgeInsetsMake(6, 19, 6, 19)];
    self.tableView.tableFooterView = footerView;
    
}

- (void)deleteFriendViewClick:(UIButton *)sender
{
    [TJContactTool deleteContac:_currentContact.userId
                        Success:^{
                            
                            NIMSession *session = [NIMSession session:_currentContact.userId type:NIMSessionTypeP2P];
                            
                            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session removeRecentSession:YES];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [TJRemindTool showSuccess:@"删除成功."];
                            
                        } failure:^(NSError *error) {
                            [TJRemindTool showError:@"删除失败,请稍后再试."];
                        }];
}

/**
 *  设置颜色
 */
- (void)setUpColor
{
    //tableView color
    self.tableView.backgroundColor = TJColorGrayBg;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        TJSingleListSelector *singleListSelector = [[TJSingleListSelector alloc] initWithDataList:[TJContactTool contactList]];
        singleListSelector.delegate = self;
        
        [self.navigationController pushViewController:singleListSelector animated:YES];
    }else if (indexPath.section == 5){
        
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"是否确定清除聊天记录?"];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            NIMSession *session = [NIMSession session:_currentContact.userId type:NIMSessionTypeP2P];
            
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session removeRecentSession:NO];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [TJRemindTool showSuccess:@"删除成功."];
            
        }];
        
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];

    }else if (indexPath.section == 6){
        TJUserFeedBackVC *userFeedBackVC = [TJUserFeedBackVC userFeedBackWithContact:_currentContact];
        
        [self.navigationController pushViewController:userFeedBackVC animated:YES];
        
    }
}

- (void)singleListSelector:(UITableViewController *)singleListSelector didFinishSelect:(id)data{
    TJContact *contact = (TJContact *)data;
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"将 %@ 的名片发送给对方?",_currentContact.nickname]];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NIMSession *session = [NIMSession session:contact.userId type:NIMSessionTypeP2P];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[CARD_HEAD_URL] = _currentContact.headImage;
        dic[CARD_USER_ID] = _currentContact.userId;
        dic[CARD_TUIJI] = _currentContact.username;
        dic[CARD_NICK_NAME] = _currentContact.nickname;
        
        TJExtensionMessage *attachment = [[TJExtensionMessage alloc] init];
        attachment.value = dic;
        attachment.type = TJExtensionMessageValueCard;
        
        NIMMessage *message               = [[NIMMessage alloc] init];
        NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
        customObject.attachment           = attachment;
        message.messageObject             = customObject;
        message.apnsContent = @"[名片]";
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        
        [TJRemindTool showSuccess:@"发送成功."];
    }];
    
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];

    
    
}

- (IBAction)messageNotiViewChange:(UISwitch *)sender {

    BOOL flag = !sender.isOn;
    
    [[NIMSDK sharedSDK].userManager updateNotifyState:flag forUser:_currentContact.userId completion:^(NSError * _Nullable error) {
        if (error) {
            sender.on = !sender.on;
        }else{
        }
    }];
    
}
@end
