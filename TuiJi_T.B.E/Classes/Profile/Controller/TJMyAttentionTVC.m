//
//  TJMyAttentionTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/8.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyAttentionTVC.h"
#import "TJURLList.h"
#import "TJAccount.h"

#import "TJMyFans.h"
#import "TJMyFansCell.h"
#import "CKAlertViewController.h"
#import "TJAttention.h"
#import "TJFriendProfileVC.h"


@interface TJMyAttentionTVC ()<TJMyFansDelegate>

@property (nonatomic, strong) NSMutableArray *myAttentionList;

@end

@implementation TJMyAttentionTVC
/**
 *  懒加载
 */
- (NSMutableArray *)myAttentionList{
    if (!_myAttentionList) {
        _myAttentionList = [TJAttentionTool attentionList];
    }
    return _myAttentionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TJColorGrayBg;
}

- (void)setUpNavigationBar
{
    
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"关注"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myAttentionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJAttention *attention = self.myAttentionList[indexPath.row];
    TJMyFansCell *cell = [TJMyFansCell cellWithTableView:tableView];
    
    cell.myAttention = attention;
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJAttention *myAttention = self.myAttentionList[indexPath.row];
    
    if (!(myAttention.attentionid.length == TJAccountCurrent.userId.length)) {
        return;
    }
    
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":myAttention.attentionid}
            success:^(id responseObject) {
                
                
                TJUserInfo *friendInfo = [TJUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
                friendInfo.userId = myAttention.attentionid;
                
                TJFriendProfileVC *friendProfileVC = [[TJFriendProfileVC alloc] initWithUserInfo:friendInfo];
                friendProfileVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:friendProfileVC animated:YES];
            } failure:^(NSError *error) {}];
    
    
}

#pragma mark - TJMyFansDelegate
- (void)myFansCell:(TJMyFansCell *)myFansCell didClickAttentionView:(UIButton *)attentionView{
    
    TJAttention *attention = myFansCell.myAttention;
    
    //提示用户是否要删除
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"确定取消关注?"];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        
        [TJAttentionTool unPayAttntionToSB:attention.attentionid
                                     where:0
                                   Success:^{
                                       
                                       //取消关注成功 删除该数据
                                       [self.myAttentionList removeObject:attention];
                                       
                                       //如果取消关注成功 手动删除
                                       [TJDataCenter deleteAObjectWithClassName:NSStringFromClass([TJAttention class]) conditions:[NSString stringWithFormat:@"attentionid = '%@'",attention.attentionid]];
                                       
                                       //删除这个cell
                                       NSIndexPath *indexPath = [self.tableView indexPathForCell:myFansCell];
                                       [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                       
                                       [TJRemindTool showSuccess:@"操作成功."];
      
                                       
                                   } failure:^(NSError *error) {}];
    }];
    
    
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];

    
    
    
}

@end
