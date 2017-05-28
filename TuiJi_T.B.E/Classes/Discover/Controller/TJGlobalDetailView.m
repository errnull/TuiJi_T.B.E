//
//  TJGlobalDetailView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/10/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGlobalDetailView.h"

@interface TJGlobalDetailView ()

@end

@implementation TJGlobalDetailView

/**
 *  将状态栏字体颜色变为黑色
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
}


- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:_titleViewText
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
}
@end
