//
//  TJContactSettingTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactSettingTVC.h"
#import "TJContact.h"

#import "TJSingleListSelector.h"
#import "CKAlertViewController.h"

#import "TJExtensionMessage.h"

#import "TJURLList.h"
#import "TJAccount.h"

@interface TJContactSettingTVC ()<TJSingleListSelectorDelegate>

@property (nonatomic, weak) UIButton *deleteFriendView;
@property (weak, nonatomic) IBOutlet UITextField *remarkView;

@end

@implementation TJContactSettingTVC

+ (instancetype)contactSettingTVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJContactDetail" bundle:nil];
    TJContactSettingTVC *contactSetting = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJContactSettingTVC class])];
    
    return contactSetting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    
    [self setUpNavigationBar];
    [self setUpDeleteBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.remarkView setText:_currentContact.remark];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //判断昵称是否更改
    if (![_remarkView.text isEqualToString:_currentContact.remark]) {
        NSString *remarks = _remarkView.text;
        if (TJStringIsNull(remarks)) {
            remarks = _currentContact.nickname;
        }
        
        //修改资料
        NSString *URLStr = [TJUrlList.setFriendRemark stringByAppendingString:TJAccountCurrent.jsessionid];
        
        [TJHttpTool POST:URLStr
              parameters:@{@"userID":TJAccountCurrent.userId, @"friendID":_currentContact.userId, @"remark":remarks}
                 success:^(id responseObject) {} failure:^(NSError *error) {}];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        TJSingleListSelector *singleListSelector = [[TJSingleListSelector alloc] initWithDataList:[TJContactTool contactList]];
        singleListSelector.delegate = self;
        
        [self.navigationController pushViewController:singleListSelector animated:YES];
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
@end
