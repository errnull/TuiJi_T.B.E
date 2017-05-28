//
//  TJSendAddFriendRequestVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSendAddFriendRequestVC.h"
#import "TJAddFriendParam.h"
#import "TJAccount.h"
#import "TJURLList.h"

@interface TJSendAddFriendRequestVC ()

/**
 *  提示
 */
@property (nonatomic, weak) UILabel *tipView;

/**
 *  输入框
 */
@property (nonatomic, weak) UITextView *inputView;

@end

@implementation TJSendAddFriendRequestVC

#pragma mark - system method

/**
 *  init set up subViews
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = TJColorGrayBg;
        //创建所有子控件
        [self setUpAllSubViews];
        
        //设置导航条
        [self setUpNavigationBar];
        
        //自动布局
        [self layoutAllSubViews];
        
    }
    return self;
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //提示
    UILabel *tipView = [TJUICreator createLabelWithSize:CGSizeMake(TJWidthDevice, 20)
                                                 text:@"你需要发送验证申请,等对方回应"
                                                color:TJColorGray
                                                 font:TJFontWithSize(14)];
    tipView.backgroundColor = TJColorClear;
    [tipView sizeToFit];
    _tipView = tipView;
    [self.view addSubview:_tipView];
    
    //输入框
    UITextView *inputView = [[UITextView alloc] initWithFrame:TJRectFromSize(CGSizeMake(TJWidthDevice, 80))];
    inputView.font = TJTextFont;
    inputView.tintColor = TJColorGray;
    
    
    _inputView = inputView;
    [self.view addSubview:_inputView];
}

/**
 *  set up navigation bar
 */
- (void)setUpNavigationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"添加好友"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;

    UIButton *sendBtn = [TJUICreator createButtonWithTitle:@"发送"
                                                             size:CGSizeMake(100, 23)
                                                       titleColor:TJColorBlackFont
                                                             font:TJFontWithSize(16)
                                                           target:self
                                                           action:@selector(sendBtnClick:)];
    [sendBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_tipView atTheLeftTopOfTheView:self.view offset:TJAutoSizeMake(16, 16)];
    [TJAutoLayoutor layView:_inputView atTheLeftTopOfTheView:self.view offset:TJSizeWithHeight(41)];
}



#pragma mark - private method
- (void)sendBtnClick:(UIButton *)sender
{
    [_inputView endEditing:YES];
    //发送请求
    TJAddFriendParam *addFriendParam = [[TJAddFriendParam alloc] init];
    addFriendParam.userID = TJAccountCurrent.userId;
    addFriendParam.friendID = self.aimUserID;
    addFriendParam.hintMessage = self.inputView.text;
    
    NSString *URLStr = [TJUrlList.sendAddFriendRequest stringByAppendingString:TJAccountCurrent.jsessionid];
    [TJHttpTool GET:URLStr
         parameters:addFriendParam.mj_keyValues
            success:^(id responseObject) {
                TJAddFriendParam *result = [TJAddFriendParam mj_objectWithKeyValues:[responseObject firstObject]];
                if ([result.code isEqualToString:TJStatusSussess]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [TJRemindTool showSuccess:@"发送成功."];
                }
            } failure:^(NSError *error) {}];
}
@end
