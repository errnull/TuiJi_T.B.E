//
//  TJFriendProfileVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJFriendProfileVC.h"
#import "MCCustomBar.h"
#import "TJMyTuiTimeLineView.h"
#import "TJMyTuiPictureView.h"
#import "TJSignInNavController.h"
#import "TJSignInViewController.h"
#import "TJEditUserInfoVC.h"

#import "TJRegionView.h"
#import "TJUserSettingTVC.h"

#import "TJFriendInfoView.h"

#import "TJMyTuiTimeLineViewCell.h"

#import "TJURLList.h"
#import "TJAccount.h"
#import "TJNewTimeLineParam.h"
#import "TJTimeLine.h"
#import "TJUserInfo.h"

#import "BLImageSize.h"

#import "TJLikeTimeLineParam.h"

#import "MJRefresh.h"

#import "TJCollectionHeadView.h"

#import "TJModifyUserInfoParam.h"

#import "TJTimeLineCommentVC.h"

#import "CKAlertViewController.h"
#import "GWYAlertSelectView.h"
#import "TJSingleListSelector.h"
#import "TJHomeTVController.h"
#import "TJTabBar.h"
#import "GJGCChatFriendTalkModel.h"
#import "TJExtensionMessage.h"
#import "GJGCChatFriendViewController.h"

#import "TJNewSquareImageCell.h"

#import "GJCUImageBrowserNavigationViewController.h"

#import "TJUserInfo.h"

@interface TJFriendProfileVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate, TJMyTuiTimeLineViewCellDelegate,TJSingleListSelectorDelegate>

@property (nonatomic, weak) TJFriendInfoView *headerView;
@property (nonatomic, weak) UIView *sectionView;
@property (nonatomic, weak)UIScrollView *tableScrollView;

@property (nonatomic, weak) TJMyTuiTimeLineView *myTuiTimeLineView;
@property (nonatomic, weak) TJMyTuiPictureView  *myTuiPictureView;

@property (nonatomic, strong) NSMutableArray *timeLineList;
@property (nonatomic, strong) NSMutableArray *imageTimeLineList;

@property (nonatomic, strong) GWYAlertSelectView * alertView;
@end

@implementation TJFriendProfileVC
{
    MCCustomBar *_myTimeLineBar;    //动态
    MCCustomBar *_myPictureBar;     //更多
    
    NSInteger _index;
    CGFloat _yOffset;
    CGFloat _removeHeight;
    TJMyTuiTimeLineViewCell *_currentMyTimeLineCell;
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

- (NSMutableArray *)imageTimeLineList{
    if (!_imageTimeLineList) {
        _imageTimeLineList = [NSMutableArray array];
    }
    return _imageTimeLineList;
}

- (instancetype)initWithUserInfo:(TJUserInfo *)userInfo
{
    if (self = [super init]) {
        
        
        _currentFriendInfo = userInfo;
        [self createHeaderView];
        
        self.view.backgroundColor = TJColorGrayBg;
    }
    return self;
}

-(void)viewDidLoad{
    
    [self createTableScrollView];
    
    [self loadCountData];
    
    // 设置导航条内容
    [self setUpNavgationBar];
    
    [self loadNewTimeLine];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footerForTimeLine = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTimeLine)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footerForTimeLine.automaticallyChangeAlpha = YES;
    
    // 设置header
    self.myTuiTimeLineView.myTimeLineTableView.mj_footer = footerForTimeLine;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footerForImageTimeLine = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewImageTimeLine)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footerForTimeLine.automaticallyChangeAlpha = YES;
    
    // 设置header
    self.myTuiPictureView.tableview.mj_footer = footerForImageTimeLine;
    [self.myTuiPictureView.tableview.mj_footer beginRefreshing];
}

