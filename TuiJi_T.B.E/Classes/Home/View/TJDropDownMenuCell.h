//
//  TJDropDownMenuCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJDropDownCellModel;

@interface TJDropDownMenuCell : UITableViewCell

@property (nonatomic, strong) TJDropDownCellModel *dropDownModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
