//
//  TJUserFeedBackVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserFeedBackVC.h"
#import "TJContact.h"

TJContact *_currentContact;
@interface TJUserFeedBackVC ()
@property (weak, nonatomic) IBOutlet UILabel *showView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TJUserFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    self.view.backgroundColor = TJColorGrayBg;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)setupNavigationBar
{
    NSString *titleStr = @"帮助中心";
    NSString *showStr = @"你可以将意见反馈给推己客服.";

    if (_currentContact) {
        titleStr = @"投诉";
        showStr = [NSString stringWithFormat:@"你可以将对%@的投诉反馈给客服",_currentContact.remark];
    }
    
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                 text:titleStr
                                            textColor:[UIColor blackColor]
                                          sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *rightBtn = [TJUICreator createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                          text:@"提交"
                                                          font:[UIFont systemFontOfSize:14]
                                                         color:[UIColor blackColor]
                                                        target:self
                                                        action:@selector(finishClick)
                                              forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;

    [self.showView setText:showStr];
    

}

- (void)finishClick
{
    [self.view endEditing:YES];
}

+ (instancetype)userFeedBackWithContact:(TJContact *)contact{
    
    _currentContact = contact;
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJChat" bundle:nil];
    //获取初始化箭头所指controller
    TJUserFeedBackVC *userFeedBackVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJUserFeedBackVC class])];
    
    return userFeedBackVC;
    
    
}
@end
