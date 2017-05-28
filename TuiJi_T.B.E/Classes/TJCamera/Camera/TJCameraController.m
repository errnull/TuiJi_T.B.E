//
//  TJCameraController.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCameraController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProgressBar.h"
#import "CaptureToolKit.h"
#import "DeleteButton.h"
#import "DDHTimerControl.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#import <AVFoundation/AVFoundation.h>
#import "CaptureDefine.h"
#import "CameraRecorder.h"

#import "CCCameraManger.h"

#import "SimpleVideoFileFilterViewController.h"

#define TIMER_INTERVAL 0.05f
#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086


@interface TJCameraController ()<TJCameraRecorderDelegate, UIAlertViewDelegate>
{
    BOOL _isAnimating;
}

@property (nonatomic, strong) CCCameraManger *manger;

@property (assign, nonatomic) BOOL initalized;
@property (assign, nonatomic) BOOL isProcessingData;
@property (weak, nonatomic) IBOutlet UIButton *imageStorageBtn;

@property (nonatomic, strong) DDHTimerControl *timerControl;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIButton *photoView;
@property (weak, nonatomic) IBOutlet UIButton *videoView;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishRecordView;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) DeleteButton *deleteButton;

@property (strong, nonatomic) ProgressBar *progressBar;


- (IBAction)backViewClick:(UIButton *)sender;
- (IBAction)changToVideo:(UIButton *)sender;
- (IBAction)changeToPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)imageStorageClick:(UIButton *)sender;


@end

@implementation TJCameraController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (CCCameraManger *)manger
{
    if (!_manger) {
        _manger = [[CCCameraManger alloc] initWithParentView:self.recordView];
        _manger.faceRecognition = YES;
        _manger.delegate = self;
    }
    return _manger;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_initalized)
    {
        return;
    }
    
    [CaptureToolKit createVideoFolderIfNotExist];
    [self initProgressBar];
    [self initRecordButton];
    [self initDeleteButton];
    [self initOKButton];
    [self initTopLayout];
    
    [self initTimeControl];
    //
    self.initalized = YES;
    
    [self.manger startUp];
    
    if (_isCameraForIcon) {
        _videoView.hidden = YES;
    }
    
    if (_isOnlyForVideo) {
        [self changToVideo:_videoView];
        _imageStorageBtn.hidden = YES;
    }
}

- (void)initTimeControl
{
    CGFloat len = 80;
    _timerControl = [[DDHTimerControl alloc] initWithFrame:CGRectMake((CGRectGetWidth(_progressBar.frame)-len)/2, CGRectGetMinY(self.progressBar.frame) - len, len, len)];
    _timerControl.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl.color = [UIColor greenColor];
    _timerControl.highlightColor = [UIColor yellowColor];
    _timerControl.minutesOrSeconds = MAX_VIDEO_DUR;
    _timerControl.maxValue = MAX_VIDEO_DUR;
    _timerControl.titleLabel.text = GBLocalizedString(@"Seconds");
    _timerControl.userInteractionEnabled = NO;
    [self.view addSubview:_timerControl];
    _timerControl.hidden = YES;
}

- (void)initProgressBar
{
    self.progressBar = [ProgressBar getInstance];
    //    [CaptureToolKit setView:_progressBar toOriginY:DEVICE_SIZE.width];
    
    _progressBar.gjcf_top = self.recordView.gjcf_bottom + 1;
    
    [self.view insertSubview:_progressBar aboveSubview:self.bgView];
    _progressBar.hidden = YES;
}

- (void)initDeleteButton
{
    if (_isProcessingData)
    {
        return;
    }
    
    self.deleteButton = [DeleteButton getInstance];
    [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
    [CaptureToolKit setView:_deleteButton toOrigin:CGPointMake(15, self.view.frame.size.height - _deleteButton.frame.size.height - 10)];
    [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self.view insertSubview:_deleteButton belowSubview:_maskView];
    
    _deleteButton.gjcf_centerX = self.videoBtn.gjcf_centerX;
    
    _deleteButton.gjcf_centerY = ((self.bgView.gjcf_height - self.videoBtn.gjcf_height) / 4) + self.videoBtn.gjcf_bottom;
    
    _deleteButton.hidden = YES;
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton.titleLabel setFont:TJFontWithSize(14)];
    [_deleteButton setTitleColor:TJColorBlackFont forState:UIControlStateNormal];
    
    [self.bgView addSubview:_deleteButton];
    
}

