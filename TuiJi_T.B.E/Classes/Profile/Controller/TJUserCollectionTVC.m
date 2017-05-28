//
//  TJUserCollectionTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserCollectionTVC.h"

#import "TJURLList.h"
#import "TJAccount.h"

#import "TJUserCollectionModel.h"
#import "TJUserCollectionCell.h"

#import "BLImageSize.h"

#import "GWYAlertSelectView.h"

#import "TJSingleListSelector.h"

#import "CKAlertViewController.h"

#import "TJHomeTVController.h"
#import "TJTabBar.h"
#import "TJContact.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"

#import "TJExtensionMessage.h"

@interface TJUserCollectionTVC ()<TJUserCollectionCellDelegate,TJSingleListSelectorDelegate>

@property (nonatomic, strong) NSMutableArray *userCollectionList;
@property (nonatomic, strong) GWYAlertSelectView * alertView;
@end

@implementation TJUserCollectionTVC
{
    TJUserCollectionModel *_currentCollectionModel;
}
/**
 *  懒加载
 */
- (NSMutableArray *)userCollectionList{
    if (!_userCollectionList) {
        _userCollectionList = [NSMutableArray array];
    }
    return _userCollectionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.view.backgroundColor = TJColorGrayBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpNavigationBar];
    
    [self loadUserCollectionList];
}


#pragma mark - private method
- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"收藏"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
}

- (void)loadUserCollectionList
{
    NSString *URLStr = [TJUrlList.loadUserCollectionList stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"userID":TJAccountCurrent.userId}
            success:^(id responseObject) {
                
                NSMutableArray *collectionList = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    TJUserCollectionModel *model = [[TJUserCollectionModel alloc] init];
                    model.collectionId = dic[@"date"];
                    NSString *str = dic[@"data"];
                    NSDictionary *data = str.mj_JSONObject;
                    
                    if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"0"]) {
                        model.imgsUrl = [data[@"imgsUrl"] firstObject];
                        model.tContent = data[@"tContent"];
                        model.tId = data[@"tId"];
                        model.squareId = data[@"worldHide"];
                        model.squareType = @"0";
                        model.username = @"点击查看";
                    
                    }else if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"1"]){
                        
                        model.imgsUrl = [data[@"pictureList"] firstObject][@"pictureurl"];
                        model.tContent = data[@"squareTweet"][@"content"];
                        model.tId = data[@"squareTweet"][@"id"];
                        model.squareId = model.tId;
                        model.username = data[@"squareTweet"][@"username"];
                        model.userIcon = data[@"squareTweet"][@"userpicture"];
                        model.squareType = @"0";
                        
                        
                        
                        
                    }else if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"2"]){
                        model.imgsUrl = data[@"photourl"];
                        model.tContent = data[@"context"];
                        model.tId = data[@"igIdStr"];
                        model.squareId = data[@"id"];
                        model.username = data[@"username"];
                        model.userIcon = data[@"picture"];
                        model.squareType = @"1";
                    }
                    [collectionList addObject:model];
                }
                
                [self.userCollectionList addObjectsFromArray:collectionList];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {}];
}

#pragma mark - tableView Controller
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.userCollectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJUserCollectionModel *model = self.userCollectionList[indexPath.row];
    TJUserCollectionCell *cell = [TJUserCollectionCell cellWithTableView:tableView];
    
//    TJUserCollectionCell *cell = [[TJUserCollectionCell alloc] init];
    
    cell.userCollectionModel = model;
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJUserCollectionModel *userCollectionModel = self.userCollectionList[indexPath.row];
    
    CGFloat baseH = 39;
    
    CGSize strSize = [userCollectionModel.tContent sizeWithFont:TJFontWithSize(14) maxSize:CGSizeMake(TJWidthDevice - 55, MAXFLOAT)];
    
    //不超出两行的高度
    CGFloat textH = (strSize.height > 39) ? 39 : strSize.height;
    baseH += textH;
    
    if (!TJStringIsNull(userCollectionModel.imgsUrl)) {
        baseH += (TJWidthDevice - 6);
    }
    return baseH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectPersonalContact:nil];
    
}

- (void)userCollectionCell:(TJUserCollectionCell *)userCollectionCell moreViewClick:(UIButton *)sender{

    _currentCollectionModel = userCollectionCell.userCollectionModel;
    
    [self selectPersonalContact:nil];
    
}



- (void)selectPersonalContact:(UIButton *)button {
    
    self.alertView = [[GWYAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, TJWidthDevice, TJHeightDevice)];
    self.alertView.addAlertViewType = GWYAlertSelectViewTypeGetAddress;
    //block 选择的回调数据
    [self.alertView alertViewSelectedBlock:^(NSMutableArray *alertViewData) {
        
        if ([[alertViewData firstObject] isKindOfClass:[NSString class]]) {
            
            if ([[alertViewData firstObject] isEqualToString:@"选择用户"]) {
                TJSingleListSelector *singleSelector = [[TJSingleListSelector alloc] initWithDataList:[TJContactTool contactList]];
                singleSelector.hidesBottomBarWhenPushed = YES;
                singleSelector.delegate = self;
                [(TJNavigationController *)self.navigationController pushToLightViewController:singleSelector animated:YES];
            }else if ([[alertViewData firstObject] isEqualToString:@"转发到推己圈"]){
                
                
                
                
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"是否确认转发?" message:@""];
                
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
                
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    //                    NSString *URLStr = [TJUrlList.transmitToTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
                    //                    [TJHttpTool GET:URLStr
                    //                         parameters:@{@"type":@1, @"hostUid":TJAccountCurrent.userId, @"tId":@"330", @"passiveUid":_currentClickTimeLine.userId}
                    //                            success:^(id responseObject) {
                    //
                    //                                NSLog(@"%@",responseObject);
                    //
                    //
                    //                            } failure:^(NSError *error) {
                    //                                NSLog(@"%@",error);
                    //
                    //                            }];
                }];
                
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
            }
            
        }else{
            [self transmitTimeLineFinishSelect:[alertViewData firstObject]];
            
        }
        
    }];
    [self.alertView alertSelectViewshow];
}

- (void)singleListSelector:(UITableViewController *)singleListSelector didFinishSelect:(id)data{
    TJContact *contact = (TJContact *)data;
    [self transmitTimeLineFinishSelect:contact];
}

- (void)transmitTimeLineFinishSelect:(TJContact *)contact
{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"是否确认转发?" message:@""];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        
        NIMSession *session = [NIMSession session:contact.userId type:NIMSessionTypeP2P];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[KEY_USER_ID] = _currentCollectionModel.squareId;
        dic[KEY_HEAD_URL] = _currentCollectionModel.userIcon;
        dic[KEY_NICKNAME] = _currentCollectionModel.username;
        dic[KEY_PHOTO] = _currentCollectionModel.imgsUrl;
        dic[KEY_TEXT] = _currentCollectionModel.tContent;
        dic[KEY_TYPE] = _currentCollectionModel.squareType;
        
        _currentCollectionModel = nil;
        
        TJExtensionMessage *attachment = [[TJExtensionMessage alloc] init];
        attachment.value = dic;
        attachment.type = TJExtensionMessageValueTweet;
        
        NIMMessage *message               = [[NIMMessage alloc] init];
        NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
        customObject.attachment           = attachment;
        message.messageObject             = customObject;
        message.apnsContent = @"[推文]";
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
        
        [TJRemindTool showSuccess:@"转发成功."];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}


@end
