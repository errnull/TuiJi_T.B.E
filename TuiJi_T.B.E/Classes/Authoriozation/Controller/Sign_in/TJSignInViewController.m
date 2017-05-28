//
//  TJSignInViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSignInViewController.h"
#import "TJInPutView.h"
#import "TJSignUpViewController.h"
#import "TJPwdForgotViewController.h"
#import "TJTabBarController.h"

#import "TJAccount.h"
#import "TJSignParam.h"

#import "TJContact.h"

#import "NSString+NIM.h"

#import "CKAlertViewController.h"

@interface TJSignInViewController ()

/**
 *  top enterprise logo of TuiJi
 */
@property (nonatomic, weak) UIImageView *logoView;
/**
 *  enterprise identifier of TuiJi
 */
@property (nonatomic, weak) UILabel *identifierView;
/**
 *  account imageView contains background image and textField
 */
@property (nonatomic, weak) TJInPutView *accountView;
/**
 *  password imageView contains background image and textField
 */
@property (nonatomic, weak) TJInPutView *pwdView;
/**
 *  sign in button
 */
@property (nonatomic, weak) UIButton *sign_inView;
/**
 *  password forgot button
 */
@property (nonatomic, weak) UIButton *pwdForgotView;
/**
 *  sign up button
 */
@property (nonatomic, weak) UIButton *sign_upView;
/**
 *  enterprise description
 */
@property (nonatomic, weak) UILabel *descriptionView;

@end

@implementation TJSignInViewController

#pragma mark - system method

/**
 *  init set up subViews
 */
- (instancetype)init
{
    if (self = [super init]) {
        [self setUpAllSubViews];
        // Layout all sub views
        [self layoutAllSubViews];
        self.view.backgroundColor = TJColorGrayBg;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self runAnimationWithImageView:_logoView];
    
}

/**
 *  开始播放动画
 */
- (void)runAnimationWithImageView:(UIImageView *)imageView
{
    //如果当前有动画正在执行,就不再开始动画
    if (imageView.isAnimating) {
        return;
    }
    
    //计算
    NSInteger animationCount = 6;
    
    //创建可变数组
    NSMutableArray *images = [NSMutableArray array];
    
    //往数组中添加图片
    for (int index = 0; index < animationCount; index++) {
        //拼接图片名称
        NSString *imageName = [NSString stringWithFormat:@"login_%02d",index];
        
        //路径
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName] ;
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [images addObject:image];
    }
    //  把图片赋值给imageView动画数组【帧动画】
    imageView.animationImages = images;
    
    //  整个动画播放一圈的时间
    imageView.animationDuration = animationCount * 0.5;
    
    //  动画的重复次数
    imageView.animationRepeatCount = 100;
    
    //  开始播放动画
    [imageView startAnimating];
    
//    //在动画执行结束0.1秒后清空animationImages
//    CGFloat delay = imageView.animationDuration + 0.1;
//    [self performSelector:@selector(clearImagesWithSender:) withObject:imageView afterDelay:delay];
}

/**
 *  清空动画图片
 */
- (void)clearImagesWithSender:(UIImageView *)sender
{
    sender.animationImages = nil;
}


