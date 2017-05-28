//
//  TJNewSquareDetailTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewSquareDetailTVC.h"

#import "TJNewsSquareCell.h"
#import "TJSquareNews.h"

#import "BLImageSize.h"

#import "TJCommentTVC.h"

#import "TJVPraiseVC.h"

#import <SDWebImageManager.h>

#import "TJURLList.h"
#import "TJAccount.h"

#import "CKAlertViewController.h"
#import "TJAttention.h"
#import "TJFriendProfileVC.h"

@interface TJNewSquareDetailTVC ()<TJSquareNewsCellDelegate, UIActionSheetDelegate>

@end

@implementation TJNewSquareDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self setUpNavigationBar];
}
- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"推文"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat baseHeight = 141;
    
    
    if (!TJStringIsNull(_squareNews.imageUrl)) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:_squareNews.imageUrl];
        if (pictureSize.width > 0) {
            baseHeight += TJWidthDevice * (pictureSize.height / pictureSize.width);
        }else{
            baseHeight += TJWidthDevice;
//            _needReloadCell = YES;
        }
        
    }
    
    CGSize strSize = [_squareNews.content sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(TJWidthDevice-62, MAXFLOAT)];
    
    //不超出两行的高度
    baseHeight += (strSize.height > 36) ? 36 : strSize.height;
    
    return baseHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJNewsSquareCell *cell = [TJNewsSquareCell cellWithTableView:tableView];
    cell.squareNews = _squareNews;
    cell.squareNewsCellDelegate = self;
    
    return cell;
}

#pragma mark - TJSquareNewsCellDelegate

/**
 *  关注
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell attentionViewDidClick:(UIButton *)sender{
    TJNewsSquareCell *cell = (TJNewsSquareCell *)tableViewCell;
    TJSquareNews *squareNews = cell.squareNews;
    
    if (sender.isSelected) {
        //提示用户是否要删除
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"确定取消关注?"];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
        
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            
            [TJAttentionTool unPayAttntionToSB:squareNews.userid
                                         where:0
                                       Success:^{
                                           
                                           //如果取消关注成功 手动删除
                                           [TJDataCenter deleteAObjectWithClassName:NSStringFromClass([TJAttention class]) conditions:[NSString stringWithFormat:@"attentionid = '%@'",squareNews.userid]];
                                           sender.selected = NO;
                                           [TJRemindTool showSuccess:@"操作成功."];
                                           
                                       } failure:^(NSError *error) {}];
        }];
        
        
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:NO completion:nil];
        
    }else{
        NSString *userID = squareNews.userid;
        NSInteger type = 0;
        
        if (TJStringIsNull(userID)) {
            userID = squareNews.username;
            type = 1;
        }
        
        //关注该用户
        [TJAttentionTool payAttntionToSB:userID
                                   where:type
                                 Success:^{
                                     //如果关注成功 手动插入数据库
                                     TJAttention *currentAttention = [[TJAttention alloc] init];
                                     currentAttention.attentionid = squareNews.userid;
                                     currentAttention.userid = TJUserInfoCurrent.userId;
                                     currentAttention.attentionname = squareNews.username;
                                     currentAttention.attentionpicture = squareNews.userIcon;
                                     
                                     [TJDataCenter addSingleObject:currentAttention];
                                     
                                     sender.selected = YES;
                                     
                                 } failure:^(NSError *error) {
                                     
                                 }];
        
    }
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell likeViewDidClick:(UIButton *)sender
{
    //设置红心
    sender.selected = !sender.selected;
    
//    [TJTimeLineTool likeTimeLineID:_squareNews.igIdStr
//                           success:^{
//                               //设置红心
//                               sender.selected = !sender.selected;
//                               //取出数据修改
//                               _squareNews.pr = [NSString stringWithFormat:@"%d",sender.selected];
//                               
//                               if ([timeLine.isMyPraise isEqualToString:@"1"]) {
//                                   timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] + 1)];
//                               }else{
//                                   timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] - 1)];
//                               }
//                               
//                               [self.timeLineList removeObjectAtIndex:indexPath.row];
//                               [self.timeLineList insertObject:timeLine atIndex:indexPath.row];
//                               
//                               [self.timeLineTbaleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                               
//                           } failure:^(NSError *error) {
//                               sender.selected = !sender.selected;
//                               [TJRemindTool showError:@"点赞失败..."];
//                           }];
}


/**
 *  更多按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell moreViewDidClick:(UIButton *)sender{
    //create a chooseSheet
    UIActionSheet *moreSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏",@"保存相册", nil];
    moreSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [moreSheet showInView:self.view];
}

/**
 *  评论按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell commentViewDidClick:(UIButton *)sender{
    
    TJCommentTVC *commentTVC = [[TJCommentTVC alloc] init];
    commentTVC.currentSquareNews = _squareNews;
    
    [self.navigationController pushViewController:commentTVC animated:YES];
}

/**
 *  转发按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell transMitViewDidClick:(UIButton *)sender{
    
}

/**
 *  翻译按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell translatViewDidClick:(UIButton *)sender{
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        //收藏按钮点击
        
        NSString *URLString = [TJUrlList.collectSquareNews stringByAppendingString:TJAccountCurrent.jsessionid];
        
        [TJHttpTool POST:URLString
              parameters:@{@"userID":TJAccountCurrent.userId, @"ID":_squareNews.squareNewsID, @"type":_squareNews.squareNewsType}
                 success:^(id responseObject) {
                     
                     [TJRemindTool showSuccess:@"收藏成功"];
                     
                 } failure:^(NSError *error) {
                     
                 }];

    }else if (buttonIndex == 1){
        //保存相册点击
        [TJDataCenter saveImage:[[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:_squareNews.imageUrl] Success:^(id responseObject) {} failure:^(NSError *error) {}];

    }
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell iconViewDidClick:(UIButton *)sender{
    NSString *userId = _squareNews.userid;
    if (userId.length != TJAccountCurrent.userId.length) {
        return;
    }
    
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":userId}
            success:^(id responseObject) {
                
                
                TJUserInfo *friendInfo = [TJUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
                friendInfo.userId = userId;
                
                TJFriendProfileVC *friendProfileVC = [[TJFriendProfileVC alloc] initWithUserInfo:friendInfo];
                friendProfileVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:friendProfileVC animated:YES];
            } failure:^(NSError *error) {}];

    
    
}
@end
