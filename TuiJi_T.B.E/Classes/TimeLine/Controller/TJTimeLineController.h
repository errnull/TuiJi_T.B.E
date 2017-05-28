//
//  TJTimeLineController.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TJTimeLineTableView.h"

@interface TJTimeLineController : TJBaseAutoThemeVC

/**
 *  推己圈数据列表
 */
@property (nonatomic, strong) NSMutableArray *timeLineList;


/**
 *  推几圈tableView
 */
@property (nonatomic, weak) TJTimeLineTableView *timeLineTbaleView;
@end
