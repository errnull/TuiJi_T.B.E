//
//  TJPwdForgotViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPwdForgotViewController.h"
#import "TJAnimTextField.h"
#import "TJInPutView.h"

@interface TJPwdForgotViewController ()

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
 *  confirm button
 */
@property (nonatomic, weak) UIButton *confirmView;

/**
 *  enterprise description
 */
@property (nonatomic, weak) UILabel *descriptionView;

@end

@implementation TJPwdForgotViewController


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
    _verificationView = verificationView;
    [self.view addSubview:_verificationView];
    
    //password view
    TJInPutView *pwdView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(315, 55)
                                                           Type:TJInPutViewTypePassword];
    _pwdView = pwdView;
    [self.view addSubview:_pwdView];
    
    //sign up button
    UIButton *confirmView = [TJUICreator createButtonWithSize:TJAutoSizeMake(315, 50)
                                                  NormalImage:@"confirmB"
                                             highlightedImage:@"confirmB_h"
                                                       target:self
                                                       action:@selector(confirmBtnClick:)];
    _confirmView = confirmView;
    [self.view addSubview:_confirmView];
    
    //enterprise description
    UILabel *descriptionView = [TJUICreator createLabelWithSize:TJAutoSizeMake(self.view.width, 17)
                                                           text:@"Copyright©2016-2017 TUIJI, Inc. All rights reserved"
                                                          color:TJColorBlackFont
                                                           font:TJFontWithSize(10)];
    descriptionView.backgroundColor = TJColorGrayBg;
    descriptionView.textAlignment = NSTextAlignmentCenter;
    _descriptionView = descriptionView;
    [self.view addSubview:descriptionView];
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
    [TJAutoLayoutor layView:_confirmView belowTheView:_pwdView span:TJSizeWithHeight(10)];
    
    [TJAutoLayoutor layView:_descriptionView atTheBottomMiddleOfTheView:self.view offset:CGSizeZero];
}

/**
 *  confirm button clicked
 */
- (void)confirmBtnClick:(id)sender
{
    //end edit
    [self.view endEditing:YES];
    
    [TJHttpTool GET:@"http://ybin.ngrok.cc/api/personal/getToken?phone=10086&msgcode=8888"
         parameters:@{}
            success:^(id responseObject) {
                NSLog(@"asdada");
                
            } failure:^(NSError *error) {
                
            }];
    

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [TJHttpTool GET:@"http://ybin.ngrok.cc/api/personal/forgotPW?phone=10086&token=sfsdfsdfasdf"
         parameters:@{}
            success:^(id responseObject) {
                
                NSLog(@"asdada");
                
            } failure:^(NSError *error) {
                
            }];
    
}

@end
