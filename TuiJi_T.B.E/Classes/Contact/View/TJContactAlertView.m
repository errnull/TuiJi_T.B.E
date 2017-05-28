//
//  TJContactAlertView.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactAlertView.h"
#import <Accelerate/Accelerate.h>

#import "TJContact.h"
#import "TJKeyValueTextLabel.h"
#import "TJRegionView.h"



#define JCiOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

@class JCViewController;

@interface TJContactAlertView ()


@property (nonatomic, weak) JCViewController *vc;
@property (nonatomic, strong) UIImageView *screenShotView;

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameView;

/**
 *  地区
 */
@property (nonatomic, weak) TJRegionView *regionView;

/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexView;

/**
 *  推己号
 */
@property (nonatomic, weak) TJKeyValueTextLabel *tuijiView;


- (IBAction)talkViewClick:(UIButton *)sender;
- (IBAction)sendViewClick:(UIButton *)sender;
- (IBAction)personalViewClick:(UIButton *)sender;
- (IBAction)videoViewClick:(UIButton *)sender;
- (IBAction)settingViewClick:(UIButton *)sender;


@end

@interface jCSingleTon : NSObject

@property (nonatomic, strong) UIWindow *backgroundWindow;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) NSMutableArray *alertStack;
@property (nonatomic, strong) TJContactAlertView *previousAlert;

@end

@implementation jCSingleTon

+ (instancetype)shareSingleTon{
    static jCSingleTon *shareSingleTonInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSingleTonInstance = [jCSingleTon new];
    });
    return shareSingleTonInstance;
}

- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _backgroundWindow;
}

- (NSMutableArray *)alertStack{
    if (!_alertStack) {
        _alertStack = [NSMutableArray array];
    }
    return _alertStack;
}

@end

@interface JCViewController : UIViewController

@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, weak) TJContactAlertView *alertView;

@end

@implementation JCViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
     [self.alertView dismissAlert];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addScreenShot];
    [self addCoverView];
    [self addAlertView];
}

- (void)addScreenShot{
    UIWindow *screenWindow = [UIApplication sharedApplication].windows.firstObject;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = nil;
    if (JCiOS7OrLater) {
        originalImage = viewImage;
    } else {
        originalImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460))];
    }

    UIImage *blurImage = [UIImage boxblurImage:originalImage withBlurNumber:3];
    
    self.screenShotView = [[UIImageView alloc] initWithImage:blurImage];
    
    [self.view addSubview:self.screenShotView];
}

- (void)addCoverView{
    self.coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.backgroundColor = TJColorSingalp(200, 0.6);
    [self.view addSubview:self.coverView];
}

- (void)addAlertView{
    [self.view addSubview:self.alertView];
}

- (void)showAlert{
    CGFloat duration = 0.3;
    
    for (UIButton *btn in self.alertView.subviews) {
        btn.userInteractionEnabled = NO;
    }
    
    self.screenShotView.alpha = 0;
    self.coverView.alpha = 0;
    self.alertView.alpha = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.screenShotView.alpha = 1;
        self.coverView.alpha = 0.65;
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        for (UIButton *btn in self.alertView.subviews) {
            btn.userInteractionEnabled = YES;
        }
    }];
    
    if (JCiOS7OrLater) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
        animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        animation.duration = duration;
        [self.alertView.layer addAnimation:animation forKey:@"bouce"];
    } else {
        self.alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:duration * 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration * 0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration * 0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
            }];
        }];
    }
}

- (void)hideAlertWithCompletion:(void(^)(void))completion{
    CGFloat duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.alpha = 0;
        self.screenShotView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.screenShotView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:nil];
}

@end

@implementation TJContactAlertView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _regionView.gjcf_centerY = _sexView.gjcf_centerY;
    _regionView.gjcf_left = _sexView.gjcf_right + 12;
    
    _tuijiView.gjcf_left = _nickNameView.gjcf_left;
    _tuijiView.gjcf_top = _sexView.gjcf_bottom + 6;
}

