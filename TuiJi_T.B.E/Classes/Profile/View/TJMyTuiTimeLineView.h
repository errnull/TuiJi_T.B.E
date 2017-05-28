//
//  TJMyTuiTimeLineView.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TJTimeLineTableView.h"

@interface TJMyTuiTimeLineView : UIView

@property (nonatomic,weak)TJTimeLineTableView *myTimeLineTableView;

@property (nonatomic,copy) void(^scrollObserve)();

@end