- (void)loadCountData
{
    NSString *URLStr = [TJUrlList.loadBaseUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:@{@"uId":_currentFriendInfo.userId}
            success:^(id responseObject) {
                
                _headerView.tuiwenNumber = responseObject[@"tuiwenNumber"];
                _headerView.fansNumber = responseObject[@"fansNumber"];
                _headerView.attentionNumber = responseObject[@"attentionNumber"];
                
            } failure:^(NSError *error) {
                
            }];
    
}

/**
 *  设置导航条
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:_currentFriendInfo.uNickname
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
}

/**
 *  创建用户信息页
 */
- (void)createHeaderView
{
    TJFriendInfoView *headView = [[TJFriendInfoView alloc] initWithUserInfo:_currentFriendInfo];
    headView.backgroundColor = TJColorWhite;
    _headerView = headView;
    
//    _headerView.delegate = self;
    
    _yOffset = _headerView.center.y;
    [self.view addSubview:_headerView];
    
    _removeHeight = self.headerView.myInfoViewRealHeight - TJSectionBarH;
    [self createSectionView];
    
    
}

/**
 *  创建导航头
 */
-(void)createSectionView{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _removeHeight, TJWidthDevice, TJSectionBarH)];
    _sectionView = sectionView;
    _sectionView.backgroundColor = TJColorWhiteBg;
    
    //划线
    UIView *topLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
    topLine.gjcf_origin = CGPointMake(0,0);
    [_sectionView addSubview:topLine];
    
    CGFloat ControlBarWidth = TJWidthDevice/2;
    CGFloat ControlBarheight = 30;
    CGFloat ControlBarY =  CGRectGetMaxY(topLine.frame) + 4.5;
    CGSize barSize = CGSizeMake(ControlBarWidth, ControlBarheight);
    
    //动态bar
    _myTimeLineBar = [[MCCustomBar alloc] initWithCount:@"0" size:barSize andImageName:@"profilr_article" selectedImageName:@"profilr_article_selected"];
    [_myTimeLineBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _myTimeLineBar.tag = 0;
    _myTimeLineBar.gjcf_origin = CGPointMake(0, ControlBarY);
    _myTimeLineBar.selected = YES;
    [_sectionView addSubview:_myTimeLineBar];

    //更多bar
    _myPictureBar = [[MCCustomBar alloc] initWithCount:@"0" size:barSize andImageName:@"profilr_image" selectedImageName:@"profilr_image_selected"];
    [_myPictureBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _myPictureBar.tag = 2;
    _myPictureBar.gjcf_origin = CGPointMake(ControlBarWidth, ControlBarY);
    [_sectionView addSubview:_myPictureBar];
    
    //划线
    UIView *bottomLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
    bottomLine.gjcf_origin = CGPointMake(0, CGRectGetMaxY(_myTimeLineBar.frame) + 4);
    [_sectionView addSubview:bottomLine];
    
    [_headerView addSubview:_sectionView];
}

/**
 *  创建下方tableview
 */
-(void)createTableScrollView{
    CGFloat tableScrollX = 0;
    CGFloat tableScrollY = 0;
    CGFloat tableScrollWidth = TJWidthDevice;
    CGFloat tableScrollHeight = TJHeightDevice - TJHeightNavigationBar;
    
    UIScrollView *tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(tableScrollX, tableScrollY, tableScrollWidth, tableScrollHeight + TJHeightTabBar)];
    tableScrollView.delegate = self;
    tableScrollView.contentSize = CGSizeMake(TJWidthDevice, tableScrollHeight);
    tableScrollView.pagingEnabled = YES;
    tableScrollView.alwaysBounceVertical = NO;
    tableScrollView.bounces = NO;
    _tableScrollView = tableScrollView;
    
    //我的推文
    TJMyTuiTimeLineView *myTuiTimeLineView = [[TJMyTuiTimeLineView alloc] initWithFrame:CGRectMake(0, 0, TJWidthDevice, tableScrollHeight)];
    myTuiTimeLineView.myTimeLineTableView.tag = 100;
    myTuiTimeLineView.myTimeLineTableView.delegate = self;
    myTuiTimeLineView.myTimeLineTableView.dataSource = self;
    _myTuiTimeLineView = myTuiTimeLineView;
    [self createTableHeadView:_myTuiTimeLineView.myTimeLineTableView];
    [_tableScrollView addSubview:_myTuiTimeLineView];
    
    //我的图片
    TJMyTuiPictureView *myTuiPictureView = [[TJMyTuiPictureView alloc] initWithFrame:CGRectMake(TJWidthDevice*2, 0, TJWidthDevice, tableScrollHeight)];
    myTuiPictureView.tableview.tag = 102;
    myTuiPictureView.tableview.delegate = self;
    myTuiPictureView.tableview.dataSource = self;
    
    [myTuiPictureView.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([TJNewSquareImageCell class]) bundle:[NSBundle mainBundle]]
                 forCellWithReuseIdentifier:NSStringFromClass([TJNewSquareImageCell class])];
    [myTuiPictureView.tableview registerClass:[TJCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TJCollectionHeadView class])];
    
    
    _myTuiPictureView = myTuiPictureView;
    
    _myTuiPictureView.tableview.showsVerticalScrollIndicator = NO;
    _myTuiPictureView.tableview.backgroundColor = TJColorGrayBg;
    
    [_tableScrollView addSubview:_myTuiPictureView];
    
    
    [self.view addSubview:_tableScrollView];
    
}

