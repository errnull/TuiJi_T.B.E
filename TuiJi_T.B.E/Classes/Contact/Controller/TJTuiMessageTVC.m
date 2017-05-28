//
//  TJTuiMessageTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTuiMessageTVC.h"

@interface TJTuiMessageTVC ()

@end

@implementation TJTuiMessageTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUpNavgationBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [TJRemindTool showError:@"空空如也."];
}

#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"推信"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


@end
