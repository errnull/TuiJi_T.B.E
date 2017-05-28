//
//  TJDropDownCellModel.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJDropDownCellModel.h"

@implementation TJDropDownCellModel

+ (instancetype)dropDownMenuWithIcon:(NSString *)icon text:(NSString *)text
{
    TJDropDownCellModel *model = [[self alloc] init];
    model.icon = icon;
    model.text = text;
    
    return model;
}

@end
