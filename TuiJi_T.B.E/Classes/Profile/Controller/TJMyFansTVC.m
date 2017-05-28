//
//  TJMyFansTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyFansTVC.h"

#import "TJURLList.h"
#import "TJAccount.h"

#import "TJMyFans.h"
#import "TJMyFansCell.h"
#import "CKAlertViewController.h"
#import "TJAttention.h"

#import "TJUserInfo.h"
#import "TJFriendProfileVC.h"

@interface TJMyFansTVC ()<TJMyFansDelegate>

@property (nonatomic, strong) NSMutableArray *myFansList;

@end

@implementation TJMyFansTVC

/**
 *  懒加载
 */
- (NSMutableArray *)myFansList
{
    if (!_myFansList) {
        _myFansList = [NSMutableArray array];
    }
    return _myFansList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMyFans];
    
    [self setUpNavigationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TJColorGrayBg;
}

- (void)loadMyFans
{
    NSString *URLStr = [TJUrlList.loadAllMyFans stringByAppendingString:TJAccountCurrent.jsessionid];
    
    [TJHttpTool GET:URLStr
         parameters:@{@"attentionID":TJAccountCurrent.userId}
            success:^(id responseObject) {
                
                NSArray *fansList = [TJMyFans mj_objectArrayWithKeyValuesArray:[responseObject firstObject][@"list"]];
                [self.myFansList addObjectsFromArray:fansList];
                
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
    
    
}

- (void)setUpNavigationBar
{
    
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"关注者"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
}

#pragma mark - TJMyFansDelegate
- (void)myFansCell:(TJMyFansCell *)myFansCell didClickAttentionView:(UIButton *)attentionView{
    TJMyFans *myFans = myFansCell.myFans;
    
    if (attentionView.isSelected) {
        //提示用户是否要删除
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"确定取消关注?"];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            
            [TJAttentionTool unPayAttntionToSB:myFans.fanid
                                         where:0
                                       Success:^{
                                           
                                           //如果取消关注成功 手动删除
                                           [TJDataCenter deleteAObjectWithClassName:NSStringFromClass([TJAttention class]) conditions:[NSString stringWithFormat:@"attentionid = '%@'",myFans.fanid]];
                                           attentionView.selected = NO;
                                           [TJRemindTool showSuccess:@"操作成功."];
                                           
                                       } failure:^(NSError *error) {}];
        }];
        
        
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];
        
    }else{
        //关注该用户
        [TJAttentionTool payAttntionToSB:myFans.fanid
                                   where:0
                                 Success:^{
                                     //如果关注成功 手动插入数据库
                                     TJAttention *currentAttention = [[TJAttention alloc] init];
                                     currentAttention.attentionid = myFans.fanid;
                                     currentAttention.userid = TJUserInfoCurrent.userId;
                                     currentAttention.attentionname = myFans.fanname;
                                     currentAttention.attentionpicture = myFans.fanspicture;
                                     
                                     [TJDataCenter addSingleObject:currentAttention];
                                     
                                     attentionView.selected = YES;
                                     
                                 } failure:^(NSError *error) {
                                     
                                 }];
        
    }
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myFansList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TJMyFans *myFans = self.myFansList[indexPath.row];
    TJMyFansCell *cell = [TJMyFansCell cellWithTableView:tableView];
    
    cell.myFans = myFans;
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJMyFans *myFans = self.myFansList[indexPath.row];
    
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":myFans.fanid}
            success:^(id responseObject) {
                
                
                TJUserInfo *friendInfo = [TJUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
                friendInfo.userId = myFans.fanid;
                
                TJFriendProfileVC *friendProfileVC = [[TJFriendProfileVC alloc] initWithUserInfo:friendInfo];
                friendProfileVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:friendProfileVC animated:YES];
            } failure:^(NSError *error) {}];
    
    
}
@end
