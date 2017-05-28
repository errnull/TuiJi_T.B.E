//
//  TJSignInNavController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSignInNavController.h"
#import "TJAreaSelectedTVC.h"


@implementation TJSignInNavController

@synthesize alphaView;

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        
        
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
        
        alphaView.alpha = 0.0;
    }
    return self;
}

/**
 *  set up back button
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //set up the contents of fault root navigation bar
    if (self.viewControllers.count != 0) {
        //右边按钮
        UIButton *backButton = [TJUICreator createButtonWithSize:CGSizeMake(24, 34)
                                                     NormalImage:@"login_backBtn"
                                                highlightedImage:@"login_backBtn_h"
                                                          target:self
                                                          action:@selector(back)];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 6, 8, 6);
        
        //左边按钮
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.navigationItem.leftBarButtonItem = leftBarItem;
        
        
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


/**
 *  close keyboard when needed
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

/**
 *  每次触发手势之前调用此方法 拦截手势触发
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    // 判断导航控制器是否只有一个子控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}


@end
