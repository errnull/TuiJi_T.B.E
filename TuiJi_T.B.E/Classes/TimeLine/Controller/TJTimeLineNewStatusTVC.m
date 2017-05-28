//
//  TJTimeLineNewStatusTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineNewStatusTVC.h"

#import "TJTimeLineNewStatus.h"
#import "TJTimeLineNewStatusAit.h"
#import "TJTimeLineNewStatusPraise.h"
#import "TJTimeLineNewStatusComment.h"

#import "TJTimeLineNewStatusCell.h"

@interface TJTimeLineNewStatusTVC ()

@property (nonatomic, strong) NSMutableArray *statusList;

@end

@implementation TJTimeLineNewStatusTVC

/**
 *  懒加载
 */
- (NSMutableArray *)statusList{
    if (!_statusList) {
        _statusList = [NSMutableArray array];
    }
    return _statusList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadNewStatus];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self deleteStatusNewsFromDataBase];
}

- (void)setUpNavigationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"推己圈消息提醒"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
}

- (void)loadNewStatus
{
    RLMResults<TJTimeLineNewStatusAit *> *resultList1 = [TJTimeLineNewStatusAit allObjects];
    [self.statusList addObjectsFromArray:(NSArray *)resultList1];
    
    RLMResults<TJTimeLineNewStatusPraise *> *resultList2 = [TJTimeLineNewStatusPraise allObjects];
    [self.statusList addObjectsFromArray:(NSArray *)resultList2];
    
    RLMResults<TJTimeLineNewStatusComment *> *resultList3 = [TJTimeLineNewStatusComment allObjects];
    [self.statusList addObjectsFromArray:(NSArray *)resultList3];
    
    [self.tableView reloadData];
}

- (void)deleteStatusNewsFromDataBase
{
    //删除数据库中的提醒消息
    
    [TJDataCenter deleteAllObjectWithClassName:NSStringFromClass([TJTimeLineNewStatusAit class])];
    [TJDataCenter deleteAllObjectWithClassName:NSStringFromClass([TJTimeLineNewStatusPraise class])];
    [TJDataCenter deleteAllObjectWithClassName:NSStringFromClass([TJTimeLineNewStatusComment class])];
}

#pragma mark - UITableViewDelegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.statusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJTimeLineNewStatus *timeLineStatus = self.statusList[indexPath.row];
    
    TJTimeLineNewStatusCell *cell = [TJTimeLineNewStatusCell cellWithTableView:tableView];
    cell.timeLineStatus = timeLineStatus;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

@end
