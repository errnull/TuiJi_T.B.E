//
//  TJDropDownCellModel.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJDropDownCellModel : NSObject
/**
 *  图标
 */
@property (nonatomic ,copy) NSString *icon;

/**
 *  文本
 */
@property (nonatomic ,copy) NSString *text;

/**
 *  工厂方法
 */
+ (instancetype)dropDownMenuWithIcon:(NSString *)icon text:(NSString *)text;
@end
