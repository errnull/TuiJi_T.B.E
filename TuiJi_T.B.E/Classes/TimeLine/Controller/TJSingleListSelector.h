//
//  TJSingleListSelector.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJSingleListSelectorDelegate <NSObject>

- (void)singleListSelector:(UITableViewController *)singleListSelector didFinishSelect:(id)data;

@end

@interface TJSingleListSelector : UITableViewController

@property (nonatomic, weak) id<TJSingleListSelectorDelegate> delegate;

@property (nonatomic ,copy) NSString *selectType;

@property (nonatomic, strong) NSMutableArray *dataList;

- (instancetype)initWithDataList:(NSMutableArray *)dataList;

@end
