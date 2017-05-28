//
//  TJLocationNameTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJLocationNameTVC.h"
#import "TJLocationName.h"

#import "TJLocationNameCell.h"
#import "TJPublicTextTuiJiVC.h"

@interface TJLocationNameTVC ()

@property (nonatomic, strong) NSMutableArray *locationNameList;

@end

@implementation TJLocationNameTVC

/**
 *  懒加载
 */
- (NSMutableArray *)locationNameList{
    if (!_locationNameList) {
        _locationNameList = [NSMutableArray array];
    }
    return _locationNameList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = TJColorGrayBg;
    
    self.tableView.separatorColor = TJColorWhiteBg;
    
    [self setUpNavigationBar];

    [TJRemindTool showMessage:@""];
    
    [TJLocationTool reGeocodeSearchWithLocation:_currentLocation
                                        success:^(NSMutableArray *locationNameList) {
                                            
                                            self.tableView.separatorColor = TJColorLine;
                                            
                                            self.locationNameList = locationNameList;
                                            
                                            [self.tableView reloadData];
                                            
                                            [TJRemindTool hideHUD];
                                            
                                        } failure:^(NSError *error) {
                                            NSLog(@"error");
                                        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - private method
- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"选择位置"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *barButtonItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                     Image:@"navigationbar_back_black"
                                                                 highImage:@"navigationbar_back_black_highlighted"
                                                                    target:self
                                                                    action:@selector(backBtnClick)
                                                          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationNameList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJLocationName *locationName = self.locationNameList[indexPath.row];
    
    TJLocationNameCell *cell = [TJLocationNameCell cellWithTableView:tableView];
    cell.locationName = locationName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJLocationName *locationName = self.locationNameList[indexPath.row];
    TJPublicTextTuiJiVC *publicTextVC = (TJPublicTextTuiJiVC *)self.navigationController.childViewControllers[1];
    publicTextVC.currentLocationName = [NSString stringWithFormat:@"  %@%@  ",locationName.locationCity, locationName.locationName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
