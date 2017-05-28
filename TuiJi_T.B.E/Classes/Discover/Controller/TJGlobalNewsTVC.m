//
//  TJGlobalNewsTVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGlobalNewsTVC.h"

#import "MJRefresh.h"

#import "TJGlobalNewsTool.h"
#import "TJGlobalNews.h"
#import "TJDiscoverBaseCell.h"
#import "TJGlobalNewsCell.h"
#import "TJVideoNewsCell.h"

#import "BLImageSize.h"


#import "TJURLList.h"
#import "TJAccount.h"

#import "TJGlobalDetailView.h"

#define TJFromMediaKeyVideo @"video"
BOOL _needReloadCell = NO;
@interface TJGlobalNewsTVC ()<TJGlobalNewsCellDelegate>

@property (nonatomic, strong) NSMutableArray *globalNewsList;

@end

@implementation TJGlobalNewsTVC

- (NSMutableArray *)globalNewsList{
    if (!_globalNewsList) {
        _globalNewsList = [NSMutableArray array];
    }
    return _globalNewsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadGlobalNews)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldGlobalNews)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;

    // 设置header
    self.tableView.mj_footer = footer;

    //请求全球资讯
    [self.tableView.mj_header beginRefreshing];


}

#pragma mark - private method
- (void)loadOldGlobalNews
{
    [TJGlobalNewsTool loadOldGlobalNewsIfSuccess:^(NSArray *globalNewsList) {
        
        [self.tableView.mj_footer endRefreshing];
        
        // 把数组中的元素添加进去
        [self.globalNewsList addObjectsFromArray:globalNewsList];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {}];
}

/**
 *  初始化全球资讯
 */
- (void)loadGlobalNews
{
    [TJGlobalNewsTool loadGlobalNewsIfSuccess:^(NSArray *globalNewsList) {
    
        [self.tableView.mj_header endRefreshing];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, globalNewsList.count)];
        // 把最新的动态数插入到最前面
        [self.globalNewsList insertObjects:globalNewsList atIndexes:indexSet];

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {}];
}


/**
 *  edinburghnews	英国爱丁堡晚报)
 TouTiao
 dailynews	泰国每日新闻
 saudigazette	沙特公报
 tuoitre	越南青年报
 dispatch	韩国dispatch新闻网
 youtube	秒拍/新浪/youtube
 */

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJGlobalNews *globalNews = self.globalNewsList[indexPath.row];
    
    CGFloat baseHeight = 140;

    
    if (globalNews.titlePicture) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:globalNews.titlePicture];
        if (pictureSize.width > 0) {
            baseHeight += (TJWidthDevice - 17) * (pictureSize.height / pictureSize.width);
        }else{
            baseHeight += (TJWidthDevice - 17);
            _needReloadCell = YES;
        }
        
    }
    CGSize strSize = [globalNews.contentCatch sizeWithFont:TJFontWithSize(14) maxSize:CGSizeMake(TJWidthDevice-39, MAXFLOAT)];
    
    //不超出两行的高度
    baseHeight += (strSize.height > 39) ? 39 : strSize.height;
    
    return baseHeight;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.globalNewsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TJGlobalNews *globalNews = self.globalNewsList[indexPath.row];
    
    TJGlobalNewsCell *cell = [TJGlobalNewsCell cellWithTableView:tableView];
    
    cell.globalNews = globalNews;
    
    cell.globalNewCellDelegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJGlobalNews *globalNews = self.globalNewsList[indexPath.row];
    
    TJGlobalDetailView *vc = [[TJGlobalDetailView alloc] init];
    
    vc.titleViewText = globalNews.fromMediaCHI;
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    NSString *URLStr = [TJUrlList.loadGlobalDetail stringByAppendingString:TJAccountCurrent.jsessionid];

    NSString *globalDetailURLStr = [URLStr stringByAppendingString:[NSString stringWithFormat:@"?fromwhere=%@&id=%@",globalNews.fromMedia, globalNews.worldTweetId]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:globalDetailURLStr]]];
    
    webView.backgroundColor = TJColorGrayBg;
    vc.view.backgroundColor = TJColorGrayBg;
    
    vc.view = webView;
    vc.hidesBottomBarWhenPushed = YES;
    
    [(TJNavigationController *)self.navigationController pushToLightViewController:vc animated:YES];
    
    

}
#pragma mark - TJGlobalNewsCellDelegate
- (void)globalNewsCell:(TJGlobalNewsCell *)globalNewsCell webImageDidFinishLoad:(UIImage *)image{
    if (_needReloadCell) {
        if ([self.tableView indexPathForCell:globalNewsCell]) {
            [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:globalNewsCell]] withRowAnimation:UITableViewRowAnimationNone]; 
        }
        _needReloadCell = NO;
    }
}

@end
