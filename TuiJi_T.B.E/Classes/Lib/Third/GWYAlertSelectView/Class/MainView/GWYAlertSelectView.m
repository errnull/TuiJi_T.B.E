//
//  GWYAlertSelectView.m
//  GWYAlrtView-Demo
//
//  Created by 李国良 on 2016/9/26.
//  Copyright © 2016年 李国良. All rights reserved.
///============================================================================
//  欢迎各位提宝贵的意见给我  185226139 感谢大家的支持
// https://github.com/liguoliangiOS/GWYAlertSelectView.git
//=============================================================================


#import "GWYAlertSelectView.h"
#import "GWYAlertSelectViewController.h"


#define AlertViewAddressHeight 239

@interface GWYAlertSelectView ()<GWYAlertSelectViewControllerDelegate>

{
    GWYAlertSelectViewController * _alertSelectViewCtl;
}

@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) NSMutableArray * editSource;

@end

@implementation GWYAlertSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TJWidthDevice, TJHeightDevice)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.3;
        [self addSubview:self.blackView];
    }
    return self;
}

- (void)alertSelectViewshow {

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, TJHeightDevice, TJWidthDevice, AlertViewAddressHeight)];
    self.bgView.backgroundColor = [UIColor redColor];
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addSubview:[self addAlertSelectViewCtl].view];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.y = TJHeightDevice - AlertViewAddressHeight;
        
    }];
    [TJKeyWindow addSubview:self];
}

- (void)alertSelectViewClose {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.y = TJHeightDevice;
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}

- (void)alertViewSelectedBlock:(alertViewSelectedBlock)block {
    self.block = block;
}

#pragma mark ====== 点击事件 ====

- (void)tap:(UITapGestureRecognizer *)tap {
    [self alertSelectViewClose];
}



#pragma mark ====== GWYAlertSelectViewControllerDelegate=====

//- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkAddBtn:(UIButton *)addButton {
//    [UIView animateWithDuration:0.4 animations:^{
//        self.bgView.y = TJHeightDevice;
//    } completion:^(BOOL finished) {
//        [self.editSource removeAllObjects];
//        _alertSelectViewCtl.view.hidden = YES;
//        [UIView animateWithDuration:0.4 animations:^{
//            self.bgView.y = TJHeightDevice - AlertViewAddressHeight;
//        }];
//    }];
//}
//
//- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkOkBtn:(UIButton *)okButton {
//    [self alertSelectViewClose];
//}
//
//- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkCancelBtn:(UIButton *)cancelButton {
//    [self alertSelectViewClose];
//}


- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController finishSelected:(TJContact *)contact{
    [self alertSelectViewClose];
    if (self.block) {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObject:contact];
        self.block(dataArr);
    }
}

- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clickAddBtn:(UIButton *)addContactButton{
    [self alertSelectViewClose];
    
    if (self.block) {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObject:@"选择用户"];
        self.block(dataArr);
    }
    
}

- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clickToTimeLineBtn:(UIButton *)toTimeLineBtn{
    [self alertSelectViewClose];
    
    if (self.block) {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObject:@"转发到推己圈"];
        self.block(dataArr);
    }
}

#pragma mark ====== 添加alertSelectView =======

- (GWYAlertSelectViewController *)addAlertSelectViewCtl {
    if (!_alertSelectViewCtl) {
        _alertSelectViewCtl = [[GWYAlertSelectViewController alloc] init];
        self.addAlertViewType == GWYAlertSelectViewTypeGetAddress ? ( _alertSelectViewCtl.alertSelectType = GWYAlertSelectViewControllerTypeAddress) : ( _alertSelectViewCtl.alertSelectType = GWYAlertSelectViewControllerTypeContact);
        _alertSelectViewCtl.delegate = self;
        _alertSelectViewCtl.view.frame = CGRectMake(0, 0, TJWidthDevice,self.bgView.height);
        __block typeof(self) weakSelf = self;
        [_alertSelectViewCtl alertSelectViewEditBlock:^(NSMutableArray *eidtArray) {
            [weakSelf.editSource removeAllObjects];
            [weakSelf.editSource addObjectsFromArray:eidtArray];
            [UIView animateWithDuration:0.4 animations:^{
                self.bgView.y = TJHeightDevice;
            } completion:^(BOOL finished) {
                _alertSelectViewCtl.view.hidden = YES;
//                [self.bgView addSubview:[self addAlertViewCtl].view];
                [UIView animateWithDuration:0.4 animations:^{
                    self.bgView.y = TJHeightDevice  - AlertViewAddressHeight;
                }];
            }];
        }];
        [_alertSelectViewCtl alertSelectViewSelectedBlock:^(NSMutableArray *selectedArray) {
            weakSelf.block(selectedArray);
            [weakSelf alertSelectViewClose];
        }];
        _alertSelectViewCtl.view.hidden = NO;
        [self.bgView addSubview:_alertSelectViewCtl.view];
    }
    return _alertSelectViewCtl;
}

#pragma mark ====== 懒加载 =======

- (NSMutableArray *)editSource {
    if (!_editSource) {
        _editSource = [NSMutableArray array];
    }
    return _editSource;
}

- (void)keyboardWillChange:(NSNotification  *)notification
{
    
    // 1.获取键盘的Y值
    NSDictionary *dict  = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 2.计算需要移动的距离
    CGFloat selfY = keyboardY - self.height;
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        self.y = selfY;
        //self.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
        if (_bgView == nil) {
            //  [self.textField resignFirstResponder];
            [self removeFromSuperview];
        }
    }];
}


@end
