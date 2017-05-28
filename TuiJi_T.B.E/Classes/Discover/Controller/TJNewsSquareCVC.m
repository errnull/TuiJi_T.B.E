//
//  TJNewsSquareCVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewsSquareCVC.h"

#import "TJSquareNews.h"

#import "TJSquareNewsTool.h"


#import "MJRefresh.h"

#import "TJNewSquareImageCell.h"

#import "TJSquarePreviewVC.h"
#import "TJNewSquareDetailTVC.h"

#import <STPopupPreview/STPopupPreview.h>

#import "GWYAlertSelectView.h"

#import "TJSingleListSelector.h"

#import "CKAlertViewController.h"

#import "TJHomeTVController.h"
#import "TJTabBar.h"
#import "TJContact.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"

#import "TJExtensionMessage.h"

@interface TJNewsSquareCVC ()<STPopupPreviewRecognizerDelegate,TJSingleListSelectorDelegate>

@property (nonatomic, strong) NSMutableArray *squareNewsList;

@property (nonatomic, strong) GWYAlertSelectView * alertView;

@end

@implementation TJNewsSquareCVC
{
    TJSquareNews *_currentSquareNews;
}

/**
 *  懒加载
 */
- (NSMutableArray *)squareNewsList{
    if (!_squareNewsList) {
        _squareNewsList = [NSMutableArray array];
    }
    return _squareNewsList;
}

- (instancetype)init{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemMargin = 1;
    CGFloat itemW = (TJWidthDevice-2*itemMargin)/3;
    
    
    flowLayout.itemSize = CGSizeMake(itemW, itemW);
    flowLayout.minimumInteritemSpacing =itemMargin ;
    flowLayout.minimumLineSpacing = itemMargin;
    
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = TJColorGrayBg;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TJNewSquareImageCell class]) bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:NSStringFromClass([TJNewSquareImageCell class])];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSquareNews)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.collectionView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldSquareNews)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 设置header
    self.collectionView.mj_footer = footer;
    
    [self.collectionView.mj_header beginRefreshing];

    
}

- (void)loadNewSquareNews
{
//    [TJSquareNewsTool loadNewSquareNewSuccess:^(NSArray *squareNewsList) {
//        [self.collectionView.mj_header endRefreshing];
//        
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, squareNewsList.count)];
//        // 把最新的动态数插入到最前面
//        [self.squareNewsList insertObjects:squareNewsList atIndexes:indexSet];
//        
//        [self.collectionView reloadData];
//        
//    } failure:^(NSError *error) {}];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0 ; i < 12; i++) {
            TJSquareNews *news = [[TJSquareNews alloc] init];
            
            news.squareNewsID = @"12345678";
            news.userid = @"12345678";
            news.username = @"董宝君_iOS";
            news.userIcon = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
            news.content = @"再美终究只是一方风景.";
            news.pictureid = @"1";
            news.imageUrl = @"http://pic74.nipic.com/file/20150811/9448607_092213892000_2.jpg";
            news.squareNewsType = @"0";
            news.commentnumber = @"20";
            news.time = @"昨天 下午10:57";
            news.praisenumber = @"50";
            
            [self.squareNewsList addObject:news];
        }
        

        
       
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
    });
    
}

- (void)loadOldSquareNews
{
//    [TJSquareNewsTool loadOldSquareNewSuccess:^(NSArray *squareNewsList) {
//        [self.collectionView.mj_footer endRefreshing];
//        
//        // 把最新的动态数插入到最后面
//        [self.squareNewsList addObjectsFromArray:squareNewsList];
//        
//        [self.collectionView reloadData];
//        
//    } failure:^(NSError *error) {}];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0 ; i < 12; i++) {
            TJSquareNews *news = [[TJSquareNews alloc] init];
            
            news.squareNewsID = @"12345678";
            news.userid = @"12345678";
            news.username = @"董宝君_iOS";
            news.userIcon = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
            news.content = @"再美终究只是一方风景.";
            news.pictureid = @"1";
            news.imageUrl = @"http://pic74.nipic.com/file/20150811/9448607_092213892000_2.jpg";
            news.squareNewsType = @"0";
            
            [self.squareNewsList addObject:news];
        }
        
        
        
        
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TJSquareNews *squareNews = self.squareNewsList[indexPath.row];
    
    TJNewSquareDetailTVC *detailTVC = [[TJNewSquareDetailTVC alloc] init];
    detailTVC.squareNews = squareNews;
    detailTVC.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:detailTVC animated:YES];
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareNewsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TJSquareNews *squareNews = self.squareNewsList[indexPath.row];
    
    TJNewSquareImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJNewSquareImageCell class]) forIndexPath:indexPath];
    
    if (!cell.popupPreviewRecognizer) {
        cell.popupPreviewRecognizer = [[STPopupPreviewRecognizer alloc] initWithDelegate:self];
    }
    
    cell.squareNews = squareNews;
    
    return cell;
}


#pragma mark - STPopupPreviewRecognizerDelegate

- (UIViewController *)previewViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    if (![popupPreviewRecognizer.view isKindOfClass:[UICollectionViewCell class]]) {
        return nil;
    }
    
    TJNewSquareImageCell *cell = popupPreviewRecognizer.view;

    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJDiscover" bundle:nil];
    
    TJSquarePreviewVC *previewVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJSquarePreviewVC class])];
    
    previewVC.squareNews = cell.squareNews;
    
    return previewVC;
}

- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return self;
}

- (NSArray<STPopupPreviewAction *> *)previewActionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return @[
                [STPopupPreviewAction actionWithTitle:@"赞"
                                                style:STPopupPreviewActionStyleDefault
                                              handler:^(STPopupPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                                  [TJRemindTool showSuccess:@"点赞成功"];
                                              }],
                
                [STPopupPreviewAction actionWithTitle:@"转发"
                                                style:STPopupPreviewActionStyleDefault
                                              handler:^(STPopupPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                                  
                                                  TJSquarePreviewVC *squarePreviewVC = (TJSquarePreviewVC *)previewViewController;
                                                  
                                                  _currentSquareNews = squarePreviewVC.squareNews;
                                                  
                                                  [self selectPersonalContact:nil];
                                                  
                                                  
                                                  
                                                  
                                              }]
            ];



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
        
        TJHomeTVController *home = self.tabBarController.childViewControllers[0].childViewControllers[0];
        [self.navigationController popViewControllerAnimated:NO];
        
        for (UIView *view in self.tabBarController.tabBar.subviews) {
            if ([view isKindOfClass:[TJTabBar class]]) {
                TJTabBar *tabbar = (TJTabBar*)view;
                [tabbar btnClick:tabbar.buttons[0]];
                break;
            }
        }
        
        NIMSession *session = [NIMSession session:contact.userId type:NIMSessionTypeP2P];
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId = @"0";
        talk.contact = contact;
        talk.session = session;
        talk.toUserName = contact.remark;
        
        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
        
        privateChat.hidesBottomBarWhenPushed = YES;
        [home.navigationController pushViewController:privateChat animated:NO];
        
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[KEY_USER_ID] = _currentSquareNews.squareNewsID;
        dic[KEY_HEAD_URL] = _currentSquareNews.userIcon;
        dic[KEY_NICKNAME] = _currentSquareNews.username;
        dic[KEY_PHOTO] = _currentSquareNews.imageUrl;
        dic[KEY_TEXT] = _currentSquareNews.content;
        dic[KEY_TYPE] = _currentSquareNews.squareNewsType;

        _currentSquareNews = nil;

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
