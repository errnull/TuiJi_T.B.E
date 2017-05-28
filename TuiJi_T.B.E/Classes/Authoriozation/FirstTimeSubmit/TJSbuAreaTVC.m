//
//  TJSbuAreaTVC.m
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/6/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSbuAreaTVC.h"
#import "TJLocation.h"
#import "TJInformationViewController.h"
#import "TJEditUserInfoVC.h"
#import "TJModifyUserInfoParam.h"

@interface TJSbuAreaTVC ()

@property (nonatomic, strong) NSArray *locations;

@property (nonatomic, weak) UIViewController *backViewController;

@end

@implementation TJSbuAreaTVC

-(NSMutableDictionary *)locationList{
    if (!_locationList) {
        _locationList = [NSMutableDictionary dictionary];
    }
    return _locationList;
}

-(UIViewController *)backViewController{
    if (!_backViewController) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[TJInformationViewController class]]) {
                _backViewController = vc;
            }else if ([vc isKindOfClass:[TJEditUserInfoVC class]]){
                _backViewController = vc;
            }
        }
    }
    return _backViewController;
}

- (instancetype)initWithData:(NSArray *)dataArray{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.locations = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


}


#pragma mark - Table view data source

/**
 *  设置分组标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"全部";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    
    
    TJLocation *location = self.locations[indexPath.row];
    
    cell.textLabel.text = location.Name;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJLocation *location = self.locations[indexPath.row];
    NSMutableDictionary *locationList = self.locationList;
    locationList[location.regionType] = location.Name;
    if (location.subLocations.count != 0) {
        TJSbuAreaTVC *subAreaTVC = [[TJSbuAreaTVC alloc] initWithData:location.subLocations];

        subAreaTVC.locationList = locationList;
        
        [self.navigationController pushViewController:subAreaTVC animated:YES];
    }else{
        
        if ([self.backViewController isKindOfClass:[TJInformationViewController class]]) {
            TJInformationViewController *infoVC = (TJInformationViewController *)self.backViewController;
            infoVC.modifyUserInfoParam.locationList = locationList;
            
            [self.navigationController popToViewController:infoVC animated:YES];
        }else if ([self.backViewController isKindOfClass:[TJEditUserInfoVC class]]){
            TJEditUserInfoVC *editInfoVC = (TJEditUserInfoVC *)self.backViewController;
            
            NSString *stateStr = @"";
            if (locationList[@"State"]) {
                stateStr = locationList[@"State"];
            }else{
                stateStr = locationList[@"City"];
            }
            NSString *regionStr = [NSString stringWithFormat:@"%@%@%@",locationList[@"CountryRegion"], TJLocationPoint, stateStr];
            
            editInfoVC.currentRegion = [regionStr stringByAppendingString:[NSString stringWithFormat:@"_&%@",locationList[@"code"]]];
            
            [self.navigationController popToViewController:editInfoVC animated:YES];
        }
        
    }
}

@end
