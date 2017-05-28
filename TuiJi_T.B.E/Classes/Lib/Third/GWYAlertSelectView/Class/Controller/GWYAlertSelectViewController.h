//
//  GWYAlertSelectViewController.h
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/23.
//  Copyright © 2016年 郑卓青. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditBlock)(NSMutableArray * eidtArray);
typedef void(^SelectedBlock)(NSMutableArray * selectedArray);

typedef enum {
    GWYAlertSelectViewControllerTypeContact,
    GWYAlertSelectViewControllerTypeAddress
    
}GWYAlertSelectViewControllerType;

@class GWYAlertSelectViewController;


@protocol GWYAlertSelectViewControllerDelegate <NSObject>

- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clickAddBtn:(UIButton *)addContactButton;
- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clickCancelBtn:(UIButton *)cancelButton;
- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clickToTimeLineBtn:(UIButton *)toTimeLineBtn;
- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController finishSelected:(TJContact *)contact;

@end

@interface GWYAlertSelectViewController : UIViewController

@property (nonatomic, weak) id<GWYAlertSelectViewControllerDelegate>delegate;
@property (nonatomic, copy) EditBlock editBlock;
@property (nonatomic, copy) SelectedBlock selectedBlock;
@property (nonatomic, assign) GWYAlertSelectViewControllerType alertSelectType;

- (void)alertSelectViewEditBlock:(EditBlock)block;
- (void)alertSelectViewSelectedBlock:(SelectedBlock)block;
@end
