//
//  TJUserSettingTVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserSettingTVC.h"

#import "TJUserInfo.h"

#import "TJUserCollectionTVC.h"

#import "TJUserFeedBackVC.h"

#import "TJAccount.h"

@interface TJUserSettingTVC ()

@property (nonatomic, weak) UIButton *signoutView;
@property (weak, nonatomic) IBOutlet UISwitch *themeChangeView;

- (IBAction)changeTheme:(UISwitch *)sender;

@end

@implementation TJUserSettingTVC

+ (instancetype)userSettingTVC{
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJEditUserInfo" bundle:nil];
    
    TJUserSettingTVC *setting = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJUserSettingTVC class])];
    
    return setting;
}

/**
 *  将状态栏字体颜色变为黑色
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_themeChangeView setOn:[TJUserInfoCurrent.background intValue]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    [self setUpSignoutView];
    
    self.tableView.backgroundColor = TJColorGrayBg;
}

- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"账户设置"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
}

- (void)setUpSignoutView
{
    UIView *footerView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 61)
                                                 bgColor:TJColorGrayBg
                                                  radius:0];
    
    UIButton *signoutView = [TJUICreator createButtonWithTitle:@"退出登录"
                                                          size:CGSizeMake(TJWidthDevice - 38, 61 - 12)
                                                    titleColor:TJColorWhite
                                                          font:TJFontWithSize(18)
                                                        target:self
                                                        action:@selector(signoutViewDidClick:)];
    
    [signoutView setBackgroundColor:TJColorDeleteView];
    signoutView.layer.cornerRadius = 24;
    signoutView.layer.masksToBounds = YES;
    
    _signoutView = signoutView;
    [TJAutoLayoutor layView:_signoutView atTheView:footerView margins:UIEdgeInsetsMake(6, 19, 6, 19)];
    self.tableView.tableFooterView = footerView;
}

- (void)signoutViewDidClick:(UIButton *)sender
{
    //重新登录
    [TJAccountTool deleteAccountData];
    
    //清空全部旧资料
    [TJDataCenter deleteAllData];
    
    [TJGuideTool guideRootViewController:TJKeyWindow];
}

- (IBAction)changeTheme:(UISwitch *)sender {
    [TJRemindTool showMessage:@""];
    
//    //修改用户资料
//    [TJUserInfoTool modifyUserInfoWithParam:@{@"background":[NSString stringWithFormat:@"%d",sender.isOn]}
//                                    Success:^{
//                                        
//                                        [TJGuideTool guideRootViewController:TJKeyWindow];
//                                        
//                                        [TJRemindTool hideHUD];
//                                        
//                                    } failure:^(NSError *error) {
//                                        [TJRemindTool showError:@"请检查当前网络."];
//                                    }];

    TJAccount *account = TJAccountCurrent;
    
    account.token = [NSString stringWithFormat:@"%d",sender.isOn];
    
    [TJGuideTool guideRootViewController:TJKeyWindow];
    
    [TJRemindTool hideHUD];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TJUserCollectionTVC *userCollectionTVC = [[TJUserCollectionTVC alloc] init];
            
            [self.navigationController pushViewController:userCollectionTVC animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            TJUserFeedBackVC *userFeedBackVC = [TJUserFeedBackVC userFeedBackWithContact:nil];
            
            [self.navigationController pushViewController:userFeedBackVC animated:YES];
        }
    }
}
@end
