//
//  TJEditUserInfoVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJEditUserInfoVC.h"
#import "TJUserInfo.h"
#import "TJURLList.h"
#import "TJAccount.h"
#import "TJModifyUserInfoParam.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "TJCameraController.h"
#import "TJSimpleImageFilterViewController.h"

#import "TJProfileViewController.h"

#import "TJAreaSelectedTVC.h"

@interface TJEditUserInfoVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate ,TJSimpleImageFilterDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameView;
@property (weak, nonatomic) IBOutlet UITextField *tuijiView;

@property (weak, nonatomic) IBOutlet UIButton *sexManBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexWomanBtn;
- (IBAction)sexWomanBtnClick:(UIButton *)sender;
- (IBAction)sexManBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *signatureView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberView;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;

@property (nonatomic, weak) UIView *iconModifyView;

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UIButton *modifyIconButton;

@end

@implementation TJEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUPHeadIconView];
    
    [self setUpNavigationBar];
    
    _nickNameView.text = TJUserInfoCurrent.uNickname;
    _tuijiView.text = TJUserInfoCurrent.uUsername;
    _tuijiView.enabled = ![TJUserInfoCurrent.changeUsername intValue];
    if(TJUserInfoCurrent.uSex == NIMUserGenderMale){
        _sexManBtn.selected = YES;
    }else{
        _sexWomanBtn.selected = YES;
    }
    _signatureView.text = TJUserInfoCurrent.uSignature;
    _phoneNumberView.text = TJUserInfoCurrent.uTel;
    
}

- (void)setUPHeadIconView
{
    UIView *headView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 150)
                                                 bgColor:TJColorGrayBg
                                                  radius:0];
    

    UIView *iconModifyView = [[UIView alloc] initWithFrame:TJRectFromSize(CGSizeMake(150, 150))];
    
    iconModifyView.backgroundColor = TJColorClear;
    
    _iconModifyView = iconModifyView;

    [headView addSubview:_iconModifyView];
    
    [TJAutoLayoutor layView:_iconModifyView atCenterOfTheView:headView offset:CGSizeZero];
    
    UIButton *button = [TJUICreator createButtonWithTitle:@"编辑"
                                                     size:TJAutoSizeMake(50, 30)
                                               titleColor:TJColorBlue
                                                     font:TJFontWithSize(17)
                                                   target:self
                                                   action:@selector(modifyViewClick)];
    
    _modifyIconButton = button;
    [_iconModifyView addSubview:_modifyIconButton];
    
    UIImageView *iconView = [TJUICreator createImageViewWithSize:TJAutoSizeMake(80, 80)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:TJUserInfoCurrent.uPicture]];
    iconView.layer.cornerRadius = 12;
    iconView.layer.masksToBounds = YES;
    _iconView = iconView;
    [_iconModifyView addSubview:_iconView];
    
    [TJAutoLayoutor layView:_iconView atCenterOfTheView:_iconModifyView offset:TJAutoSizeMake(0, 13)];
    [TJAutoLayoutor layView:_modifyIconButton belowTheView:_iconView span:TJSizeWithHeight(0)];
    
    
    
    self.tableView.tableHeaderView = headView;

}

- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"编辑个人主页"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;

    
    UIBarButtonItem *rightBtn = [TJUICreator createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                                 text:@"确定"
                                                                 font:TJFontWithSize(14)
                                                                color:TJColorBlackFont
                                                               target:self
                                                               action:@selector(finishModify)
                                                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


- (void)finishModify
{
    TJModifyUserInfoParam *param = [[TJModifyUserInfoParam alloc] init];
    param.nickName = _nickNameView.text;
    param.sex = _sexManBtn.isSelected ? NIMUserGenderMale : NIMUserGenderFemale;
    
    if (![TJUserInfoCurrent.uUsername isEqualToString:_tuijiView.text]) {
        param.username = _tuijiView.text;
    }
    
    if (!TJStringIsNull(_currentRegion)) {
        param.region = _currentRegion;
    }
    param.signature = _signatureView.text;
    param.tel = _phoneNumberView.text;
    
    [TJUserInfoTool modifyUserInfoWithParam:param.mj_keyValues
                                    Success:^{
                                        
                                        [TJGuideTool guideRootViewController:TJKeyWindow];
                                        
                                    } failure:^(NSError *error) {}];
}

- (void)modifyViewClick
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

        [self pickPictureFromCamera];
        
        
    } else if (buttonIndex == 1) {
        
        [self pickPictureFromPhotoLibrary];
        
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];

        TJSimpleImageFilterViewController *imageFilterVC = [[TJSimpleImageFilterViewController alloc] initWithImage:portraitImg
                                                                                                          cropFrame:CGRectMake(0, 44.0, TJWidthDevice, TJWidthDevice) limitScaleRatio:3.0];
        
        imageFilterVC.delegate = self;
        
        [self presentViewController:imageFilterVC animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        
        
    }];
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

- (void)modifyImage:(UIImage *)image
{
    TJSimpleImageFilterViewController *imageFilterVC = [[TJSimpleImageFilterViewController alloc] initWithImage:image
                                                                                                      cropFrame:CGRectMake(0, 44.0, TJWidthDevice, TJWidthDevice) limitScaleRatio:3.0];
    
    imageFilterVC.delegate = self;
    
    [self presentViewController:imageFilterVC animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
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

#pragma mark - TJSimpleImageFilter Delegate
- (void)imageCropper:(TJSimpleImageFilterViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [cropperViewController dismissViewControllerAnimated:YES
                                              completion:^{
                                                  
                                                  //提示用户正在上传
                                                  [TJRemindTool showMessage:@"上传中..."];
                                                  //头像裁剪完成开始上传
                                                  [TJHttpTool upLoadData:UIImagePNGRepresentation(editedImage)
                                                                 success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                                                     //上传完成提交给服务器修改头像
                                                                     NSString *URLStr = [TJUrlList.modifyUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
                                                                     TJModifyUserInfoParam *param = [[TJModifyUserInfoParam alloc] init];
                                                                     param.username = TJUserInfoCurrent.uUsername;
                                                                     param.iconImage = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
                                                                     
                                                                     [TJHttpTool POST:URLStr
                                                                           parameters:param.mj_keyValues
                                                                              success:^(id responseObject) {

                                                                                  [TJGuideTool guideRootViewController:TJKeyWindow];
                                                                                  
                                                                              } failure:^(NSError *error) {
                                                                                  NSLog(@"%@",error);
                                                                              }];
                                                                     
                                                                     
                                                                 }];
                                                  
                                                  
                                                  
                                                  
                                              }];
}

- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark camera utility

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)sexWomanBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _sexManBtn.selected = NO;
}

- (IBAction)sexManBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _sexWomanBtn.selected = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            TJAreaSelectedTVC *areaSelectedTVC = [[TJAreaSelectedTVC alloc] init];
            
            [self.navigationController pushViewController:areaSelectedTVC animated:YES];
        }
    }
}
@end
