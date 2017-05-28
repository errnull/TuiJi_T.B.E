//
//  TJChatVideoShowVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJChatVideoShowVC.h"

#import "CKAlertViewController.h"

@interface TJChatVideoShowVC ()

@end

@implementation TJChatVideoShowVC

+ (instancetype)chatVideoShowVC{
    
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJChat" bundle:nil];
    //获取初始化箭头所指controller
    TJChatVideoShowVC *chatVideoShowVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJChatVideoShowVC class])];
    
    return chatVideoShowVC;
    
    return nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(showWaitting) withObject:nil afterDelay:0.5];
}

- (void)showWaitting
{
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"" message:@"敬请期待."];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
        
    }];

    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}
@end
