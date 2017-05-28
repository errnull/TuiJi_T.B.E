//
//  HMScannerViewController.m
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMScannerViewController.h"
#import "HMScanerCardViewController.h"
#import "HMScannerBorder.h"
#import "HMScannerMaskView.h"
#import "HMScanner.h"

/// 控件间距
#define kControlMargin  32.0

@interface HMScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/// 名片字符串
@property (nonatomic) NSString *cardName;
/// 头像图片
@property (nonatomic) UIImage *avatar;
/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(NSString *);
@end

@implementation HMScannerViewController {
    /// 扫描框
    HMScannerBorder *scannerBorder;
    /// 扫描器
    HMScanner *scanner;
    /// 提示标签
    UILabel *tipLabel;
}

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        self.cardName = cardName;
        self.avatar = avatar;
        self.completionCallBack = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    scanner = [HMScanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *stringValue) {
        // 完成回调
        weakSelf.completionCallBack(stringValue);
        
        // 关闭
        [weakSelf clickCloseButton];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

#pragma mark - 监听方法
/// 点击关闭按钮
- (void)clickCloseButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 点击相册按钮
- (void)clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        tipLabel.text = @"无法访问相册";
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    
    [self showDetailViewController:picker sender:nil];
}

/// 点击名片按钮
- (void)clickCardButton {
    HMScanerCardViewController *vc = [[HMScanerCardViewController alloc] initWithCardName:self.cardName avatar:self.avatar];
    
    [self showViewController:vc sender:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 扫描图像
    [HMScanner scaneImage:info[UIImagePickerControllerOriginalImage] completion:^(NSArray *values) {
        
        if (values.count > 0) {
            self.completionCallBack(values.firstObject);
            [self dismissViewControllerAnimated:NO completion:^{
                [self clickCloseButton];
            }];
        } else {
            tipLabel.text = @"没有识别到二维码，请选择其他照片";
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - 设置界面
- (void)prepareUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareNavigationBar];
    [self prepareScanerBorder];
    [self prepareOtherControls];
}

/// 准备提示标签和名片按钮
- (void)prepareOtherControls {
    
    // 1> 提示标签
    tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
    
//    // 2> 名片按钮
//    UIButton *cardButton = [[UIButton alloc] init];
//    
//    [cardButton setTitle:@"我的名片" forState:UIControlStateNormal];
//    cardButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cardButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
//    
//    [cardButton sizeToFit];
//    cardButton.center = CGPointMake(tipLabel.center.x, CGRectGetMaxY(tipLabel.frame) + kControlMargin);
//    
//    [self.view addSubview:cardButton];
//    
//    [cardButton addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat width = self.view.bounds.size.width - 80;
    scannerBorder = [[HMScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    scannerBorder.center = self.view.center;
    
    [self.view addSubview:scannerBorder];
    
    HMScannerMaskView *maskView = [HMScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}

/// 准备导航栏
- (void)prepareNavigationBar {
    
    UIView *titleView = [self createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"扫一扫"
                                                   textColor:[UIColor blackColor]
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *barButtonItem = [self createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                     Image:@"navigationbar_back_black"
                                                                 highImage:@"navigationbar_back_black_highlighted"
                                                                    target:self
                                                                    action:@selector(clickCloseButton)
                                                          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    UIBarButtonItem *rightBtn = [self createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                                 text:@"相册"
                                                                 font:[UIFont systemFontOfSize:14]
                                                                color:[UIColor blackColor]
                                                               target:self
                                                               action:@selector(clickAlbumButton)
                                                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;

}

- (UIView *)createTitleViewWithSize:(CGSize)size
                               text:(NSString *)text
                          textColor:(UIColor *)color
                        sysFontSize:(int)fontSize
{
    UIButton *titleView = [self createButtonWithTitle:text
                                                        size:size
                                                  titleColor:color
                                                        font:[UIFont systemFontOfSize:fontSize]
                                                      target:nil action:nil];
//    titleView.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    
    titleView.userInteractionEnabled = NO;
    titleView.backgroundColor = [UIColor clearColor];
    
    [titleView sizeToFit];
    
    return titleView;
}

//For UIButton
- (UIButton *)createButtonWithTitle:(NSString *)title
                               size:(CGSize)size
                         titleColor:(UIColor *)titleColor
                               font:(UIFont *)font
                             target:(id)target
                             action:(SEL)action
{
    return [self createButtonWithTitle:title
                                  size:(CGSize)size
                            titleColor:titleColor
                                  font:font
                            buttonType:UIButtonTypeCustom
                               bgColor:nil
                                corner:0
                                target:target
                                action:action];
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                               size:(CGSize)size
                         titleColor:(UIColor *)titleColor
                               font:(UIFont *)font
                         buttonType:(UIButtonType)buttonType
                            bgColor:(UIColor *)bgColor
                             corner:(float)cornerRadius
                             target:(id)target
                             action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.frame = (CGRect){{0,0},size};
    [button setTitle:title forState:UIControlStateNormal];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (bgColor) {
        button.backgroundColor = bgColor;
    }
    if (cornerRadius > 0) {
        button.layer.cornerRadius = cornerRadius;
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//UIBarButtonItem
- (UIBarButtonItem *)createBarBtnItemWithSize:(CGSize)size
                                        Image:(NSString *)image
                                    highImage:(NSString *)highImage
                                       target:(id)target
                                       action:(SEL)action
                             forControlEvents:(UIControlEvents)controlEvents
{
    // btn
    UIButton *btn = [[UIButton alloc] initWithFrame:(CGRect){{0,0},size}];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

//UIBarButtonItem
- (UIBarButtonItem *)createBarBtnItemWithSize:(CGSize)size
                                         text:(NSString *)text
                                         font:(UIFont *)font
                                        color:(UIColor *)color
                                       target:(id)target
                                       action:(SEL)action
                             forControlEvents:(UIControlEvents)controlEvents
{
    // btn
    UIButton *btn = [[UIButton alloc] initWithFrame:(CGRect){{0,0},size}];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