#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //top enterprise logo
    UIImageView *logoView = [TJUICreator createImageViewWithName:@"logo"
                                                size:TJAutoSizeMake(86, 86)
                                              radius:10];
    _logoView = logoView;
    [self.view addSubview:_logoView];
    
    //identifier of TuiJi
    UILabel *identifierView = [TJUICreator createLabelWithSize:TJAutoSizeMake(86, 20)
                                                          text:@""//Tui Ji.com
                                                         color:TJColorGrayFontDark
                                                          font:TJFontWithSize(15)];
    identifierView.textAlignment = NSTextAlignmentCenter;
    identifierView.backgroundColor = TJColorGrayBg;
    _identifierView = identifierView;
    [self.view addSubview:_identifierView];
    
    //account View
    TJInPutView *accountView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                               Type:TJInPutViewTypeAccount];
    _accountView = accountView;
    [self.view addSubview:_accountView];
    
    //password view
    TJInPutView *pwdView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                               Type:TJInPutViewTypePassword];
    _pwdView = pwdView;
    [self.view addSubview:_pwdView];
    
    //sign_in button
    UIButton *sign_inView = [TJUICreator createButtonWithSize:TJAutoSizeMake(315, 55)
                                                  NormalImage:@"signinB"
                                             highlightedImage:@"signinB_h"
                                                       target:self
                                                       action:@selector(signInBtnClick:)];
    _sign_inView = sign_inView;
    [self.view addSubview:_sign_inView];
    
    //password forgot button
    UIButton *pwdForgotView = [TJUICreator createButtonWithTitle:@"忘记密码  "
                                                            size:TJAutoSizeMake(80, 20)
                                                      titleColor:TJColorGrayFontLight
                                                            font:TJFontWithSize(15)
                                                          target:self
                                                          action:@selector(pwdForgotBtnClick:)];
    _pwdForgotView = pwdForgotView;
    [self.view addSubview:_pwdForgotView];
    
    //sign up button
    UIButton *sign_upView = [TJUICreator createButtonWithTitle:@"注册"
                                                          size:TJAutoSizeMake(46, 22)
                                                    titleColor:TJColorGrayFontLight
                                                          font:TJFontWithSize(15)
                                                        target:self
                                                        action:@selector(signUpBtnClick:)];
    _sign_upView = sign_upView;
    [self.view addSubview:sign_upView];
    
    //enterprise description
    UILabel *descriptionView = [TJUICreator createLabelWithSize:TJAutoSizeMake(self.view.width, 17)
                                                           text:@"Copyright©2016-2017 TUIJI, Inc. All rights reserved"
                                                          color:TJColorBlackFont
                                                           font:TJFontWithSize(10)];
    descriptionView.textAlignment = NSTextAlignmentCenter;
    descriptionView.backgroundColor = TJColorGrayBg;
    _descriptionView = descriptionView;
    [self.view addSubview:descriptionView];
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_logoView atTheTopMiddleOfTheView:self.view offset:TJSizeWithHeight(77)];
    [TJAutoLayoutor layView:_identifierView belowTheView:_logoView span:TJSizeWithHeight(2)];
    [TJAutoLayoutor layView:_pwdView atCenterOfTheView:self.view offset:TJSizeWithHeight(38)];
    [TJAutoLayoutor layView:_accountView aboveTheView:_pwdView span:TJSizeWithHeight(12)];
    [TJAutoLayoutor layView:_sign_inView belowTheView:_pwdView span:TJSizeWithHeight(48)];
    [TJAutoLayoutor layView:_pwdForgotView belowTheView:_pwdView span:TJSizeWithHeight(125) alignmentType:AlignmentRight];
    [TJAutoLayoutor layView:_sign_upView belowTheView:_sign_inView span:TJSizeWithHeight(45)];
    [TJAutoLayoutor layView:_descriptionView atTheBottomMiddleOfTheView:self.view offset:CGSizeZero];
}

/**
 *  sign in button clicked
 */
- (void)signInBtnClick:(id)sender
{
    //end edit
    [self.view endEditing:YES];
    //提示正在登录
    [TJRemindTool showMessage:@"正在登录中..."];
    
    [TJAccountTool loginWithAccount:_accountView.text
                           password:[_pwdView.text nim_MD5String]
                               Type:TJAccountToolTypeSignIn
                            success:^{
//                                //登录网易云信
//                                [[[NIMSDK sharedSDK] loginManager] login:TJAccountCurrent.userId
//                                                                   token:TJAccountCurrent.token
//                                                              completion:^(NSError * _Nullable error) {
//                                                                  [TJRemindTool hideHUD];
//                                                                  if (!error) {
//                                                                      
//
//                                                                  }
//                                                                  
//                                }];
                                
                                //创建当前用户文件夹
                                [TJDataCenter createUserInfoFolder];
                                [TJRemindTool showMessage:@"正在初始化数据..."];
                                //初始化用户资料
                                [TJAccountTool loadBaseUserData];
                                
                            } failure:^{}];
    
}

/**
 *  pwdForgot btn clicked
 */
- (void)pwdForgotBtnClick:(id)sender
{
    TJPwdForgotViewController *pwdForgotVC = [[TJPwdForgotViewController alloc] init];
    [self.navigationController pushViewController:pwdForgotVC animated:YES];
}

/**
 *  sign up button clicked
 */
- (void)signUpBtnClick:(id)sender
{
    TJSignUpViewController *signUpVC = [[TJSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

@end
