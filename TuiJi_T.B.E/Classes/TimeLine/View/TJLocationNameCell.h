//
//  TJLocationNameCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/21.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJLocationName;

@interface TJLocationNameCell : UITableViewCell

@property (nonatomic, strong) TJLocationName *locationName;


+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
