//
//  TJMyTuiTimeLineView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyTuiTimeLineView.h"

@interface TJMyTuiTimeLineView ()

@end

@implementation TJMyTuiTimeLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        TJTimeLineTableView *tableView = [[TJTimeLineTableView alloc] initWithFrame:frame];

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myTimeLineTableView = tableView;
        [self addSubview:_myTimeLineTableView];
        
        
    }
    return self;
}


@end
