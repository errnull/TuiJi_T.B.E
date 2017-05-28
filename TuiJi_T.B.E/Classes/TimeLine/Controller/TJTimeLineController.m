//
//  TJTimeLineController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineController.h"

#import "TJTimeLine.h"


#import "MJRefresh.h"

#import "TJTimeLineCell.h"

#import "TJPublicTextTuiJiVC.h"

#import "TJTimeLineCommentVC.h"

#import "BLImageSize.h"

#import "TJCameraController.h"

#import "SimpleVideoFileFilterViewController.h"

#import "TJSimpleImageFilterViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "GWYAlertSelectView.h"

#import "CKAlertViewController.h"

#import "TJHomeTVController.h"
#import "TJTabBar.h"
#import "GJGCChatFriendTalkModel.h"
#import "GJGCChatFriendViewController.h"

#import "TJSingleListSelector.h"
#import <SDWebImageManager.h>

#import "TJExtensionMessage.h"
#import "TJURLList.h"
#import "TJAccount.h"

#import "TJNotificationModel.h"

#import "TJNewStatusAlertView.h"
#import "TJTimeLineNewStatusAit.h"
#import "TJTimeLineNewStatusPraise.h"
#import "TJTimeLineNewStatusComment.h"

#import "TJTimeLineNewStatusTVC.h"

#import "TJUserInfo.h"
#import "TJFriendProfileVC.h"

#define  WC __unsafe_unretained typeof(self) weakSelf = self


@interface TJTimeLineController ()
<UITableViewDelegate,
UITableViewDataSource,
TJTimeLineCellDelegate,
UIActionSheetDelegate,
SimpleVideoFileFilterViewControllerDelegate,
UIImagePickerControllerDelegate,
TJSimpleImageFilterDelegate,
TJSingleListSelectorDelegate,
NIMSystemNotificationManagerDelegate
>

/**
 *  发送文本推己圈按钮
 */
@property (nonatomic, weak) UIButton *textTuiJiView;

/**
 *  发送图片推几圈按钮
 */
@property (nonatomic, weak) UIButton *imageTuiJiView;

/**
 *  线
 */
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, strong) GWYAlertSelectView * alertView;

@property (nonatomic, weak) TJNewStatusAlertView *statusAlertView;

@end


@implementation TJTimeLineController{
    BOOL _needReloadCell;
    
    TJTimeLine *_currentClickTimeLine;
}

/**
 *  懒加载
 */
- (NSMutableArray *)timeLineList{
    if (!_timeLineList) {
        _timeLineList = [NSMutableArray array];
    }
    return _timeLineList;
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self setUpAllSubViews];
        [self layoutAllSubViews];
        
        _needReloadCell = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setUpNewStatusAlertView];
    [self showNewStatusAlertViewIfNeed];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hideNewStatusAlertView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    self.view.backgroundColor = TJColorGrayBg;
    
    [self.timeLineTbaleView.mj_header beginRefreshing];
    
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
}

- (void)dealloc{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
}
#pragma mark - private method

/**
 *  请求最新的推己圈
 */
- (void)loadNewTimeLine
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TJTimeLine *timeLine = [[TJTimeLine alloc] init];
        timeLine.cfType = @"0";
        timeLine.commentNum = @"20";
        timeLine.imgsUrl = @[@"http://pic74.nipic.com/file/20150811/9448607_092213892000_2.jpg"];
        timeLine.isMyPraise = @"1";
        timeLine.isTurn = @"0";
        timeLine.praiseNum = @"30";
        timeLine.tContent = @"再美终究是一方风景";
        timeLine.tTime = @"   昨天";
        timeLine.tType = @"1";
        timeLine.headImage = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
        timeLine.nickname = @"董宝君_iOS";
        
        
        [self.timeLineList addObject:timeLine];
        
        [self.timeLineTbaleView reloadData];
        
        [self.timeLineTbaleView.mj_header endRefreshing];
    });

    
    
    
    
