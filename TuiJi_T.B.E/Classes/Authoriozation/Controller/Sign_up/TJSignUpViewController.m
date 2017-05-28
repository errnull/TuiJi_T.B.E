//
//  TJSignUpViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSignUpViewController.h"
#import "TJInPutView.h"
#import "TJAgreeView.h"
#import "TJInformationViewController.h"
#import "TJSignParam.h"
#import "TJAccount.h"
#import "TJURLList.h"
#import "TJVerityButton.h"

#import "NSString+NIM.h"

@interface TJSignUpViewController ()

/**
 *  top enterprise logo of TuiJi
 */
@property (nonatomic, weak) UIImageView *logoView;

/**
 *  account InPutView(UIView) contains  left imageView  textView  and a bottom line
 */
@property (nonatomic, weak) TJInPutView *accountView;

/**
 *  verification InPutView(UIView) contains  left imageView  textView  and a bottom line
 */
@property (nonatomic, weak) TJInPutView *verificationView;

/**
 *  password InPutView(UIView) contains  left imageView  textView  and a bottom line
 */
@property (nonatomic, weak) TJInPutView *pwdView;

/**
 *  sign up button
 */
@property (nonatomic, weak) UIButton *sign_upView;

/**
 *  agree view contatns agree button and description label
 */
@property (nonatomic, weak) TJAgreeView *agreeView;

@end

@implementation TJSignUpViewController

static NSString *_messageCode;

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
    
    //account View
    TJInPutView *accountView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                               Type:TJInPutViewTypeAccount];
    _accountView = accountView;
    [self.view addSubview:_accountView];
    
    //verification view
    TJInPutView *verificationView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                                    Type:TJInPutViewTypeVerification];
    
    verificationView.target = self;

    
    _verificationView = verificationView;
    [self.view addSubview:_verificationView];
    
    //password view
    TJInPutView *pwdView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                           Type:TJInPutViewTypePassword];
    _pwdView = pwdView;
    [self.view addSubview:_pwdView];
    
     //sign up button
    UIButton *sign_upView = [TJUICreator createButtonWithSize:TJAutoSizeMake(315, 50)
                                                  NormalImage:@"signupB"
                                             highlightedImage:@"signupB_h"
                                                       target:self
                                                       action:@selector(signUpBtnClick:)];
    _sign_upView = sign_upView;
    [self.view addSubview:sign_upView];
    
    //agreeView
    TJAgreeView *agreeView = [TJUICreator createAgreeViewWithSize:CGSizeMake(182, 20)
                                                           target:self
                                                           action:@selector(showAgreeMent)];
    agreeView.backgroundColor = TJColorGrayBg;
    _agreeView = agreeView;
    [self.view addSubview:_agreeView];
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{

    [TJAutoLayoutor layView:_logoView atTheTopMiddleOfTheView:self.view offset:TJSizeWithHeight(77)];
    [TJAutoLayoutor layView:_pwdView atCenterOfTheView:self.view offset:TJSizeWithHeight(-21)];
    [TJAutoLayoutor layView:_verificationView aboveTheView:_pwdView span:TJSizeWithHeight(12)];
    [TJAutoLayoutor layView:_accountView aboveTheView:_verificationView span:TJSizeWithHeight(12)];
    [TJAutoLayoutor layView:_sign_upView belowTheView:_pwdView span:TJSizeWithHeight(10)];
    
    [TJAutoLayoutor layView:_agreeView atTheBottomMiddleOfTheView:self.view offset:CGSizeZero];
}

/**
 *  获取验证码
 */
- (void)getVerificationCode
{
    //end edit
    [self.view endEditing:YES];
    
    //正则匹配当前手机号码格式
    if (![_accountView.text validateMobileNumber]) {
        [TJRemindTool showError:@"手机号码格式不正确."];
        return;
    }
    
    //格式正确的手机号码
    TJSignParam *messageCodeParam = [[TJSignParam alloc] init];
    messageCodeParam.username = self.accountView.text;
    
    [TJHttpTool POST:TJUrlList.getMessageCode
          parameters:messageCodeParam.mj_keyValues
             success:^(id responseObject) {
                 TJAccount *account = [TJAccount mj_objectWithKeyValues:responseObject];
                 
                 if ([account.messageCode isEqualToString:@"-1"]) {
                     [TJRemindTool showError:@"该号码已被注册."];
                 }else{
                     _messageCode = account.messageCode;
                     //开始动画
                     [_verificationView.rightView startLoading];
                 }
             } failure:^(NSError *error) {}];
}

/**
 *  sign up button clicked
 */
- (void)signUpBtnClick:(id)sender
{
    //end edit
    [self.view endEditing:YES];
    
    //判断验证码是否正确
    if (![_messageCode isEqualToString:_verificationView.text]) {
        //验证码不正确
        [TJRemindTool showError:@"验证码不正确."];
        return;
    }
    [TJRemindTool showMessage:@""];
    //验证码正确
    [TJAccountTool loginWithAccount:self.accountView.text
                           password:[self.pwdView.text nim_MD5String]
                               Type:TJAccountToolTypeSignUp
                            success:^{
                                [TJAccountTool loginWithAccount:self.accountView.text
                                                       password:[self.pwdView.text nim_MD5String]
                                                           Type:TJAccountToolTypeSignIn
                                                        success:^{
                                                            
                                                            //登录网易云信
                                                            [[[NIMSDK sharedSDK] loginManager] login:TJAccountCurrent.userId
                                                                                               token:TJAccountCurrent.token
                                                                                          completion:^(NSError * _Nullable error) {
                                                                                              //保存注册状态码
                                                                                              TJAccount *account = TJAccountCurrent;
                                                                                              account.code = TJStatusUserNeedSetUpInfo;
                                                                                              [TJAccountTool saveAccount:account];
                                                                                              
                                                                                              //创建当前用户文件夹
                                                                                              [TJDataCenter createUserInfoFolder];
                                                                                              //登陆云信成功时切换控制器
                                                                                              [TJGuideTool guideRootViewController:TJKeyWindow];
                                                                                              
                                                                                              [TJRemindTool hideHUD];
                                                                                          }];
                                                        } failure:^{}];
                            } failure:^{}];
}

- (void)showAgreeMent
{
    UIViewController *vc = [[UIViewController alloc] init];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tuiji.net"]]];
    webView.backgroundColor = TJColorGrayBg;
    vc.view = webView;
    
    [self.navigationController showViewController:vc sender:nil];
}
@end
