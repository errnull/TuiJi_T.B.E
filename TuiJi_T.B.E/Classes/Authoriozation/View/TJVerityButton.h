//
//  TJVerityButton.h
//  TJVerityBtnDemo
//
//  Created by TUIJI on 16/6/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJVerityButton : UIControl

@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, retain)UIColor *contentColor;
@property(nonatomic, retain)UIColor *progressColor;

@property(nonatomic, retain)UIButton *forDisplayButton;


- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)title
                         font:(UIFont *)font
                         time:(NSTimeInterval)time
                       corner:(float)corner
                       target:(id)target
                       action:(SEL)action;

- (void)startLoading;
@end