- (void)initTopLayout
{
    
    
    //    // 前后摄像头转换
    //    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10) * 2 - 10, 5, buttonW, buttonW)];
    //    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_normal"] forState:UIControlStateNormal];
    //    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_disable"] forState:UIControlStateDisabled];
    //    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted"] forState:UIControlStateSelected];
    //    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted"] forState:UIControlStateHighlighted];
    [_switchButton addTarget:self action:@selector(pressSwitchButton) forControlEvents:UIControlEventTouchUpInside];
    //    _switchButton.enabled = [_manger isFrontCameraSupported];
    //    [self.view insertSubview:_switchButton belowSubview:_maskView];
    
    //    self.flashButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10), 5, buttonW, buttonW)];
    //    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_normal"] forState:UIControlStateNormal];
    //    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_disable"] forState:UIControlStateDisabled];
    //    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted"] forState:UIControlStateHighlighted];
    //    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted"] forState:UIControlStateSelected];
    //    _flashButton.enabled = _manger.recorder.isTorchSupported;
        [_flashButton addTarget:self action:@selector(pressFlashButton) forControlEvents:UIControlEventTouchUpInside];
    ////    [self.view insertSubview:_flashButton belowSubview:_maskView];
    //
    //    _flashButton.enabled = !([_manger.recorder isFrontCameraSupported] && [_manger.recorder isFrontCamera]);
    
}

//- (void)pressCloseButton
//{
//    if ([_recorder getVideoCount] > 0)
//    {
//        NSString *cancel = GBLocalizedString(@"Cancel");
//        NSString *abandon = GBLocalizedString(@"Abandon");
//        NSString *reminder = GBLocalizedString(@"Reminder");
//        NSString *cancelVideoHint = GBLocalizedString(@"CancelVideoHint");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:reminder message:cancelVideoHint delegate:self cancelButtonTitle:cancel otherButtonTitles:abandon, nil];
//        alertView.tag = TAG_ALERTVIEW_CLOSE_CONTROLLER;
//        [alertView show];
//    }
//    else
//    {
//        [self dropTheVideo];
//    }
//}

- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal)
    {
        // 第一次按下删除按钮
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleDelete];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
        [_deleteButton setTitleColor:TJColorRed forState:UIControlStateNormal];
    }
    else if (_deleteButton.style == DeleteButtonStyleDelete)
    {
        // 第二次按下删除按钮
        [self deleteLastVideo];
        [_progressBar deleteLastProgress];
        [_deleteButton setTitleColor:TJColorBlackFont forState:UIControlStateNormal];
                if ([_manger getVideoCount] > 0)
                {
                    [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
                    
                }
                else
                {
                    [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
                }
    }
}



#pragma public method
+ (instancetype)cameraViewController
{
    //获取 storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJCamera" bundle:nil];
    //获取初始化箭头所指controller
    TJCameraController *cameraController = [storyboard instantiateInitialViewController];
    
    return cameraController;
}

- (IBAction)backViewClick:(UIButton *)sender {
    
    [self dropTheVideo];

    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}

- (IBAction)changToVideo:(UIButton *)sender {
    
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.videoView.alpha = 0.0;
        self.photoBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
         _progressBar.hidden = NO;
        [_progressBar startShining];
        self.videoView.hidden = YES;
        self.photoBtn.hidden = YES;
        
        self.photoView.alpha = 0.0;
        self.photoView.hidden = NO;
        self.videoBtn.alpha = 0.0;
        self.videoBtn.hidden = NO;
        
        [_manger changeToVideo];
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             if (!_isOnlyForVideo) {
                                 self.photoView.alpha = 1;
                             }
                             self.videoBtn.alpha = 1;
                             
                         }
                         completion:^(BOOL finished) {
                             _isAnimating = NO;
                             
                         }];
    }];
    

}

- (IBAction)changeToPhoto:(UIButton *)sender {
    
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.photoView.alpha = 0.0;
        self.videoBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        _deleteButton.hidden = YES;
         _progressBar.hidden = YES;
        self.photoView.hidden = YES;
        self.videoBtn.hidden = YES;
        
        self.videoView.alpha = 0.0;
        self.videoView.hidden = NO;
        self.photoBtn.alpha = 0.0;
        self.photoBtn.hidden = NO;
        
        [_manger changeToPhoto];
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.videoView.alpha = 1;
                             self.photoBtn.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             _isAnimating = NO;
                         }];
    }];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    [self.manger takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
        self.flashButton.selected = NO; // 拍照完成后会自动关闭闪光灯
        
        
        // Callback
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self dismissViewControllerAnimated:YES completion:^{
            
            if (_callback)
            {
                self.callback(YES, croppedImage);
            }
            
        }];
    }];
    
}