//    NSString *sinceID = nil;
//    
//    //如果已经有推己圈
//    if (self.timeLineList.count) {
//        sinceID = [[self.timeLineList firstObject] tId];
//    }
//    
//    [TJTimeLineTool loadTimeLineWithSinceID:sinceID
//                                    orMaxID:nil
//                                    success:^(NSMutableArray *timeLineList) {
//                                        self.tabBarItem.badgeValue = nil;
//                                        [self.timeLineTbaleView.mj_header endRefreshing];
//                                        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, timeLineList.count)];
//                                        //把最新的推己圈插入列表
//                                        [self.timeLineList insertObjects:timeLineList atIndexes:indexSet];
//                                        
//                                        [self.timeLineTbaleView reloadData];
//                                        
//                                    } failure:^(NSError *error) {}];
    
    
    
}

/**
 *  请求更多推己圈
 */
- (void)loadMoreTimeLine
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TJTimeLine *timeLine = [[TJTimeLine alloc] init];
        timeLine.cfType = @"0";
        timeLine.commentNum = @"20";
        timeLine.imgsUrl = @[@"http://pic74.nipic.com/file/20150811/9448607_092213892000_2.jpg"];
        timeLine.isMyPraise = @"1";
        timeLine.isTurn = @"0";
        timeLine.praiseNum = @"30";
        timeLine.tContent = @"再美终究是一方风景";
        timeLine.tTime = @"   昨天";
        timeLine.tType = @"1";
        timeLine.headImage = @"http://tva1.sinaimg.cn/crop.0.0.640.640.180/b45f9791jw8epdo0pu9fgj20hs0hsdgl.jpg";
        timeLine.nickname = @"董宝君_iOS";
        
        
        [self.timeLineList addObject:timeLine];
        
        [self.timeLineTbaleView reloadData];
        
        [self.timeLineTbaleView.mj_footer endRefreshing];
    });
}


- (void)setUpNavigationBar
{

    UIButton *titleView = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleView setImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tuijiView")] forState:UIControlStateNormal];

    titleView.frame = TJRectFromSize(CGSizeMake(52, 28));
    
    titleView.imageEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 51);
    
    titleView.userInteractionEnabled = NO;
    
    self.navigationItem.titleView = titleView;
    
}

- (void)setUpNewStatusAlertView
{
    if (self.statusAlertView) {
        return;
    }
    TJNewStatusAlertView *NewStatusAlertView = [TJNewStatusAlertView newStatusAlertView];
    _statusAlertView = NewStatusAlertView;
    
    [self.navigationController.view insertSubview:_statusAlertView aboveSubview:self.navigationController.navigationBar];
    [_statusAlertView addTarget:self action:@selector(newStatusAlertViewClick:)];
    _statusAlertView.gjcf_left = self.navigationController.navigationBar.gjcf_right;
    _statusAlertView.gjcf_top = self.navigationController.navigationBar.gjcf_bottom + 44;
}

- (void)newStatusAlertViewClick:(TJNewStatusAlertView *)sender
{
    TJTimeLineNewStatusTVC *timeLineNewStatusTVC = [[TJTimeLineNewStatusTVC alloc] init];
    timeLineNewStatusTVC.hidesBottomBarWhenPushed = YES;
    [(TJNavigationController *)self.navigationController pushToLightViewController:timeLineNewStatusTVC animated:YES];
}

- (void)showNewStatusAlertViewIfNeed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //判断数据库中是否有提示数据
    RLMResults<TJTimeLineNewStatusAit *> *result = [TJTimeLineNewStatusAit allObjects];
    if (result.count) {
        dic[NSStringFromClass([TJTimeLineNewStatusAit class])] = @(result.count);
    }
    RLMResults<TJTimeLineNewStatusPraise *> *result1 = [TJTimeLineNewStatusPraise allObjects];
    if (result1.count) {
        dic[NSStringFromClass([TJTimeLineNewStatusPraise class])] = @(result1.count);
    }
    RLMResults<TJTimeLineNewStatusComment *> *result2 = [TJTimeLineNewStatusComment allObjects];
    if (result2.count) {
        dic[NSStringFromClass([TJTimeLineNewStatusComment class])] = @(result2.count);
    }
    
    if (dic.count) {
        self.statusAlertView.dataDic = dic;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.statusAlertView.x = TJWidthDevice - self.statusAlertView.currentX;
        }];
    }
}

