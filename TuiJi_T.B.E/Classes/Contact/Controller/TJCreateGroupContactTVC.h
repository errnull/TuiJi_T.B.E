//
//  TJCreateGroupContactTVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJCreateGroupContactTVCDelegate <NSObject>

- (void)createGroupContactTVC:(UIViewController *)createGroupContactTVC didFinishCreate:(NSString *)teamID;

@end

@interface TJCreateGroupContactTVC : TJBaseAutoThemeTVC

@property (nonatomic, weak) id<TJCreateGroupContactTVCDelegate> delegate;

@end
