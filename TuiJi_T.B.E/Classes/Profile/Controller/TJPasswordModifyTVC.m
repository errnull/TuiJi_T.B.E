//
//  TJPasswordModifyTVC.m
//  TuiJi_T.B.E
//
//  Created by 繁轩 on 16/10/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPasswordModifyTVC.h"
#import "TJAccount.h"
#import "TJUserInfo.h"
#import "NSString+NIM.h"

#import "TJURLList.h"
#import "TJModifyUserInfoParam.h"


@interface TJPasswordModifyTVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwdView;
@property (weak, nonatomic) IBOutlet UITextField *firstNewPwdView;
@property (weak, nonatomic) IBOutlet UITextField *secordNewPwdView;

@property (copy, nonatomic) NSString *lastNewPwd;

@end

@implementation TJPasswordModifyTVC{
    BOOL _oldPwdCorrect;
    BOOL _newPwdEqual;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.tableView endEditing:YES];
}



- (void)viewDidLoad{
    
    _oldPwdCorrect = NO;
    _newPwdEqual = YES;
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    [self setUpNavigationBar];
    
    _oldPwdView.delegate = self;
    _oldPwdView.tag = 0;
    
    _firstNewPwdView.delegate = self;
    _firstNewPwdView.tag = 1;
    
    _secordNewPwdView.delegate = self;
    _secordNewPwdView.tag = 2;
}

- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"更改密码"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *barButtonItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                     Image:@"navigationbar_back_black"
                                                                 highImage:@"navigationbar_back_black_highlighted"
                                                                    target:self
                                                                    action:@selector(backBtnClick)
                                                          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *rightBtn = [TJUICreator createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                                 text:@"确定"
                                                                 font:TJFontWithSize(14)
                                                                color:TJColorGrayFontDark
                                                               target:self
                                                               action:@selector(finishModify)
                                                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackGroundBlack.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)finishModify
{
    
    [self.tableView endEditing:YES];
    
    if (!_oldPwdCorrect) {
        [TJRemindTool showError:@"输入的密码有误!"];
        return;
    }
    
    if (!_newPwdEqual) {
        [TJRemindTool showError:@"两次密码不相同，请检查。"];
        return;
    }
    
    if (_lastNewPwd == nil) {
        [TJRemindTool showError:@"密码不能为空。"];
        return;
        
    }
    //检验通过开始修改密码
    NSString *URLStr = [TJUrlList.modifyUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJModifyUserInfoParam *param = [[TJModifyUserInfoParam alloc] init];
    param.username = TJUserInfoCurrent.uUsername;
    param.password = [_lastNewPwd nim_MD5String];
    
    [TJHttpTool POST:URLStr
          parameters:param.mj_keyValues
             success:^(id responseObject) {
                 
                 //修改成功
                 [self.navigationController popViewControllerAnimated:YES];
                 [TJRemindTool showSuccess:@"修改成功."];
                 
                 
             } failure:^(NSError *error) {
                 
             }];
    

}
#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0:
            //旧密码
            if (![[textField.text nim_MD5String] isEqualToString:TJAccountCurrent.password]) {
                //密码错误
                [TJRemindTool showError:@"输入的密码有误！"];
            }else{
                _oldPwdCorrect = YES;
            }
            
            break;
        
        case 1:
            if (textField.text.length == 0) {
                _lastNewPwd = nil;
                break;
            }
            if (!(_lastNewPwd == nil)) {
                if (![textField.text isEqualToString:_lastNewPwd]) {
                    //两次密码不匹配
                    [TJRemindTool showError:@"两次密码不相同，请检查。"];
                    _newPwdEqual = NO;
                }
            }
            //新密码
            _lastNewPwd = textField.text;
            break;
            
        case 2:
            if (textField.text.length == 0) {
                _lastNewPwd = nil;
                break;
            }
            //再次输入
            if (!(_lastNewPwd == nil)) {
                if (![textField.text isEqualToString:_lastNewPwd]) {
                    //两次密码不匹配
                    [TJRemindTool showError:@"两次密码不相同，请检查。"];
                    _newPwdEqual = NO;
                }
            }
            //新密码
            _lastNewPwd = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}
@end