- (void)hideNewStatusAlertView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.statusAlertView.x = TJWidthDevice;
    }];
}

/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //推几圈tableView
    TJTimeLineTableView *timeLineTbaleView = [[TJTimeLineTableView alloc] initWithSize:CGSizeMake(TJWidthDevice, self.view.height - 148)];
    
    timeLineTbaleView.delegate = self;
    timeLineTbaleView.dataSource = self;
    
    timeLineTbaleView.backgroundColor =TJColorGrayBg;
    
    timeLineTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTimeLine)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    timeLineTbaleView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTimeLine)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 设置header
    timeLineTbaleView.mj_footer = footer;
    
    _timeLineTbaleView = timeLineTbaleView;
    [self.view addSubview:_timeLineTbaleView];
    
    
    //发送文本推己圈按钮
    CGFloat btnWidth = TJWidthDevice * 0.5;
    CGFloat imageMargin = (btnWidth - 39) * 0.5;
    UIButton *textTuiJiView = [TJUICreator createButtonWithSize:CGSizeMake(btnWidth, 39)
                                                    NormalImage:@"timeLine_textBtn"
                                                  selectedImage:@"timeLine_textBtn_h"
                                                         target:self
                                                         action:@selector(textTuiJiViewClick:)];
    textTuiJiView.imageEdgeInsets = UIEdgeInsetsMake(0, imageMargin, 0, imageMargin);
    textTuiJiView.backgroundColor = TJColorWhite;
    _textTuiJiView = textTuiJiView;
    [self.view addSubview:_textTuiJiView];

    //发送图片推几圈按钮
    UIButton *imageTuiJiView = [TJUICreator createButtonWithSize:CGSizeMake(btnWidth, 39)
                                                     NormalImage:@"timeLine_imageBtn"
                                                highlightedImage:@"timeLine_imageBtn_h"
                                                          target:self
                                                          action:@selector(imageTuiJiViewClick:)];
    imageTuiJiView.imageEdgeInsets = UIEdgeInsetsMake(0, imageMargin, 0, imageMargin);
    imageTuiJiView.backgroundColor = TJColorWhite;
    _imageTuiJiView = imageTuiJiView;
    [self.view addSubview:_imageTuiJiView];
    
    UIView *lineView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 0.5)
                                               bgColor:TJColor(204, 204, 204)
                                                radius:0.0];
    _lineView = lineView;
    [self.view addSubview:_lineView];
    
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_textTuiJiView atTheLeftTopOfTheView:self.view offset:CGSizeZero];
    [TJAutoLayoutor layView:_imageTuiJiView atTheRightTopOfTheView:self.view offset:CGSizeZero];
    
    [TJAutoLayoutor layView:_timeLineTbaleView belowTheView:_textTuiJiView span:CGSizeZero alignmentType:AlignmentLeft];
    
    [TJAutoLayoutor layView:_lineView belowTheView:_textTuiJiView span:CGSizeZero alignmentType:AlignmentLeft];
}

- (void)textTuiJiViewClick:(UIButton *)sender
{
    TJPublicTextTuiJiVC *publicTextTuiJiVC = [TJPublicTextTuiJiVC PublicTextVCWithShowImage:nil];
    
    publicTextTuiJiVC.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController: publicTextTuiJiVC animated:YES];
}

- (void)imageTuiJiViewClick:(UIButton *)sender
{
    [self pickVideoFromCamera];
}

