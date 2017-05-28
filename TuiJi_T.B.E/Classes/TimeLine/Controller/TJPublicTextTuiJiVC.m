//
//  TJPublicTextTuiJiVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPublicTextTuiJiVC.h"

#import "TJPublicTimeLineParam.h"

#import "TJURLList.h"

#import "TJAccount.h"

#import "TJUserInfo.h"

#import "TJCameraController.h"
#import "TJLocationNameTVC.h"

#import "TJSimpleImageFilterViewController.h"

#import "TJListSelector.h"

#import <MobileCoreServices/MobileCoreServices.h>


@interface TJPublicTextTuiJiVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TJSimpleImageFilterDelegate, TJListSelectorDelegate>
@property (weak, nonatomic) IBOutlet UITextView *timeLineTextView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImageHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImageMargin;
@property (weak, nonatomic) IBOutlet UIView *locationResultCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForLocationCell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *locationResultBtn;

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (weak, nonatomic) IBOutlet UIView *readLimitsPoint;
@property (weak, nonatomic) IBOutlet UIView *redPictureSelectedView;


- (IBAction)voiceBtnDidClick:(UIButton *)sender;
- (IBAction)pictureBtnDidClick:(UIButton *)sender;
- (IBAction)emojiBtnDidClick:(UIButton *)sender;
- (IBAction)aitBtnDidClick:(UIButton *)sender;
- (IBAction)addLocationBtnDidClick:(UIButton *)sender;
- (IBAction)friendViewDidClick:(UIButton *)sender;
- (IBAction)locationResultClick:(UIButton *)sender;
- (IBAction)locationDeleteClick:(UIButton *)sender;

@end

@implementation TJPublicTextTuiJiVC
{
    CGFloat _locationBtnW;
    CLLocation *_currentLocation;
}

- (void)setAitFriendList:(NSMutableArray *)aitFriendList{
    _aitFriendList = aitFriendList;
    
    if (_aitFriendList.count) {
        _redPointView.hidden = NO;
    }else{
        _redPointView.hidden = YES;
    }
}

- (void)setReadLimitList:(NSMutableArray *)readLimitList{
    _readLimitList = readLimitList;
    
    if (_readLimitList.count) {
        _readLimitsPoint.hidden = NO;
    }else{
        _readLimitsPoint.hidden = YES;
    }
}

+ (instancetype)PublicTextVCWithShowImage:(UIImage *)showImage{

    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJTimeLine" bundle:nil];
    //获取初始化箭头所指controller
    TJPublicTextTuiJiVC *publicTextTuiJiVC = [storyboard instantiateInitialViewController];
    
    publicTextTuiJiVC.showImage = showImage;
    
    return publicTextTuiJiVC;
    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (self.showImage) {
        self.showImageView.image = self.showImage;
    }else{
        self.showImageMargin.constant = 0;
        self.showImageHeight.constant = 0;
    }
    
    
}

- (void)setCurrentLocationName:(NSString *)currentLocationName{
    _currentLocationName = currentLocationName;
    
    [self.locationResultBtn setTitle:_currentLocationName forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.timeLineTextView endEditing:YES];
}

- (void)hidelocationResultView
{
    self.locationResultCell.alpha = 0;
    self.heightForLocationCell.constant = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TJLocationTool currentLocationSuccess:^(CLLocation *location, NSString *locationString) {

        self.locationResultBtn.userInteractionEnabled = YES;
        [self.loadingView stopAnimating];
        
        [self.locationResultBtn setTitle:[NSString stringWithFormat:@"  %@  " ,locationString] forState:UIControlStateNormal];
        
        _currentLocation = location;
        
        [self viewDidLayoutSubviews];
        

        
    } failure:^(NSError *error) {}];
    
    [self setUpNavigationBar];
    
    //设置按钮圆角
    self.locationResultBtn.layer.cornerRadius = 6;
    self.locationResultBtn.layer.masksToBounds = YES;
}


- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"新推文"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *rightBtn = [TJUICreator createBarBtnItemWithSize:CGSizeMake(100, 23)
                                                                 text:@"发布"
                                                                 font:TJFontWithSize(14)
                                                                color:TJColor(0, 136, 227)
                                                               target:self
                                                               action:@selector(rightViewDidClick:)
                                                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)rightViewDidClick:(UIButton *)sender
{
    NSString *filtertype = @"0";
    if (self.readLimitList.count) {
        filtertype = @"3";
    }
    
    [TJTimeLineTool publicTimeLineWithText:self.timeLineTextView.text
                             imageDataList:self.timeLineImageList
                                 audioData:nil
                                 videoData:self.videoData
                         remindSomeFriends:self.aitFriendList
                                    region:(self.heightForLocationCell.constant != 0) ? self.locationResultBtn.titleLabel.text : nil
                                  location:_currentLocation
                                filterlist:self.readLimitList
                                filtertype:filtertype
                                   success:^{
                                       [TJRemindTool showSuccess:@"发布成功."];
                                   } failure:^(NSError *error) {
                                   
                                       [TJRemindTool showError:@"发送失败."];
                                   }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)voiceBtnDidClick:(UIButton *)sender
{
    [self.timeLineTextView becomeFirstResponder];
}

- (IBAction)pictureBtnDidClick:(UIButton *)sender
{
    [self.timeLineTextView endEditing:YES];
    
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


- (IBAction)emojiBtnDidClick:(UIButton *)sender
{
    [self.timeLineTextView endEditing:YES];
    
    [TJRemindTool showError:@"暂不支持哦."];
}

- (IBAction)aitBtnDidClick:(UIButton *)sender
{
    [self.timeLineTextView endEditing:YES];
    
    TJListSelector *listSelector = [[TJListSelector alloc] initWithDataList:[TJContactTool contactList]];
    listSelector.delegate = self;
    
    [self.navigationController pushViewController:listSelector animated:YES];
}

- (IBAction)addLocationBtnDidClick:(UIButton *)sender
{
    [self.timeLineTextView endEditing:YES];
}

- (IBAction)friendViewDidClick:(UIButton *)sender
{
    [self.timeLineTextView endEditing:YES];
    
    TJListSelector *listSelector = [[TJListSelector alloc] initWithDataList:[TJContactTool contactList]];
    listSelector.delegate = self;
    
    listSelector.selectType = @"limit";
    
    [self.navigationController pushViewController:listSelector animated:YES];
    
    
}

- (IBAction)locationResultClick:(UIButton *)sender {
    
    TJLocationNameTVC *locationTVC = [[TJLocationNameTVC alloc] init];
    locationTVC.currentLocation = _currentLocation;
    [self.navigationController pushViewController:locationTVC animated:YES];
    
}

- (IBAction)locationDeleteClick:(UIButton *)sender {
    [self hidelocationResultView];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)listSelector:(TJListSelector *)listSelector didFinishSelect:(NSMutableArray *)selectedSesult{
    
        if ([listSelector.selectType isEqualToString:@"limit"]) {
            self.readLimitList = selectedSesult;
        }else{
            self.aitFriendList = selectedSesult;
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


//#pragma mark VPImageCropperDelegate
//- (void)imageCropper:(TJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    _iconView.image = editedImage;
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//        //提示用户正在上传
//        [TJRemindTool showMessage:@"上传中..."];
//        //头像裁剪完成开始上传
//        [TJHttpTool upLoadData:UIImagePNGRepresentation(editedImage)
//                       success:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                           //上传完成提交给服务器修改头像
//                           NSString *URLStr = [TJUrlList.modifyUserInfo stringByAppendingString:TJAccountCurrent.jsessionid];
//                           TJModifyUserInfoParam *param = [[TJModifyUserInfoParam alloc] init];
//                           param.username = @"15622777555";
//                           param.iconImage = [@"http://img.tuiji.net/" stringByAppendingString:resp[@"key"]];
//
//                           [TJHttpTool POST:URLStr
//                                 parameters:param.mj_keyValues
//                                    success:^(id responseObject) {
//
//                                        NSString *oldIcon = TJUserInfoCurrent.uPicture;
//
//                                        //修改本地头像url
//                                        [[RLMRealm defaultRealm] transactionWithBlock:^{
//                                            TJUserInfoCurrent.uPicture = param.iconImage;
//                                        }];
//
//                                        //删除原头像的本地缓存
//                                        [[SDImageCache sharedImageCache]removeImageForKey:oldIcon fromDisk:YES];
//
//                                        [TJRemindTool hideHUD];
//
//                                        //刷新UI
//
//
//                                    } failure:^(NSError *error) {
//                                        NSLog(@"%@",error);
//                                    }];
//
//
//                       }];
//    }];
//}

//- (void)imageCropperDidCancel:(TJImageCropperViewController *)cropperViewController {
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//    }];
//}

#pragma mark - TJSimpleImageFilter Delegate
- (void)imageCropper:(TJSimpleImageFilterViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [cropperViewController dismissViewControllerAnimated:YES
                                              completion:^{
                                                  
                                                  self.redPictureSelectedView.hidden = NO;
                                                  self.timeLineImageList = [NSMutableArray arrayWithObject:UIImagePNGRepresentation(editedImage)];
                
                                              }];
}

- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
