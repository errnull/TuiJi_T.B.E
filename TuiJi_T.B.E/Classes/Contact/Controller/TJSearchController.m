//
//  TJSearchController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSearchController.h"

@interface TJSearchController ()

@end

@implementation TJSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.view.subviews) {
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"_UISearchBarContainerView")]) {
            
            CGRect rect = view.frame;
            
            rect.origin.y = 20;
            
            view.frame = rect;
            
            break;
        }
    }
    
}


@end