-(void)createTableHeadView:(UITableView *)tableView{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TJWidthDevice, self.headerView.myInfoViewRealHeight)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = tableHeaderView;
    tableView.backgroundColor = TJColorGrayBg;
}

#pragma mark - private method

/**
 *  请求最新的推己圈
 */
- (void)loadNewTimeLine
{
    NSString *URLStr = [TJUrlList.loadNewTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    //创建请求参数
    TJNewTimeLineParam *newTimeLineParam = [[TJNewTimeLineParam alloc] init];
    newTimeLineParam.uId = _currentFriendInfo.userId;
    newTimeLineParam.type = @"0";
    
    //如果已经有推己圈
    if (self.timeLineList.count) {
        newTimeLineParam.since_id = [[self.timeLineList firstObject] tId];
    }
    
    [TJHttpTool GET:URLStr
         parameters:newTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                
                NSArray *timeLineList = (NSMutableArray *)[TJTimeLine mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, timeLineList.count)];
                //把最新的推己圈插入列表
                [self.timeLineList insertObjects:timeLineList atIndexes:indexSet];
                
                [self.myTuiTimeLineView.myTimeLineTableView reloadData];
            } failure:^(NSError *error) {}];
}

/**
 *  请求更多推己圈
 */
- (void)loadMoreTimeLine
{
    NSString *URLStr = [TJUrlList.loadNewTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    //创建请求参数
    TJNewTimeLineParam *newTimeLineParam = [[TJNewTimeLineParam alloc] init];
    newTimeLineParam.uId = _currentFriendInfo.userId;
    newTimeLineParam.type = @"0";
    
    //如果已经有推己圈
    if (self.timeLineList.count) {
        newTimeLineParam.max_id = [[self.timeLineList lastObject] tId];
    }
    
    [TJHttpTool GET:URLStr
         parameters:newTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                [self.myTuiTimeLineView.myTimeLineTableView.mj_footer endRefreshing];
                
                
                NSArray *timeLineList = (NSMutableArray *)[TJTimeLine mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                
                [self.timeLineList addObjectsFromArray:timeLineList];
                
                [self.myTuiTimeLineView.myTimeLineTableView reloadData];
            } failure:^(NSError *error) {
            }];
}

/**
 *  加载带图推文
 */
- (void)loadNewImageTimeLine
{
    NSString *URLStr = [TJUrlList.loadNewImageTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    //创建请求参数
    TJNewTimeLineParam *newTimeLineParam = [[TJNewTimeLineParam alloc] init];
    newTimeLineParam.uid = _currentFriendInfo.userId;
    newTimeLineParam.type = @"0";
    
    //如果已经有推己圈
    if (self.imageTimeLineList.count) {
        newTimeLineParam.max_id = [[self.imageTimeLineList lastObject] tId];
    }
    
    [TJHttpTool GET:URLStr
         parameters:newTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                
                [self.myTuiPictureView.tableview.mj_footer endRefreshing];
                
                NSArray *timeLineList = (NSMutableArray *)[TJTimeLine mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                
                [self.imageTimeLineList addObjectsFromArray:timeLineList];
                
                [self.myTuiPictureView.tableview reloadData];
            } failure:^(NSError *error) {}];
}

- (void)reloadData
{
    [self loadNewTimeLine];
    
    [self.myTuiTimeLineView.myTimeLineTableView setContentOffset:CGPointZero animated:NO];
}

/**
 *  导航条按钮点击
 */
- (void)changeView :(MCCustomBar *)sender{
    
    _index = sender.tag;
    
    if ([_myTimeLineBar isEqual:sender]) {
        
        [_tableScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _myTimeLineBar.selected = YES;
        _myPictureBar.selected = NO;
        
    }else if ([_myPictureBar isEqual:sender]){
        
        [_tableScrollView setContentOffset:CGPointMake(TJWidthDevice*2, 0) animated:NO];
        _myPictureBar.selected = YES;
        _myTimeLineBar.selected = NO;
    }
}

-(void)editBtnClick:(UIButton *)btn{
    
    [_myTuiTimeLineView.myTimeLineTableView reloadData];
    
    //重新登录
    [TJAccountTool deleteAccountData];
    
    //清空全部旧资料
    [TJDataCenter deleteAllData];
    
    [TJGuideTool guideRootViewController:TJKeyWindow];
    
}

- (void)userSettingViewClick:(MCCustomBar *)customBar
{

    TJUserSettingTVC *userSettingTVC = [TJUserSettingTVC userSettingTVC];
    
    userSettingTVC.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:userSettingTVC animated:YES];
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat scale = 1.0;
    // 放大
    if (offsetY < 0) {
        
    } else if (offsetY > 0) { // 缩小
        // 允许向上超过导航条缩小的最大距离为200
        // 为了防止缩小过度，给一个最小值为0.45，其中0.45 = 31.5 / 70.0，表示
        // 头像最小是31.5像素
        scale = MAX(0.45, 1 - offsetY / _removeHeight);
        
    }
    
    
    if (scrollView.contentOffset.y > _removeHeight) {
        _headerView.center = CGPointMake(_headerView.center.x, _yOffset - _removeHeight);
        return;
    }
    CGFloat h = _yOffset - offsetY;
    _headerView.center = CGPointMake(_headerView.center.x, h);
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

//设置tableView的偏移量
-(void)setTableViewContentOffsetWithTag:(NSInteger)tag contentOffset:(CGFloat)offset{
    
    CGFloat tableViewOffset = offset;
    if(offset > 161){
        
        tableViewOffset = 161;
    }
    if (tag == 100) {
        [_myTuiPictureView.tableview setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }else if(tag == 101){
        
        [_myTuiTimeLineView.myTimeLineTableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [_myTuiPictureView.tableview setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }else{
        
        [_myTuiTimeLineView.myTimeLineTableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeLineList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJTimeLine *myTimeLine = self.timeLineList[indexPath.row];
    myTimeLine.headImage = _currentFriendInfo.uPicture;
    
    TJMyTuiTimeLineViewCell *cell = [TJMyTuiTimeLineViewCell cellWithTableView:tableView];
    
    cell.myTimeLine = myTimeLine;
    
    cell.myTimeLineViewCellDelegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJTimeLine *myTimeLine = self.timeLineList[indexPath.row];
    
    CGFloat baseHeight = 94;
    
    CGFloat strWidth = TJWidthDevice - 113;
    
    CGSize strSize = [myTimeLine.tContent sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(strWidth, MAXFLOAT)];
    
    //不超出两行的高度
    strSize.height = (strSize.height > 36) ? 36 : strSize.height;
    
    baseHeight = strSize.height + baseHeight;
    
    if (myTimeLine.imgsUrl.count) {
        
        NSString *pictureURLStr = [myTimeLine.imgsUrl firstObject];
        
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:pictureURLStr];
        
        if (pictureSize.width > 0) {
            baseHeight = (TJWidthDevice - 67) * (pictureSize.height / pictureSize.width) + baseHeight;
        }else{
            baseHeight += (TJWidthDevice - 67);
        }
    }
    
    return baseHeight;
    
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageTimeLineList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TJTimeLine *timeLine = self.imageTimeLineList[indexPath.row];
    
    TJNewSquareImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJNewSquareImageCell class]) forIndexPath:indexPath];
    
    cell.timeLine = timeLine;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(TJWidthDevice, self.headerView.myInfoViewRealHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    TJCollectionHeadView *headView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TJCollectionHeadView class]) forIndexPath:indexPath];
        
        headView.backgroundColor = TJColorClear;
    }
    
    return headView;
}

//#pragma mark - TJMyInfoViewDelegate
//- (void)myInfoView:(TJMyInfoView *)myInfoView editUserInfoViewClick:(UIButton *)sender{
//    //获取 storyboard
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJEditUserInfo" bundle:nil];
//    //获取初始化箭头所指controller
//    TJEditUserInfoVC *editUserInfoVC = [storyboard instantiateInitialViewController];
//    
//    editUserInfoVC.hidesBottomBarWhenPushed = YES;
//    
//    [(TJNavigationController *)self.navigationController pushToLightViewController:editUserInfoVC animated:YES];
//}
//
//- (void)myInfoView:(TJMyInfoView *)myInfoView isPublicViewClick:(UIButton *)sender{
//    NSString *btnText = @"成为公众人物";
//    if ([TJUserInfoCurrent.uPublic intValue]) {
//        btnText = @"做回自己";
//    }
//    
//    //create a chooseSheet
//    UIActionSheet *isPublicSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                 destructiveButtonTitle:nil
//                                                      otherButtonTitles:btnText, nil];
//    isPublicSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
//    [isPublicSheet showInView:self.view];
//}

#pragma mark - TJMyTuiTimeLineViewCellDelegate

- (void)tableViewCell:(UITableViewCell *)tableViewCell moreViewClick:(UIButton *)sender{
    
    _currentMyTimeLineCell = (TJMyTuiTimeLineViewCell *)tableViewCell;
    
    //create a chooseSheet
    UIActionSheet *moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"删除"
                                                  otherButtonTitles:nil, nil];
    moreSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [moreSheet showInView:self.view];
    
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell likeViewClick:(UIButton *)sender{
    NSString *URLStr = [TJUrlList.userLikeTimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJLikeTimeLineParam *likeTimeLineParam = [[TJLikeTimeLineParam alloc] init];
    likeTimeLineParam.hostId = TJAccountCurrent.userId;
    TJMyTuiTimeLineViewCell *myTimeLineCell = (TJMyTuiTimeLineViewCell *)tableViewCell;
    likeTimeLineParam.tId = myTimeLineCell.myTimeLine.tId;
    
    sender.selected = !sender.selected;
    
    [TJHttpTool GET:URLStr
         parameters:likeTimeLineParam.mj_keyValues
            success:^(id responseObject) {
                TJMyTuiTimeLineViewCell *myTimeLineCell = (TJMyTuiTimeLineViewCell *)tableViewCell;
                NSIndexPath *indexPath = [self.myTuiTimeLineView.myTimeLineTableView indexPathForCell:myTimeLineCell];
                
                TJTimeLine *timeLine = self.timeLineList[indexPath.row];
                timeLine.isMyPraise = [NSString stringWithFormat:@"%d",sender.selected];
                
                if ([timeLine.isMyPraise isEqualToString:@"1"]) {
                    timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] + 1)];
                }else{
                    timeLine.praiseNum = [NSString stringWithFormat:@"%ld",([timeLine.praiseNum integerValue] - 1)];
                }
                
                [self.timeLineList removeObjectAtIndex:indexPath.row];
                [self.timeLineList insertObject:timeLine atIndex:indexPath.row];
                
                [self.myTuiTimeLineView.myTimeLineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            } failure:^(NSError *error) {
                sender.selected = !sender.selected;
                [TJRemindTool showError:@"点赞失败..."];
                NSLog(@"%@",error);
            }];
    
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell commentClick:(UIButton *)sender{
    
    TJMyTuiTimeLineViewCell *cell = (TJMyTuiTimeLineViewCell *)tableViewCell;
    
    TJTimeLineCommentVC *timeLineCommentVC = [[TJTimeLineCommentVC alloc] init];
    
    timeLineCommentVC.currentTimeLine = cell.myTimeLine;
    
    timeLineCommentVC.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:timeLineCommentVC animated:YES];
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell transmitViewClick:(UIButton *)sender{
    TJMyTuiTimeLineViewCell *cell = (TJMyTuiTimeLineViewCell *)tableViewCell;
    _currentClickTimeLine = cell.myTimeLine;
    
    if (_currentClickTimeLine.imgsUrl.count) {
        [self selectPersonalContact:sender];
        
    }else{
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"纯文字禁止转发哦."];
        
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action){}];
        
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:NO completion:nil];
    }
    
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell translatViewClick:(UIButton *)sender{
    [TJRemindTool showError:@"正在开发中..."];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_currentMyTimeLineCell) {
        
        TJMyTuiTimeLineViewCell *cell = _currentMyTimeLineCell;
        
        if (buttonIndex == 0) {
            
            [TJTimeLineTool deleteATimeLineWithTimeLineId:cell.myTimeLine.tId
                                                  success:^{
                                                      
                                                      NSIndexPath *indexPath = [self.myTuiTimeLineView.myTimeLineTableView indexPathForCell:cell];
                                                      NSInteger row = indexPath.row;
                                                      
                                                      [self.timeLineList removeObjectAtIndex:row];
                                                      
                                                      [self.myTuiTimeLineView.myTimeLineTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                      
                                                      _currentMyTimeLineCell = nil;
                                                  } failure:^(NSError *error) {}];
            
            
            
        }
        
    }else{
        
        if (buttonIndex == 0) {
            [TJRemindTool showMessage:@""];
            [TJUserInfoTool modifyUserInfoWithParam:@{@"public":[NSString stringWithFormat:@"%d",![TJUserInfoCurrent.uPublic intValue]]}
                                            Success:^{
                                                
                                            } failure:^(NSError *error) {}];
        }
        
        
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    _currentMyTimeLineCell = nil;
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
        dic[KEY_HEAD_URL] = TJUserInfoCurrent.uPicture;
        dic[KEY_NICKNAME] = TJUserInfoCurrent.uNickname;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TJTimeLine *timeLine = self.imageTimeLineList[indexPath.row];
    
    NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:[timeLine.imgsUrl firstObject]]];
    
    NSString *path = [[SDWebImageManager sharedManager].imageCache defaultCachePathForKey:imageKey];
    
    /* 进入大图浏览模式 */
    GJCUImageBrowserNavigationViewController *imageBrowser = [[GJCUImageBrowserNavigationViewController alloc] initWithLocalImageFilePaths:@[path]];
    imageBrowser.pageIndex = 1;
    [self presentViewController:imageBrowser animated:YES completion:nil];
}
@end