- (void)setContact:(TJContact *)contact{
    _contact = contact;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_contact.headImage]];
    [_nickNameView setText:_contact.remark];
    
    TJRegionView *regionView = [TJUICreator createRegionViewWithRegionStr:[_contact.region isEqualToString:@"null"] ? nil : contact.region
                                                                     font:TJFontWithSize(12)];
    _regionView = regionView;
    [self addSubview:_regionView];
    
    NSString *sex = (_contact.sex = NIMUserGenderMale) ? @"man_h" : @"woman_h";
    [_sexView setImage:[UIImage imageNamed:sex]];
    
    TJKeyValueTextLabel *tuijiView = [TJUICreator createKeyValueTextLabelWithSize:CGSizeMake(150, 20)
                                                                          textKey:@"推己号: "
                                                                        textValue:_contact.username
                                                                         keyColor:TJColorGrayFontLight
                                                                       valueColor:TJColorBlackFont
                                                                          keyFont:TJFontWithSize(13)
                                                                        valueFont:TJFontWithSize(14)];
    _tuijiView = tuijiView;
    [self addSubview:_tuijiView];
    
    self.layer.shadowOffset = CGSizeMake(5, 10);
    self.layer.shadowOpacity = 0.05;
}

+ (instancetype)contactAlertView{
    
    TJContactAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJContactAlertView class]) owner:nil options:nil] firstObject];

    CGFloat alertW = TJWidthDevice - 24;
    
    alertView.frame = CGRectMake(0, 0, alertW, alertW * 0.6);
    
    alertView.center = CGPointMake(TJWidthDevice / 2, TJHeightDevice / 2);
    alertView.backgroundColor = TJColorGrayBg;
    
    alertView.layer.cornerRadius = 20;
    
    alertView.iconView.layer.cornerRadius = 12;
    alertView.iconView.layer.masksToBounds = YES;
    
    return alertView;
    
}

- (void)alertShow{
    [jCSingleTon shareSingleTon].oldKeyWindow = TJKeyWindow;
    
    JCViewController *vc = [[JCViewController alloc] init];
    vc.alertView = self;
    self.vc = vc;
    
    [jCSingleTon shareSingleTon].backgroundWindow.frame = [UIScreen mainScreen].bounds;
    [[jCSingleTon shareSingleTon].backgroundWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = self.vc;
    
    [self.vc showAlert];
    
    [jCSingleTon shareSingleTon].previousAlert = self;
}

- (void)dismissAlert{
    [self.vc hideAlertWithCompletion:^{
        [self stackHandle];
    }];
}

- (void)stackHandle{
    [[jCSingleTon shareSingleTon].alertStack removeObject:self];
    TJContactAlertView *lastAlert = [jCSingleTon shareSingleTon].alertStack.lastObject;
    [jCSingleTon shareSingleTon].previousAlert = nil;
    if (lastAlert) {
        [lastAlert alertShow];
    } else {
        [self toggleKeyWindow];
    }
}

- (void)toggleKeyWindow{
    [[jCSingleTon shareSingleTon].oldKeyWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = nil;
    [jCSingleTon shareSingleTon].backgroundWindow.frame = CGRectZero;
}

- (IBAction)talkViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactAlertView:talkViewClick:)]) {
        [self.delegate contactAlertView:self talkViewClick:sender];
    }
    
}

- (IBAction)sendViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactAlertView:sendViewClick:)]) {
        [self.delegate contactAlertView:self sendViewClick:sender];
    }
}

- (IBAction)personalViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactAlertView:personalViewClick:)]) {
        [self.delegate contactAlertView:self personalViewClick:sender];
    }
}

- (IBAction)videoViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactAlertView:videoViewClick:)]) {
        [self.delegate contactAlertView:self videoViewClick:sender];
    }
}

- (IBAction)settingViewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactAlertView:settingViewClick:)]) {
        [self.delegate contactAlertView:self settingViewClick:sender];
    }
}
@end

