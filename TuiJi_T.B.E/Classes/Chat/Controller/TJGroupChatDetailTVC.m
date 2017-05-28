//
//  TJGroupChatDetailTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGroupChatDetailTVC.h"

#import "TJGroupContactMenber.h"

#import "TJGroupMemberPreCollCell.h"

#import "TJGroupCMemberListTVC.h"

#import "TJSettingTeamNameTVC.h"
#import "TJSettingTeamNicknameTVC.h"
#import "TJTeamCardVC.h"

#import "TJHomeTVController.h"
#import "TJAccount.h"

#import "TJListSelector.h"

#import "TJFriendCardVC.h"

#import "TJPersonalCardViewController.h"

#import "TJNewUserInfoCard.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "TJSimpleImageFilterViewController.h"

#import "CKAlertViewController.h"

#define TJItemMargin 37
#define TJItemW (TJWidthDevice-3*TJItemMargin -28)/4

@interface TJGroupChatDetailTVC ()<UICollectionViewDelegate, UICollectionViewDataSource, TJListSelectorDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TJSimpleImageFilterDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *teamUserCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameView;
@property (weak, nonatomic) IBOutlet UILabel *myNickNameView;
@property (weak, nonatomic) IBOutlet UISwitch *messageNotiView;
- (IBAction)messagenotiClick:(UISwitch *)sender;

@property(nonatomic,strong) NIMTeamMember *myTeamInfo;

@property (nonatomic, strong) NSMutableArray *previewContactList;

@property (nonatomic, weak) UIButton *deleteFriendView;
@end

@implementation TJGroupChatDetailTVC

- (IBAction)messagenotiClick:(UISwitch *)sender {
    
    BOOL flag = !sender.isOn;

    [[NIMSDK sharedSDK].teamManager updateNotifyState:flag inTeam:_team.teamId completion:^(NSError * _Nullable error) {
        if (error) {
            sender.on = !sender.on;
        }else{
        }
    }];
}

/**
 *  懒加载
 */
- (NIMTeamMember *)myTeamInfo{
    return [[NIMSDK sharedSDK].teamManager teamMember:TJAccountCurrent.userId inTeam:_team.teamId];
}

- (NSMutableArray *)previewContactList{
    NSMutableArray *previewContactList = [NSMutableArray array];

    NSInteger count = 7;
    
    if ([_team.owner isEqualToString:TJAccountCurrent.userId]) {
        count--;
    }
    
    if (_groupContactMemberList.count >= count) {
        [previewContactList addObjectsFromArray:[_groupContactMemberList subarrayWithRange:NSMakeRange(0, count)]];
    }else{
        [previewContactList addObjectsFromArray:_groupContactMemberList];
    }

    TJGroupContactMenber *member1 = [TJGroupContactMenber new];
    member1.headImage = @"chat_groupMemberAdd";
    member1.nickname = TJSpecialMark;
    [previewContactList addObject:member1];
    
    TJGroupContactMenber *member2 = [TJGroupContactMenber new];
    member2.headImage = @"chat_groupMemberSub";
    member2.nickname = TJSpecialMark;
    
    if (count == 6) {
        [previewContactList addObject:member2];
    }
    
    return previewContactList;
}

