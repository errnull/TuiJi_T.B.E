//
//  TJAreaSelectedTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 16/6/21.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAreaSelectedTVC.h"
#import "TJLocation.h"
#import "TJSbuAreaTVC.h"

@interface TJAreaSelectedTVC ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *currentLocationList;

@end

@implementation TJAreaSelectedTVC

/**
 *  location 懒加载
 */
- (NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}
- (NSMutableArray *)currentLocationList{
    if (!_currentLocationList) {
        _currentLocationList = [NSMutableArray array];
    }
    return _currentLocationList;
}

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.view.backgroundColor = TJColorGrayBg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
       //加载文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"xml"];
    NSData *locationData = [NSData dataWithContentsOfFile:path];
    
    //实例化一个xml解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:locationData];
    
    //设置代理
    parser.delegate = self;
    
    //开始解析
    [parser parse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else{
        return self.locations.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    TJLocation *location = self.locations[indexPath.row];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"请选择地区:";
    }else{
        cell.textLabel.text = location.Name;
    }
    return cell;
}

/**
 *  设置分组标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"定位到的位置";
    }else{
        return @"全部";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJLocation *location = self.locations[indexPath.row];
    
    //记录当前location
    NSMutableDictionary *locationList = [NSMutableDictionary dictionary];
    locationList[location.regionType] = location.Name;
    locationList[@"code"] = location.Code;

    if (location.subLocations.count != 0) {
    
        TJLocation *subLocation = [location.subLocations firstObject];
        if (subLocation.Name == nil) {
            
            TJSbuAreaTVC *subAreaTVC = [[TJSbuAreaTVC alloc] initWithData:subLocation.subLocations];
            
            subAreaTVC.locationList = locationList;
            
            [self.navigationController pushViewController:subAreaTVC animated:YES];
        }else{
            TJSbuAreaTVC *subAreaTVC = [[TJSbuAreaTVC alloc] initWithData:location.subLocations];
            
            subAreaTVC.locationList = locationList;
            
            [self.navigationController pushViewController:subAreaTVC animated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - 通过代理解析xml文档
//1.开始文档
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"1.打开文档,准备开始解析.");
    //初始化数组容器,清空容器
    [self.locations removeLastObject];
    [self.currentLocationList removeLastObject];
}
//2.开始节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    TJLocation *location = [TJLocation locationWithDic:attributeDict];
    location.regionType = elementName;
    
    [self.currentLocationList addObject:location];
}

//4.结束节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    TJLocation *currentLocation = [self.currentLocationList lastObject];
    [self.currentLocationList removeLastObject];
    TJLocation *lastLocation = [self.currentLocationList lastObject];
    
    [lastLocation.subLocations addObject:currentLocation];
    
    if (lastLocation == nil) {
        self.locations = currentLocation.subLocations;
    }
    
}
@end