- (IBAction)imageStorageClick:(UIButton *)sender {
    
    self.isProcessingData = NO;
    
    // Callback
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_callback)
        {
            self.callback(YES, nil);
        }
        
    }];
    
    
}









- (void)initRecordButton
{
//    CGFloat buttonW = 120.0f;
//    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake((DEVICE_SIZE.width - buttonW) / 2.0, _progressBar.frame.origin.y + _progressBar.frame.size.height + 10, buttonW, buttonW)];
//    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shot"] forState:UIControlStateNormal];
//    [self.view insertSubview:_recordButton belowSubview:_maskView];
    
//    // Tap Gesture
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressGestureRecognized:)];
    gesture.minimumPressDuration = 0.3;
    [_videoBtn addGestureRecognizer: gesture];

    
}

- (void)initOKButton
{
//    CGFloat okButtonW = 50;
//    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, okButtonW, okButtonW)];
//    _okButton.enabled = NO;
//    
//    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_normal_bg"] forState:UIControlStateNormal];
//    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_highlighted_bg"] forState:UIControlStateHighlighted];
//    [_okButton setImage:[UIImage imageNamed:@"record_icon_hook_normal"] forState:UIControlStateNormal];
//    
//    [CaptureToolKit setView:_okButton toOrigin:CGPointMake(self.view.frame.size.width - okButtonW - 10, self.view.frame.size.height - okButtonW - 10)];
    
    [_finishRecordView addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    
//    CGPoint center = _okButton.center;
//    center.y = _recordButton.center.y;
//    _okButton.center = center;
//    
//    [self.view insertSubview:_okButton belowSubview:_maskView];
}





- (void)pressSwitchButton
{
   
    self.switchButton.selected = !self.switchButton.selected;
    [self.manger changeCameraInputDeviceisFront:self.switchButton.selected];
    if (self.switchButton.selected == YES) { // 切换为前置镜头关闭闪光灯
        self.flashButton.enabled = NO;
        [self.manger closeFlashLight];
    }else{
        self.flashButton.enabled = YES;
    }
}

- (void)pressFlashButton
{
    if (self.switchButton.selected) { // 当前为前置镜头的时候不能打开闪光灯
        return;
    }
    self.flashButton.selected = !self.flashButton.selected;
    if (self.flashButton.selected) {
        [self.manger openFlashLight];
    } else {
        [self.manger closeFlashLight];
    }
}


- (void)pressOKButton
{
    if (_isProcessingData)
    {
        return;
    }
    
    if (self.timerControl.minutesOrSeconds > 0)
    {
        // Progress bar
        NSString *title = GBLocalizedString(@"Processing");
        
    }
    
    [_manger endVideoRecording];
    self.isProcessingData = YES;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

}

// 放弃本次视频，并且关闭页面
- (void)dropTheVideo
{
    [_manger deleteAllVideo];
    
    if (_callback)
    {
        self.callback(NO, @"Abandon this recording video.");
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 删除最后一段视频
- (void)deleteLastVideo
{
    if ([_manger getVideoCount] > 0)
    {
        
        [_manger deleteLastVideo];
    }
    
    if ([_manger getVideoCount] == 0) {
        [_progressBar startShining];
        _deleteButton.hidden = YES;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//- (void)startProgressTimer
//{
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
//    self.progressCounter = 0;
//}
//
//- (void)stopProgressTimer
//{
//    [_progressTimer invalidate];
//    self.progressTimer = nil;
//}
//
//- (void)onTimer:(NSTimer *)timer
//{
//    self.progressCounter++;
//    [_progressBar setLastProgressToWidth:self.progressCounter * TIMER_INTERVAL / MAX_VIDEO_DUR * DEVICE_SIZE.width];
//}

#pragma mark - Tap Gesture
// Add gesture by Johnny Xu
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *) gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {

            [_progressBar stopShining];
            [self startRecording];
            _videoBtn.frame = CGRectMake(_videoBtn.x+10, _videoBtn.y+10, 60, 60);
            

            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _videoBtn.frame = CGRectMake(_videoBtn.x-10, _videoBtn.y-10, 80, 80);
                             }];
            
            _deleteButton.hidden = NO;
            [self stopRecording];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Video Recording
#pragma mark - Video Recording
- (void)startRecording
{
    if (_isProcessingData)
    {
        return;
    }
    
    if (_deleteButton.style == DeleteButtonStyleDelete)
    {
        // 取消删除
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleNormal];
        return;
    }
    
    self.isProcessingData = YES;
    NSString *filePath = [CaptureToolKit getVideoSaveFilePathString];
    [_manger startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
}

- (void)stopRecording
{
    if (!_isProcessingData)
    {
        return;
    }
    
    // Progress bar
    NSString *title = GBLocalizedString(@"SavingVideo");
    
    
    [_manger stopCurrentVideoRecording];
    
}

//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (alertView.tag)
//    {
//        case TAG_ALERTVIEW_CLOSE_CONTROLLER:
//        {
//            switch (buttonIndex)
//            {
//                case 0:
//                {
//                    break;
//                }
//                case 1:
//                {
//                    [self dropTheVideo];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark - CameraRecorderDelegate
- (void)didStartCurrentRecording:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
    
    self.timerControl.hidden = NO;
}

- (void)didFinishCurrentRecording:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDuration:(CGFloat)totalDuration error:(NSError *)error
{
    if (error)
    {
        NSLog(@"录制视频错误:%@", error);
        
        NSString *success = GBLocalizedString(@"Failed");
        
    }
    else
    {
        NSLog(@"录制视频完成: %@", outputFileURL);
        
        NSString *success = GBLocalizedString(@"Success");
        
    }
    
    self.isProcessingData = NO;
    
    self.timerControl.hidden = YES;
    if (totalDuration >= MAX_VIDEO_DUR)
    {
        self.timerControl.minutesOrSeconds = 0;
        
        [self pressOKButton];
    }
    else
    {
        self.timerControl.minutesOrSeconds = ((NSInteger) (MAX_VIDEO_DUR - totalDuration + 1));
    }
}

- (void)didRemoveCurrentVideo:(NSURL *)fileURL totalDuration:(CGFloat)totalDuration error:(NSError *)error
{
    if (error)
    {
        NSLog(@"删除视频错误: %@", error);
    }
    else
    {
        NSLog(@"删除了视频: %@", fileURL);
        NSLog(@"现在视频长度: %f", totalDuration);
    }
    
    if ([_manger getVideoCount] > 0)
    {
        [_deleteButton setStyle:DeleteButtonStyleNormal];
    }
    else
    {
        [_deleteButton setStyle:DeleteButtonStyleDisable];
    }
    
    _finishRecordView.enabled = (totalDuration >= MIN_VIDEO_DUR);
    
    self.timerControl.minutesOrSeconds = ((NSInteger) (MAX_VIDEO_DUR - totalDuration + 1));
}

- (void)doingCurrentRecording:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDuration:(CGFloat)totalDuration
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    _finishRecordView.enabled = (videoDuration + totalDuration >= MIN_VIDEO_DUR);
    
    self.timerControl.minutesOrSeconds = ((NSInteger) (MAX_VIDEO_DUR - totalDuration - videoDuration + 1));
}

- (void)didRecordingMultiVideosSuccess:(NSArray *)outputFilesURL
{
    NSLog(@"RecordingMultiVideosSuccess: %@", outputFilesURL);
    
    NSString *success = GBLocalizedString(@"Success");
    
    
    self.isProcessingData = NO;
    
    // Callback
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_callback)
        {
            self.callback(YES, outputFilesURL);
        }
        
    }];
    
    
    
    // Close
    
}

- (void)didRecordingVideosSuccess:(NSURL *)outputFileURL
{
    NSString *outputFile = [outputFileURL path];
    NSLog(@"didRecordingVideosSuccess: %@", outputFile);
    
    NSString *success = GBLocalizedString(@"Success");
    
    
    self.isProcessingData = NO;
    
    // Callback
    if (_callback)
    {
        self.callback(YES, outputFileURL);
    }
    
    // Close
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRecordingVideosError:(NSError*)error;
{
    NSLog(@"didRecordingVideosError: %@", error.description);
    
    NSString *failed = GBLocalizedString(@"Failed");
    
    
    self.isProcessingData = NO;
    
    // Callback
    if (_callback)
    {
        self.callback(NO, @"The recording video is merge failed.");
    }
    
    // Close
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTakePictureSuccess:(NSString *)outputFile
{
    NSLog(@"didTakePictureSuccess: %@", outputFile);
}

- (void)didTakePictureError:(NSError*)error
{
    NSLog(@"didTakePictureError: %@", error.description);
}



#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

//iOS6+
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#endif



@end
