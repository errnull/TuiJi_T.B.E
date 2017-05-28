//
//  TJContactAddFriendVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactAddFriendVC.h"
#import "TJPersonalInfoView.h"
#import "TJSearchBar.h"
#import "TJSearchController.h"
#import "TJContactSearchResultController.h"
#import "TJPersonalCardViewController.h"
#import "TJNewUserInfoCard.h"
#import "TJAccount.h"
#import "TJUserInfo.h"
#import "TJURLList.h"

@interface TJContactAddFriendVC ()<UISearchBarDelegate>

/**
 *  好友搜索框
 */
@property (nonatomic, strong) UISearchBar *friendSearchView;
/**
 *  推己号
 */
@property (nonatomic, weak) UILabel *tuijiView;
/**
 *  个人资料框
 */
@property (nonatomic, weak) TJPersonalInfoView *personalInfoView;


@end

@implementation TJContactAddFriendVC

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

- (void)viewDidLoad{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"添加朋友"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:18];
    
    self.navigationItem.titleView = titleView;
    
    self.friendSearchView.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.friendSearchView endEditing:YES];
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    UISearchBar *friendSearchView = [[UISearchBar alloc] init];
    //好友搜索框
    
    friendSearchView.frame = TJRectFromSize(CGSizeMake(TJWidthDevice, 44));
    
    
    friendSearchView.placeholder = @"通过手机号/推己号查找";
    _friendSearchView = friendSearchView;
    
    
    for (UIView *view in self.friendSearchView.subviews) {
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    _friendSearchView.barTintColor = [UIColor yellowColor];
    [self.view addSubview:_friendSearchView];
    
    //推己号
    UILabel *tuijiView = [TJUICreator createLabelWithSize:CGSizeMake(140, 20)
                                                     text:[NSString stringWithFormat:@"TuiJi%@",TJUserInfoCurrent.uUsername]
                                                    color:TJColorGrayFontDark
                                                     font:TJFontWithSize(14)];
    [tuijiView sizeToFit];
    tuijiView.backgroundColor = TJColorGrayBg;
    _tuijiView = tuijiView;
    [self.view addSubview:_tuijiView];
    
    //个人资料框
    TJPersonalInfoView *personalInfoView = [[TJPersonalInfoView alloc] initWithSize:TJAutoSizeMake(326, 435)];
    personalInfoView.layer.cornerRadius = 4;
    _personalInfoView = personalInfoView;
    [self.view addSubview:_personalInfoView];
    
}



/**
 *  Layout all sub views
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_friendSearchView atTheTopMiddleOfTheView:self.view offset:CGSizeZero];
    [TJAutoLayoutor layView:_tuijiView belowTheView:_friendSearchView span:CGSizeZero];
    [TJAutoLayoutor layView:_personalInfoView atCenterOfTheView:self.view offset:TJSizeWithHeight(-18)];
}

#pragma  mark - UISearchBar Delegate
/**
 *  监听查找按钮
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    
    //通过账户查找用户
    NSString *URLStr = [TJUrlList.getUserInfoWithNumber stringByAppendingString:TJAccountCurrent.jsessionid];
    
    //通过号码请求用户资料
    [TJHttpTool POST:URLStr
          parameters:@{@"number":searchBar.text}
             success:^(id responseObject) {
                 TJNewUserInfoCard *newUserInfoCard = [TJNewUserInfoCard mj_objectWithKeyValues:responseObject];
                 if ([newUserInfoCard.code isEqualToString:TJStatusSussess]) {
                     TJPersonalCardViewController *personalCardVC = [[TJPersonalCardViewController alloc] init];
                     personalCardVC.userInfo = newUserInfoCard;
                     
                     [self.navigationController pushViewController:personalCardVC animated:YES];
                 }else{
                     [TJRemindTool showError:@"该用户不存在耶..."];
                 }
                 
                 
             } failure:^(NSError *error) {}];


}

@end
