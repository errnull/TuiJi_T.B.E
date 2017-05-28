//
//  TJInformationViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJInformationViewController.h"
#import "TJInPutView.h"
#import "TJSexChooseView.h"
#import "TJAreaSelectedTVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "TJModifyUserInfoParam.h"
#import "TJSignParam.h"
#import "TJUPLoadParam.h"
#import "TJAccount.h"
#import "TJURLList.h"
#import "TJUpLoadResult.h"

#import "TJCameraController.h"
#import "TJSimpleImageFilterViewController.h"


@interface TJInformationViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, TJSimpleImageFilterDelegate>

/**
 *  返回按钮
 */
@property (nonatomic, weak) UIButton *backButton;

/**
 *  the icon view of customer
 */
@property (nonatomic, weak) UIButton *iconView;

/**
 *  the nick view of customer
 */
@property (nonatomic, weak) TJInPutView *nickView;

/**
 *  the sex view of customer
 */
@property (nonatomic, weak) TJSexChooseView *sexView;

/**
 *  the region choose view of customer
 */
@property (nonatomic, weak) UIButton *regionChooseView;

/**
 *  flag image view
 */
@property (nonatomic, weak) UIImageView *flagView;

/**
 *  the region result view of customer
 */
@property (nonatomic, weak) UIButton *regionRsultView;

/**
 *  confirm button
 */
@property (nonatomic, weak) UIButton *confirmView;


@end

@implementation TJInformationViewController


#pragma mark - system method
/**
 *  懒加载
 */
- (TJModifyUserInfoParam *)modifyUserInfoParam{
    if (!_modifyUserInfoParam) {
        _modifyUserInfoParam = [[TJModifyUserInfoParam alloc] init];
    }
    return _modifyUserInfoParam;
}

/**
 *  init set up subViews
 */
- (instancetype)init
{
    if (self = [super init]) {
        [self setUpAllSubViews];
        self.view.backgroundColor = TJColorGrayBg;
    }
    return self;
}

/**
 *  Layout all sub views
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutAllSubViews];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //左边按钮
    UIButton *backButton = [TJUICreator createButtonWithSize:CGSizeMake(24, 34)
                                                 NormalImage:@"login_backBtn"
                                            highlightedImage:@"login_backBtn_h"
                                                      target:self
                                                      action:@selector(backBtnClick)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(8, 6, 8, 6);
    

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //icon view
    UIButton *iconView = [TJUICreator createButtonWithSize:TJAutoSizeMake(86, 86)
                                               NormalImage:@"addIcon"
                                          highlightedImage:@"addIcon_h"
                                                    target:self
                                                    action:@selector(iconViewClick:)];
    iconView.layer.cornerRadius = 9;
    iconView.layer.masksToBounds = YES;
    _iconView = iconView;
    [self.view addSubview:_iconView];
    
    //the nick view
    TJInPutView *nickView = [TJUICreator createInPutViewWithsize:TJAutoSizeMake(262, 55)
                                                            Type:TJInPutViewTypeNickName];
    _nickView = nickView;
    [self.view addSubview:_nickView];
    
    //sex view
    TJSexChooseView *sexView = [[TJSexChooseView alloc] initWithSize:TJAutoSizeMake(140, 56)];
    
    _sexView = sexView;
    [self.view addSubview:sexView];

    //region choose
    UIButton *regionChooseView = [TJUICreator createButtonWithSize:TJAutoSizeMake(315, 50)
                                                       NormalImage:@"regionB"
                                                  highlightedImage:@"regionB_h"
                                                            target:self
                                                            action:@selector(regionChooseBtnClick:)];
    
    _regionChooseView = regionChooseView;
    [self.view addSubview:_regionChooseView];
    

    //flag image view
    UIImageView *flagView = [TJUICreator createImageViewWithSize:TJAutoSizeMake(26, 21)];
    _flagView = flagView;
    [self.view addSubview:_flagView];
    
    //the region result view of customer
    UIButton *regionRsultView = [TJUICreator createButtonWithTitle:nil
                                                              size:TJAutoSizeMake(self.view.width, 30)
                                                        titleColor:TJColor(100, 100, 100)
                                                              font:TJFontWithSize(17)
                                                            target:self
                                                            action:@selector(regionChooseBtnClick:)];
    regionRsultView.titleLabel.textAlignment = NSTextAlignmentCenter;
    _regionRsultView = regionRsultView;
    [self.view addSubview:_regionRsultView];
    
    //confirm button
    UIButton *confirmView = [TJUICreator createButtonWithSize:TJAutoSizeMake(315, 50)
                                                  NormalImage:@"confirmB"
                                                highlightedImage:@"confirmB_h"
                                                       target:self
                                                       action:@selector(confirmBtnClick:)];
    _confirmView = confirmView;
    [self.view addSubview:_confirmView];


}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheTopMiddleOfTheView:self.view offset:TJSizeWithHeight(77)];
    [TJAutoLayoutor layView:_sexView atCenterOfTheView:self.view offset:TJSizeWithHeight(50)];
    [TJAutoLayoutor layView:_nickView aboveTheView:_sexView span:TJSizeWithHeight(12)];
    [TJAutoLayoutor layView:_regionChooseView belowTheView:_sexView span:TJSizeWithHeight(14)];
    [TJAutoLayoutor layView:_regionRsultView atCenterOfTheView:self.view offset:TJSizeWithHeight(-26)];
    [TJAutoLayoutor layView:_flagView toTheLeftOfTheView:_regionRsultView span:TJSizeWithWidth(4)];
    [TJAutoLayoutor layView:_confirmView belowTheView:_regionRsultView span:TJSizeWithHeight(36)];
    
    [self.view bringSubviewToFront:_backButton];
    
    NSDictionary *locationList = self.modifyUserInfoParam.locationList;
    if (locationList.count == 0) {
        _flagView.hidden = YES;
        _regionRsultView.hidden = YES;
        _confirmView.hidden = YES;
        
        _regionChooseView.hidden = NO;
    }else{
        _flagView.image = [UIImage imageNamed:locationList[@"code"]];
        NSString *stateStr = @"";
        if (locationList[@"State"]) {
            stateStr = locationList[@"State"];
        }else{
            stateStr = locationList[@"City"];
        }
        NSString *regionStr = [NSString stringWithFormat:@"%@%@%@",locationList[@"CountryRegion"], TJLocationPoint, stateStr];
        
        _modifyUserInfoParam.region = [regionStr stringByAppendingString:[NSString stringWithFormat:@"_&%@",locationList[@"code"]]];
        
        _flagView.hidden = NO;
        [_regionRsultView setTitle:regionStr forState:UIControlStateNormal];
        [_regionRsultView sizeToFit];
        _regionRsultView.hidden = NO;
        _confirmView.hidden = NO;
        
        _regionChooseView.hidden = YES;
    }
}


/**
 *  button clicked
 */
