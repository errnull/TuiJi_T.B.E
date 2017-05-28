//
//  TJSbuAreaTVC.h
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/6/23.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJSbuAreaTVC : UITableViewController

/**
 *  用户位置
 */
@property (nonatomic, strong) NSMutableDictionary *locationList;

- (instancetype)initWithData:(NSArray *)dataArray;

@end