- (void)pickVideoFromCamera
{
    //获取 storyboard
    TJCameraController *captureVC = [TJCameraController cameraViewController];
    
    WC;
    
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             //传出的是URL则是视频
             if ([result isKindOfClass:[NSURL class]]) {
                 NSURL *fileURL = result;
                 
                 weakSelf.videoPath = fileURL.path;
                 
                 [self performSelector:@selector(showS) withObject:self afterDelay:0.2];
             }else if([result isKindOfClass:[UIImage class]]){
                 
                 //如果是图片, 则是相机回调
                 UIImage *takeImage = (UIImage *)result;
                 TJSimpleImageFilterViewController *imageFilterVC = [[TJSimpleImageFilterViewController alloc] initWithImage:takeImage
                                                                                                                   cropFrame:CGRectMake(0, 44.0, TJWidthDevice, TJWidthDevice) limitScaleRatio:3.0];
                 
                 imageFilterVC.delegate = self;
                 
                 [self presentViewController:imageFilterVC animated:YES completion:^{
                     [[UIApplication sharedApplication] setStatusBarHidden:YES];
                 }];

                 
                
             }else{
                 //如果是空 则进入相册
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

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showS{
    
    SimpleVideoFileFilterViewController *newFilter=[SimpleVideoFileFilterViewController new];
    newFilter.inputFilePath=self.videoPath;
    
    newFilter.outputFilePath=[self getTmpPath];
    newFilter.vcdelegate=self;
    
    [self presentViewController:newFilter animated:YES completion:nil];
    
}

- (void)videoHandleSuccess:(BOOL)isSuccess resultPath:(NSString *)path
{
    if (isSuccess) {
        TJPublicTextTuiJiVC *publicTimeLineVC = [TJPublicTextTuiJiVC PublicTextVCWithShowImage:[UIImage imageNamed:@"myicon"]];
        publicTimeLineVC.videoData = [NSData dataWithContentsOfFile:path];
        publicTimeLineVC.timeLineImageList = (NSMutableArray *)@[UIImagePNGRepresentation([UIImage imageNamed:@"myicon"])];
        
        publicTimeLineVC.hidesBottomBarWhenPushed = YES;
        
        [(TJNavigationController *)self.navigationController pushToLightViewController: publicTimeLineVC animated:YES];
    }
}

- (NSString *)getTmpPath
{
    
    NSError *err = nil;
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"] error:&err];
        
    }
    
    return  [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeLineList.count;
}

- (UITableViewCell *)tableView:(TJTimeLineTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJTimeLine *timeLine = self.timeLineList[indexPath.row];
    
    TJTimeLineCell *cell = [TJTimeLineCell cellWithTableView:tableView];
    
    cell.timeLine = timeLine;
    
    cell.timeLineCellDelegate = self;
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TJTimeLine *timeLine = self.timeLineList[indexPath.row];
    CGFloat baseHeight = 127;
    
    if (![timeLine.isTurn isEqualToString:@"0"]) {
        timeLine = timeLine.transmitTimeLine;
        baseHeight += 37;
    }

    if (timeLine.imgsUrl.count) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:[timeLine.imgsUrl firstObject]];
        if (pictureSize.width > 0) {
            baseHeight += TJWidthDevice * (pictureSize.height / pictureSize.width);
        }else{
            baseHeight += TJWidthDevice;
            _needReloadCell = YES;
        }
        
    }

    CGSize strSize = [timeLine.tContent sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(TJWidthDevice-62, MAXFLOAT)];
    
    //不超出两行的高度
    baseHeight += (strSize.height > 36) ? 36 : strSize.height;
    
    return baseHeight;

}