- (void)backBtnClick
{
    [TJGuideTool guideRootViewController:TJKeyWindow];
}

- (void)regionChooseBtnClick:(id)sender
{
    //end edit
    [self.view endEditing:YES];
    
    TJAreaSelectedTVC *areaSelectedTVC = [[TJAreaSelectedTVC alloc] init];

    [self.navigationController pushViewController:areaSelectedTVC animated:YES];
    
    
}

/**
 *  confirm button clicked
 */
- (void)confirmBtnClick:(id)sender
{
    //end edit
    [self.view endEditing:YES];
    [TJRemindTool showMessage:@"上传中..."];
    
    //上传头像
    [TJHttpTool upLoadData:UIImagePNGRepresentation(_iconView.imageView.image)
                   success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                       
                       _modifyUserInfoParam.iconImage = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
                       _modifyUserInfoParam.sex = _sexView.isMan ? NIMUserGenderMale : NIMUserGenderFemale;
                       _modifyUserInfoParam.nickName = _nickView.text;
                       
                       [TJUserInfoTool modifyUserInfoWithParam:_modifyUserInfoParam.mj_keyValues
                                                       Success:^{
                                                           //初始化用户资料
                                                           [TJAccountTool loadBaseUserData];
                                                           
                                                           [TJGuideTool guideRootViewController:TJKeyWindow];
                                                       } failure:^(NSError *error) {}];
                   }];
    

}

/**
 *  icon Choose button Click
 */
- (void)iconViewClick:(id)sender
{
    //end editing
     [self.view endEditing:YES];
    
    //create a chooseSheet
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"选择头像"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    choiceSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [choiceSheet showInView:self.view];
}

/**
 *  点击图片选择
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        [self pickPictureFromCamera];
        
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        [self pickPictureFromPhotoLibrary];
    }
}


- (void)pickPictureFromCamera
{
    //获取 storyboard
    TJCameraController *captureVC = [TJCameraController cameraViewController];
    captureVC.isCameraForIcon = YES;
    
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             //传出的是URL则是视频
             if ([result isKindOfClass:[NSURL class]]) {
 
             }else if([result isKindOfClass:[UIImage class]]){
                 
                 UIImage *resultImage = (UIImage *)result;
                 //如果是图片, 则是相机回调
                [self modifyImage:resultImage];

             }else{
                 //如果是空 则进入相册
                 [self pickPictureFromPhotoLibrary];
             }
         }
         else
         {
             NSLog(@"Video Picker Failed: %@", result);
         }
         //
     }];
    
    [self presentViewController:captureVC animated:YES completion:^{
        NSLog(@"PickVideo present");
    }];
}

- (void)pickPictureFromPhotoLibrary
{
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (void)modifyImage:(UIImage *)image
{
    TJSimpleImageFilterViewController *imageFilterVC = [[TJSimpleImageFilterViewController alloc] initWithImage:image
                                                                                                      cropFrame:CGRectMake(0, 44.0, TJWidthDevice, TJWidthDevice) limitScaleRatio:3.0];
    
    imageFilterVC.delegate = self;
    
    [self presentViewController:imageFilterVC animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
    
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self modifyImage:portraitImg];
    }];
}


#pragma mark - TJSimpleImageFilter Delegate
- (void)imageCropper:(TJSimpleImageFilterViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [cropperViewController dismissViewControllerAnimated:YES
                                              completion:^{
                                                  
                                                  [_iconView setImage:editedImage forState:UIControlStateNormal];
         
                                              }];
}

- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
