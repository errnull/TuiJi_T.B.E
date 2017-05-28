//
//  TJListSelector.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/13.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJListSelector;
@protocol TJListSelectorDelegate <NSObject>

- (void)listSelector:(TJListSelector *)listSelector didFinishSelect:(NSMutableArray *)selectedSesult;

@end

@interface TJListSelector : UITableViewController

@property (nonatomic, weak) id<TJListSelectorDelegate> delegate;

@property (nonatomic ,copy) NSString *selectType;

@property (nonatomic, strong) NSMutableArray *dataList;

- (instancetype)initWithDataList:(NSMutableArray *)dataList;
@end
