//
//  TJLocationTool.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJLocationTool.h"
#import "TJLocationName.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define TJLocationManager [TJLocationTool shareManager]
#define TJSearchManager   [TJLocationTool searchManager]

TJLocationTool *_locationTool;

AMapLocationManager *_locationManager;
AMapSearchAPI *_searchManager;

void(^_success)(NSMutableArray *locationNameList);
void(^_failure)(NSError *error);

CLLocation *_currentLocation;

@interface TJLocationTool ()<AMapSearchDelegate>

@end

@implementation TJLocationTool

/**
 *  获取单例
 */
+ (AMapLocationManager *)shareManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

+ (AMapSearchAPI *)searchManager
{
    if (!_searchManager) {
        _searchManager = [[AMapSearchAPI alloc] init];
        _locationTool = [[self alloc] init];
        _searchManager.delegate = _locationTool;
    }
    return _searchManager;
}

/**
 *  设置api key
 */
+ (void)setupAMapServicesApiKey:(NSString *)apiKey
{
    [AMapServices sharedServices].apiKey = apiKey;

}

/**
 *  获取当前位置
 */
+ (void)currentLocationSuccess:(void(^)(CLLocation *location, NSString *locationString))success failure:(void(^)(NSError *error))failure
{
    
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [TJLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    //   定位超时时间，最低2s，此处设置为2s
//    TJLocationManager.locationTimeout =2;
//    //   逆地理请求超时时间，最低2s，此处设置为2s
//    TJLocationManager.reGeocodeTimeout = 2;

    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [TJLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    TJLocationManager.locationTimeout = 6;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    TJLocationManager.reGeocodeTimeout = 6;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [TJLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if(!error){
            if(success) success(location, [[[regeocode.city substringToIndex:(regeocode.city.length - 1)] stringByAppendingString:TJLocationPoint] stringByAppendingString:regeocode.POIName]);
        }else{
            [TJRemindTool showError:@"获取位置失败..."];
            if (failure) failure(error);
        }
        

        
    }];
}

//@property (nonatomic, copy)   NSString  *types; //!< 类型，多个类型用“|”分割 可选值:文本分类、分类代码
//@property (nonatomic, assign) NSInteger  sortrule; //!< 排序规则, 0-距离排序；1-综合排序, 默认1
//@property (nonatomic, assign) NSInteger  offset; //!< 每页记录数, 范围1-50, [default = 20]
//@property (nonatomic, assign) NSInteger  page; //!< 当前页数, 范围1-100, [default = 1]
//
//@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回扩展信息，默认为 NO。
//@property (nonatomic, assign) BOOL requireSubPOIs; //!< 是否返回扩POI，默认为 NO。

+ (void)reGeocodeSearchWithLocation:(CLLocation *)location
                            success:(void(^)(NSMutableArray *locationNameList))success
                            failure:(void(^)(NSError *error))failure
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.requireSubPOIs      = NO;
    request.radius              = 6000;
    request.offset              = 100;
    request.keywords            = @"汽车服务|餐饮服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";

    
    
    [TJSearchManager AMapPOIAroundSearch:request];
    
    _success = success;
    _failure = failure;
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        if (_failure) {
            _failure(nil);
        }
        return;
    }
    
    NSMutableArray *locationList = [NSMutableArray array];
    for (AMapPOI *poi in response.pois) {
        TJLocationName *locationName = [[TJLocationName alloc] init];
        locationName.locationName = poi.name;
        locationName.locationDetail = poi.address;
        locationName.locationCity = [NSString stringWithFormat:@"%@%@",[poi.city substringToIndex:(poi.city.length -1)],TJLocationPoint];
       
        locationName.locationDistant = [NSString stringWithFormat:@"%ldm", (long)poi.distance];
        [locationList addObject:locationName];
    }
    if (_success) {
        _success(locationList);
    }
}
@end