/**
 *  将状态栏字体颜色变为黑色
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_groupNameView setText:_team.teamName];
    [_myNickNameView setText:self.myTeamInfo.nickname];
    [self.messageNotiView setOn:!_team.notifyForNewMsg];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.teamUserCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TJGroupMemberPreCollCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([TJGroupMemberPreCollCell class])];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    flowLayout.itemSize = CGSizeMake(TJItemW, TJItemW+20);
    flowLayout.minimumInteritemSpacing =TJItemMargin ;
    flowLayout.minimumLineSpacing = 18;
    
    self.teamUserCollectionView.collectionViewLayout = flowLayout;
    
    [self setUpNavigationBar];
    
    //设置删除按钮
    [self setUpDeleteBtn];
}

- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"群聊信息"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
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
    
    UIButton *deleteFriendBtn = [TJUICreator createButtonWithTitle:@"删除并退出"
                                                              size:CGSizeMake(TJWidthDevice - 38, 60 - 12)
                                                        titleColor:TJColorWhite
                                                              font:TJFontWithSize(18)
                                                            target:self
                                                            action:@selector(deleteFriendViewClick:)];
    [deleteFriendBtn setBackgroundColor:TJColorDeleteView];
    deleteFriendBtn.layer.cornerRadius = 24;
    deleteFriendBtn.layer.masksToBounds = YES;
    
    _deleteFriendView = deleteFriendBtn;
    [TJAutoLayoutor layView:_deleteFriendView atTheView:footerView margins:UIEdgeInsetsMake(6, 19, 6, 19)];
    self.tableView.tableFooterView = footerView;
    
}

- (void)deleteFriendViewClick:(UIButton *)sender
{

    
    //判断是否群主
    if ([_team.owner isEqualToString:TJAccountCurrent.userId]) {
        //是群主
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"是否确定解散群聊?"];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            
            [[NIMSDK sharedSDK].teamManager dismissTeam:_team.teamId
        completion:^(NSError * _Nullable error) {
            if (!error) {
                //清除聊天记录
                NIMSession *session = [NIMSession session:_team.teamId type:NIMSessionTypeTeam];
                
                [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session removeRecentSession:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [TJRemindTool showSuccess:@"解散成功."];
            }else{
                [TJRemindTool showError:@"解散失败."];
            }
        }];
            
        }];
        
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];
        
    }else{
        //用户退群
        [[NIMSDK sharedSDK].teamManager quitTeam:_team.teamId completion:^(NSError * _Nullable error) {
            if (!error) {
                
                //清除聊天记录
                NIMSession *session = [NIMSession session:_team.teamId type:NIMSessionTypeTeam];
                
                [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session removeRecentSession:YES];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [TJRemindTool showSuccess:@"退出成功."];
            }else{
                NSLog(@"%@",error);
            }
        }];
        
        
    }


}

#pragma mark - public method
+ (instancetype)groupChatDetailTVC
{
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJChat" bundle:nil];
    //获取初始化箭头所指controller
    TJGroupChatDetailTVC *groupChatDetailTVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJGroupChatDetailTVC class])];
    
    return groupChatDetailTVC;
}

#pragma mark - tableView Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSInteger count = 3;
        
        if ([_team.owner isEqualToString:TJAccountCurrent.userId]) {
            count--;
        }
        
        if (_groupContactMemberList.count > count) {
            return (((TJItemW + 20) * 2) + 64);
        }else{
            return ((TJItemW + 20) + 46);
        }
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        TJGroupCMemberListTVC *listTVC = [[TJGroupCMemberListTVC alloc] init];
        listTVC.currentTeam = _team;
        listTVC.groupMemberList = _groupContactMemberList;
        
        [self.navigationController pushViewController:listTVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            //设置群聊名称
            TJSettingTeamNameTVC *settingTeamNameTVC = [[TJSettingTeamNameTVC alloc] init];
            settingTeamNameTVC.team = _team;
            
            [self.navigationController pushViewController:settingTeamNameTVC animated:YES];
        }else if (indexPath.row == 1){
            //从相册中选择头像
            [self pickPictureFromPhotoLibrary];
            
            
        }else if (indexPath.row == 2){
            //群二维码
            TJTeamCardVC *teamCardVC = [TJTeamCardVC teamCardVC];
            teamCardVC.team = _team;
            
            [self.navigationController pushViewController:teamCardVC animated:YES];
        }else if (indexPath.row == 3){
            //群昵称
            TJSettingTeamNicknameTVC *settingTeamNicknameTVC = [[TJSettingTeamNicknameTVC alloc] init];
            settingTeamNicknameTVC.team = _team;
            settingTeamNicknameTVC.myTeamInfo = self.myTeamInfo;
            
            [self.navigationController pushViewController:settingTeamNicknameTVC animated:YES];
        }
        
    }else if (indexPath.section == 4){
        
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"是否确定清除聊天记录?"];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            NIMSession *session = [NIMSession session:_team.teamId type:NIMSessionTypeTeam];
            
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session removeRecentSession:NO];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [TJRemindTool showSuccess:@"删除成功."];
            
        }];
        
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];
        
    }
}

- (void)pickPictureFromPhotoLibrary
{
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        TJSimpleImageFilterViewController *imageFilterVC = [[TJSimpleImageFilterViewController alloc] initWithImage:portraitImg
                                                                                                          cropFrame:CGRectMake(0, 44.0, TJWidthDevice, TJWidthDevice) limitScaleRatio:3.0];
        
        imageFilterVC.delegate = self;
        
        [self presentViewController:imageFilterVC animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        
        
    }];
}
#pragma mark - TJSimpleImageFilter Delegate
- (void)imageCropper:(TJSimpleImageFilterViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [cropperViewController dismissViewControllerAnimated:YES
                                              completion:^{
                                                  
                                                 //上传头像
                                                  [TJHttpTool upLoadData:UIImagePNGRepresentation(editedImage)
                                                                 success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                                                     
//
                                                                     //上传成功后修改群头像
                                                                     [[NIMSDK sharedSDK].teamManager updateTeamAvatar:[@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]]
                                                                                                               teamId:_team.teamId
                                                                                                           completion:^(NSError * _Nullable error) {
                                                                                                               [self.navigationController popViewControllerAnimated:YES];
                                                                                                               [TJRemindTool showSuccess:@"修改成功."];
                                                                                                           }];
                                                                     
                                                                 }];
                                                  
                                                  
                                                  
                                                  
                                              }];
}

- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - collectionView Delegate DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.previewContactList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TJGroupContactMenber *member = self.previewContactList[indexPath.row];
    
    TJGroupMemberPreCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJGroupMemberPreCollCell class]) forIndexPath:indexPath];

    cell.groupContactMenber = member;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TJGroupContactMenber *member= self.previewContactList[indexPath.row];
    //如果点了添加按钮
    if ([member.headImage isEqualToString:@"chat_groupMemberAdd"]) {
        
        TJListSelector *ListSelector = [[TJListSelector alloc] initWithDataList:[TJContactTool contactList]];
        ListSelector.selectType = @"chat_groupMemberAdd";
        ListSelector.delegate = self;
        
        [self.navigationController pushViewController:ListSelector animated:YES];
    }else if ([member.headImage isEqualToString:@"chat_groupMemberSub"]){
        TJListSelector *ListSelector = [[TJListSelector alloc] initWithDataList:_groupContactMemberList];
        ListSelector.delegate = self;
        
        [self.navigationController pushViewController:ListSelector animated:YES];
        
    }else{
        
        if ([member.userId isConnectWithMe]) {
            
            TJFriendCardVC *friendCard = [[TJFriendCardVC alloc] init];
            
            TJContact *contact = [TJContact contactWithUserId:member.userId];
            friendCard.contact = contact;
            
            friendCard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friendCard animated:YES];
            
            
        }else{
            
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
            
            TJPersonalCardViewController *personalCardVC = [[TJPersonalCardViewController alloc] init];
            
            TJNewUserInfoCard *newUserInfo = [[TJNewUserInfoCard alloc] init];
            
            
            newUserInfo.userId = user.userId;
            
            //        newUserInfo.username = ;
            
            newUserInfo.nickName = user.userInfo.nickName;
            
            newUserInfo.picture = user.userInfo.avatarUrl;
            
            //        newUserInfo.signature = ;
            
//                    newUserInfo.country = user.userInfo.;
            
            personalCardVC.userInfo = newUserInfo;
            
            [self.navigationController pushViewController:personalCardVC animated:YES];
        }
        
    }
 
}

- (void)listSelector:(TJListSelector *)listSelector didFinishSelect:(NSMutableArray *)selectedSesult{
    
    if ([listSelector.selectType isEqualToString:@"chat_groupMemberAdd"]) {
        [[NIMSDK sharedSDK].teamManager addUsers:selectedSesult toTeam:_team.teamId postscript:@"" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            [self.teamUserCollectionView reloadData];
            [TJRemindTool showSuccess:@"添加成功"];
        }];
    }else{
        
        [[NIMSDK sharedSDK].teamManager kickUsers:selectedSesult fromTeam:_team.teamId completion:^(NSError * _Nullable error) {
            [self.teamUserCollectionView reloadData];
            [TJRemindTool showSuccess:@"移除成功"];
        }];
    }
    
}

@end
