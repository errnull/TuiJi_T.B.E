//
//  TJNewStatusAlertView.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJNewStatusAlertView : UIView

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic ,assign) CGFloat currentX;

+ (instancetype)newStatusAlertView;

- (void)addTarget:(id)target action:(SEL)action;
@end