#pragma mark - TJTimeLineCellDelegate
- (void)tableViewCell:(UITableViewCell *)tableViewCell iconViewDidClick:(UIButton *)sender
{
    TJTimeLineCell *cell = (TJTimeLineCell *)tableViewCell;
    TJTimeLine *timeLine = cell.timeLine;
    
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":timeLine.userId}
            success:^(id responseObject) {
                
                
                TJUserInfo *friendInfo = [TJUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
                friendInfo.userId = timeLine.userId;
                
                TJFriendProfileVC *friendProfileVC = [[TJFriendProfileVC alloc] initWithUserInfo:friendInfo];
                friendProfileVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:friendProfileVC animated:YES];
            } failure:^(NSError *error) {}];
    
    
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell moreViewDidClick:(UIButton *)sender
{
    //保存当前被点击的
    TJTimeLineCell *cell = (TJTimeLineCell *)tableViewCell;
    _currentClickTimeLine = cell.timeLine;
    
    if (_currentClickTimeLine.imgsUrl.count) {
        //create a chooseSheet
        UIActionSheet *moreSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏",@"保存相册", nil];
        moreSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [moreSheet showInView:self.view];
    }else{
        //create a chooseSheet
        UIActionSheet *moreSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", nil];
        moreSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [moreSheet showInView:self.view];
    }
  
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell likeViewDidClick:(UIButton *)sender
{
    //设置红心
    sender.selected = !sender.selected;
    TJTimeLineCell *cell = (TJTimeLineCell *)tableViewCell;
    [TJTimeLineTool likeTimeLineID:cell.timeLine.tId
                           success:^{
                               //取出数据修改
                               TJTimeLineCell *timeLineCell = (TJTimeLineCell *)tableViewCell;
                               NSIndexPath *indexPath = [self.timeLineTbaleView indexPathForCell:timeLineCell];
                               
                               TJTimeLine *timeLine = self.timeLineList[indexPath.row];
                               timeLine.isMyPraise = [NSString stringWithFormat:@"%d",sender.selected];
                               
                               if ([timeLine.isMyPraise isEqualToString:@"1"]) {
                                   timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] + 1)];
                               }else{
                                   timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] - 1)];
                               }
                               
                               [self.timeLineList removeObjectAtIndex:indexPath.row];
                               [self.timeLineList insertObject:timeLine atIndex:indexPath.row];
                               
                               [self.timeLineTbaleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                               
                           } failure:^(NSError *error) {
                               sender.selected = !sender.selected;
                               [TJRemindTool showError:@"点赞失败..."];
                           }];
}

- (void)tableViewCell:(TJTimeLineCell *)tableViewCell commentViewDidClick:(UIButton *)sender
{
    TJTimeLineCommentVC *timeLineCommentVC = [[TJTimeLineCommentVC alloc] init];
    
    timeLineCommentVC.currentTimeLine = tableViewCell.timeLine;
    
    timeLineCommentVC.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:timeLineCommentVC animated:YES];

}

- (void)tableViewCell:(UITableViewCell *)tableViewCell transMitViewDidClick:(UIButton *)sender
{
    TJTimeLineCell *cell = (TJTimeLineCell *)tableViewCell;
    _currentClickTimeLine = cell.timeLine;
    
    if (_currentClickTimeLine.imgsUrl.count) {
       [self selectPersonalContact:sender];

    }else{
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"纯文字禁止转发哦."];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action){}];
        
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:NO completion:nil];
    }
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell translatViewDidClick:(UIButton *)sender
{
    NSLog(@"翻译被点击了");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"offset---scroll:%f",self.myTableView.contentOffset.y);

    CGFloat offset=scrollView.contentOffset.y;
    if (offset==0) {

        [self showNewStatusAlertViewIfNeed];
    }else {
        
        [self hideNewStatusAlertView];
    }
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
                    NSString *URLStr = [TJUrlList.transmitToTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
                    [TJHttpTool GET:URLStr
                         parameters:@{@"type":@1, @"hostUid":TJAccountCurrent.userId, @"tId":@"330", @"passiveUid":_currentClickTimeLine.userId}
                            success:^(id responseObject) {
                                
                                NSLog(@"%@",responseObject);
                                
                                
                            } failure:^(NSError *error) {
                                NSLog(@"%@",error);
                                
                            }];
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
        
        dic[KEY_USER_ID] = _currentClickTimeLine.worldHide;
        dic[KEY_HEAD_URL] = _currentClickTimeLine.headImage;
        dic[KEY_NICKNAME] = _currentClickTimeLine.nickname;
        dic[KEY_PHOTO] = [_currentClickTimeLine.imgsUrl firstObject];
        dic[KEY_TEXT] = _currentClickTimeLine.tContent;
        dic[KEY_TYPE] = @"0";
        
        _currentClickTimeLine = nil;

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

#pragma mark - UIActionSheet Delegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.tabBarController.tabBar.hidden = NO;
    _currentClickTimeLine = nil;
}

#pragma mark - TJGlobalNewsCellDelegate
- (void)tableViewCell:(UITableViewCell *)tableViewCell webImageDidFinishLoad:(UIImage *)image{
    if (_needReloadCell) {
        if ([self.timeLineTbaleView indexPathForCell:tableViewCell]) {
            [self.timeLineTbaleView reloadRowsAtIndexPaths:@[[self.timeLineTbaleView indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationNone];
        }
        _needReloadCell = NO;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //收藏按钮点击
            [TJTimeLineTool collectTimeLineID:_currentClickTimeLine.tId
                                      success:^{
                                        [TJRemindTool showSuccess:@"收藏成功."];
                                      } failure:^(NSError *error) {}];
            break;
            
        case 1:
            //保存相册点击
            [TJDataCenter saveImage:[[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:[_currentClickTimeLine.imgsUrl firstObject]] Success:^(id responseObject) {} failure:^(NSError *error) {}];
            
            break;
            
        case 2:
            //取消按钮点击
            
            
            break;
        default:
            break;
    }
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
                                                  //准备发送推己圈
                                                  
                                                  TJPublicTextTuiJiVC *publicTimeLineVC = [TJPublicTextTuiJiVC PublicTextVCWithShowImage:editedImage];
                                                  
                                                  publicTimeLineVC.timeLineImageList = (NSMutableArray *)@[UIImagePNGRepresentation(editedImage)];
                                                  
                                                  publicTimeLineVC.hidesBottomBarWhenPushed = YES;
                                                  
                                                  [(TJNavigationController *)self.navigationController pushToLightViewController: publicTimeLineVC animated:YES];
   
                                              }];
}

- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    TJNotificationModel *notificationModel = [TJNotificationModel mj_objectWithKeyValues:notification.content];
    if ([notificationModel.code isEqualToString:@"2004"]) {
        self.tabBarItem.badgeValue = TJShowRedPoint;
    }else if ([notificationModel.code isEqualToString:@"2006"]){
        TJTimeLineNewStatusAit *timeLineNewStatusAit = [TJTimeLineNewStatusAit mj_objectWithKeyValues:notification.content];
        [TJDataCenter addAObject:timeLineNewStatusAit];
        [self showNewStatusAlertViewIfNeed];
        self.tabBarItem.badgeValue = TJShowRedPoint;
    }else if ([notificationModel.code isEqualToString:@"2000"]){
        TJTimeLineNewStatusPraise *timeLineNewStatusPraise = [TJTimeLineNewStatusPraise mj_objectWithKeyValues:notification.content];
        [TJDataCenter addAObject:timeLineNewStatusPraise];
        [self showNewStatusAlertViewIfNeed];
        self.tabBarItem.badgeValue = TJShowRedPoint;
    }else if ([notificationModel.code isEqualToString:@"2002"]){
        TJTimeLineNewStatusComment *timeLineNewStatusComment = [TJTimeLineNewStatusComment mj_objectWithKeyValues:notification.content];
        [TJDataCenter addAObject:timeLineNewStatusComment];
        [self showNewStatusAlertViewIfNeed];
        self.tabBarItem.badgeValue = TJShowRedPoint;
    }
}
@end

