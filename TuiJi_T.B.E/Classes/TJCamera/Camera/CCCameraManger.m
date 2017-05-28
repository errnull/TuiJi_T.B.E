//
//  CCCameraManger.m
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import "CCCameraManger.h"
#import "TJVideoData.h"
#import "CaptureDefine.h"
#import "CaptureToolKit.h"


#define COUNT_DUR_TIMER_INTERVAL 0.05

@interface CCCameraManger ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) dispatch_queue_t           sessionQueue;
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput       *backCameraInput; // 后置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *frontCameraInput; // 前置摄像头输入
@property (nonatomic, strong) AVCaptureDeviceInput       *currentCameraInput;
@property (nonatomic, strong) AVCaptureStillImageOutput  *stillImageOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput    *metaDataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput   *videoDataOutput;

@property (assign, nonatomic) AVCaptureVideoOrientation orientation;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;


@property (nonatomic, strong) UIImageView                *focusImageView;
@property (nonatomic, assign) BOOL                       isManualFocus; // 判断是否手动对焦

@property (nonatomic, strong) UIImageView                *faceImageView;
@property (nonatomic, assign) BOOL                       isStartFaceRecognition;



@property (strong, nonatomic) NSTimer *countDurTimer;
@property (assign, nonatomic) CGFloat currentVideoDur;
@property (assign, nonatomic) NSURL *currentFileURL;
@property (assign ,nonatomic) CGFloat totalVideoDur;

@property (strong, nonatomic) NSMutableArray *videoFileDataArray;


@end

@implementation CCCameraManger

// End recording
- (void)endVideoRecording
{
    [self mergeVideoFiles];
}

- (void)mergeVideoFiles
{
    NSMutableArray *fileURLArray = [[NSMutableArray alloc] init];
    for (TJVideoData *data in _videoFileDataArray)
    {
        [fileURLArray addObject:data.fileURL];
    }
    
    [self mergeAndExportVideosAtFileURLs:fileURLArray];
}

// 会调用delegate
- (void)deleteLastVideo
{
    if ([_videoFileDataArray count] == 0)
    {
        return;
    }
    
    TJVideoData *data = (TJVideoData *)[_videoFileDataArray lastObject];
    NSURL *videoFileURL = data.fileURL;
    CGFloat videoDuration = data.duration;
    
    [_videoFileDataArray removeLastObject];
    _totalVideoDur -= videoDuration;
    
    // delete
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath])
        {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // delegate
                if ([_delegate respondsToSelector:@selector(didRemoveCurrentVideo:totalDuration:error:)])
                {
                    [_delegate didRemoveCurrentVideo:videoFileURL totalDuration:_totalVideoDur error:error];
                }
            });
        }
    });
}

// 不调用delegate
- (void)deleteAllVideo
{
    for (TJVideoData *data in _videoFileDataArray)
    {
        NSURL *videoFileURL = data.fileURL;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath])
            {
                NSError *error = nil;
                [fileManager removeItemAtPath:filePath error:&error];
                
                if (error)
                {
                    NSLog(@"deleteAllVideo删除视频文件出错:%@", error);
                }
            }
        });
    }
}


// 现在录了多少视频
- (NSUInteger)getVideoCount
{
    return [_videoFileDataArray count];
}

- (void)startRecordingToOutputFileURL:(NSURL *)fileURL
{
    if (_totalVideoDur >= MAX_VIDEO_DUR)
    {
        NSLog(@"视频总长达到最大");
        return;
    }
    
    [_movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

- (void)startCountDurTimer
{
    self.countDurTimer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}


- (void)onTimer:(NSTimer *)timer
{
    self.currentVideoDur += COUNT_DUR_TIMER_INTERVAL;
    
    if ([_delegate respondsToSelector:@selector(doingCurrentRecording:duration:recordedVideosTotalDuration:)])
    {
        [_delegate doingCurrentRecording:_currentFileURL duration:_currentVideoDur recordedVideosTotalDuration:_totalVideoDur];
    }
    
    if (_totalVideoDur + _currentVideoDur >= MAX_VIDEO_DUR)
    {
        [self stopCurrentVideoRecording];
    }
}

- (void)stopCurrentVideoRecording
{
    [self stopCountDurTimer];
    [_movieFileOutput stopRecording];
}

- (void)stopCountDurTimer
{
    [_countDurTimer invalidate];
    self.countDurTimer = nil;
}

#pragma mark - AVCaptureFileOutputRecordignDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    self.currentFileURL = fileURL;
    self.currentVideoDur = 0.0f;
    [self startCountDurTimer];
    
    if ([_delegate respondsToSelector:@selector(didStartCurrentRecording:)])
    {
        [_delegate didStartCurrentRecording:fileURL];
    }
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    self.totalVideoDur += _currentVideoDur;
    NSLog(@"本段视频长度: %f", _currentVideoDur);
    NSLog(@"现在的视频总长度: %f", _totalVideoDur);
    
    if (!error)
    {
        TJVideoData *data = [[TJVideoData alloc] init];
        data.duration = _currentVideoDur;
        data.fileURL = outputFileURL;
        
        [_videoFileDataArray addObject:data];
    }
    
    if ([_delegate respondsToSelector:@selector(didFinishCurrentRecording:duration:totalDuration:error:)])
    {
        [_delegate didFinishCurrentRecording:outputFileURL duration:_currentVideoDur totalDuration:_totalVideoDur error:error];
    }
}












- (void)dealloc
{
    [self.session stopRunning];
    self.sessionQueue = nil;
    self.session = nil;
    self.previewLayer = nil;
    self.backCameraInput = nil;
    self.frontCameraInput = nil;
    self.stillImageOutput = nil;
    self.metaDataOutput = nil;
    self.videoDataOutput = nil;
    self.movieFileOutput = nil;
    NSLog(@"CCCameraManger---dealloc");
}

- (instancetype)initWithParentView:(UIView *)parent
{
    if (self = [super init]) {
        self.parentView = parent;
        [self.parentView addSubview:self.focusImageView];
        [self.parentView addSubview:self.faceImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClcik:)];
        [self.parentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)startUp
{
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStartFaceRecognition = YES;
    });
}

- (void)tapClcik:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.parentView];
    [self focusInPoint:location];
}

#pragma mark - 拍照
- (void)takePhotoWithImageBlock:(void (^)(UIImage *, UIImage *, UIImage *))block
{
    __weak typeof(self) weak = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self imageConnection] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (!imageDataSampleBuffer) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *originImage = [[UIImage alloc] initWithData:imageData];
        
        CGFloat squareLength = weak.previewLayer.bounds.size.width;
        CGFloat previewLayerH = weak.previewLayer.bounds.size.height;
        CGSize size = CGSizeMake(squareLength * 2, previewLayerH * 2);
        UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];

        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];

        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            CGFloat degree = 0;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = -90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            croppedImage = [croppedImage rotatedByDegrees:degree];
            scaledImage = [scaledImage rotatedByDegrees:degree];
            originImage = [originImage rotatedByDegrees:degree];
        }
        if (block) {
            block(originImage,scaledImage,croppedImage);
        }
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.faceRecognition) {
        for(AVMetadataObject *metadataObject in metadataObjects) {
            if([metadataObject.type isEqualToString:AVMetadataObjectTypeFace]) {
                AVMetadataObject *transform = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceImageWithFrame:transform.bounds];
                });
            }
        }
    }
}
- (void)showFaceImageWithFrame:(CGRect)rect
{
    if (self.isStartFaceRecognition) {
        self.isStartFaceRecognition = NO;
        self.faceImageView.frame = rect;
        
        self.faceImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        __weak typeof(self) weak = self;
        [UIView animateWithDuration:0.3f animations:^{
            weak.faceImageView.alpha = 1.f;
            weak.faceImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.f animations:^{
                weak.faceImageView.alpha = 0.f;
            } completion:^(BOOL finished) {
                weak.isStartFaceRecognition = YES;
            }];
        }];
    }
}

//开启闪光灯
- (void)openFlashLight
{
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOff) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOn;
        backCamera.flashMode = AVCaptureFlashModeOn;
        [backCamera unlockForConfiguration];
    }
}
//关闭闪光灯
- (void)closeFlashLight
{
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOn) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOff;
        backCamera.flashMode = AVCaptureTorchModeOff;
        [backCamera unlockForConfiguration];
    }
}

- (void)changeCameraAnimation
{
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.55;
    changeAnimation.type = @"oglFlip";
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}

#pragma mark - 聚焦
- (void)focusInPoint:(CGPoint)devicePoint
{
    if (!CGRectContainsPoint(self.previewLayer.bounds, devicePoint)) {
        return;
    }
    self.isManualFocus = YES;
    [self focusImageAnimateWithCenterPoint:devicePoint];
    devicePoint = [self.previewLayer captureDevicePointOfInterestForPoint:devicePoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusImageAnimateWithCenterPoint:(CGPoint)point
{
    [self.focusImageView setCenter:point];
    self.focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weak.focusImageView.alpha = 1.f;
        weak.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            weak.focusImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            weak.isManualFocus = NO;
        }];
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice *device = [self.currentCameraInput device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    });
}

#pragma mark - 从输出数据流捕捉单一的图像帧
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.isStartGetImage) {
        UIImage *originImage = [self imageFromSampleBuffer:sampleBuffer];
        CGFloat squareLength = self.previewLayer.bounds.size.width;
        CGFloat previewLayerH = self.previewLayer.bounds.size.height;
        CGSize size = CGSizeMake(squareLength*2, previewLayerH*2);
        UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            CGFloat degree = 0;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = -90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            croppedImage = [croppedImage rotatedByDegrees:degree];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.getimageBlock) {
                self.getimageBlock(croppedImage);
                self.getimageBlock = nil;
            }
        });
        self.isStartGetImage = NO;
    }
}

// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - getter/setter
- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
    
    self.previewLayer.frame = parentView.bounds;
    [parentView.layer insertSublayer:self.previewLayer atIndex:0];
}

- (dispatch_queue_t)sessionQueue
{
    if (!_sessionQueue) {
        _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    }
    return _sessionQueue;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        self.videoFileDataArray = [[NSMutableArray alloc] init];
        self.totalVideoDur = 0.0f;
        
        
        // 添加后置摄像头的输入
        if ([_session canAddInput:self.backCameraInput]) {
            [_session addInput:self.backCameraInput];
            self.currentCameraInput = self.backCameraInput;
        }
        // 添加视频输出
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        // 添加静态图片输出（拍照）
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        // 添加元素输出（识别）
        if ([_session canAddOutput:self.metaDataOutput]) {
            [_session addOutput:self.metaDataOutput];
            // 人脸识别
            [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
            // 二维码，一维码识别
            //        [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code]];
            [_metaDataOutput setMetadataObjectsDelegate:self queue:self.sessionQueue];
        }
        // 添加视频输出
        self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([_session canAddOutput:_movieFileOutput])
        {
            [_session addOutput:_movieFileOutput];
        }
        
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
        if ([_session canAddInput:_currentCameraInput])
        {
            [_session addInput:_currentCameraInput];
        }
        if ([_session canAddInput:audioDeviceInput])
        {
            [_session addInput:audioDeviceInput];
        }
        
    }
    return _session;
}

// 连接
- (AVCaptureConnection *)imageConnection
{
    AVCaptureConnection *imageConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                imageConnection = connection;
                break;
            }
        }
        if (imageConnection) {
            break;
        }
    }
    return imageConnection;
}

// 后置摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    return _backCameraInput;
}

// 前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    return _frontCameraInput;
}
// 返回前置摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// 返回后置摄像头
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// 切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront {
    [self changeCameraAnimation];
    __weak typeof(self) weak = self;
    dispatch_async(self.sessionQueue, ^{
        [weak.session beginConfiguration];
        if (isFront) {
            [weak.session removeInput:weak.backCameraInput];
            if ([weak.session canAddInput:weak.frontCameraInput]) {
                [weak.session addInput:weak.frontCameraInput];
                weak.currentCameraInput = weak.frontCameraInput;
            }
        }else {
            [weak.session removeInput:weak.frontCameraInput];
            if ([weak.session canAddInput:weak.backCameraInput]) {
                [weak.session addInput:weak.backCameraInput];
                weak.currentCameraInput = weak.backCameraInput;
            }
        }
        [weak.session commitConfiguration];
    });
}

// 用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    // 返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// 视频输出
- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:self.sessionQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoDataOutput.videoSettings = setcapSettings;
    }
    return _videoDataOutput;
}

// 静态图像输出
- (AVCaptureStillImageOutput *)stillImageOutput
{
    if (_stillImageOutput == nil) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        _stillImageOutput.outputSettings = outputSettings;
    }
    return _stillImageOutput;
}

// 识别
- (AVCaptureMetadataOutput *)metaDataOutput
{
    if (_metaDataOutput == nil) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return _metaDataOutput;
}

- (UIImageView *)focusImageView
{
    if (_focusImageView == nil) {
        _focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus"]];
        _focusImageView.alpha = 0;
    }
    return _focusImageView;
}

- (UIImageView *)faceImageView
{
    if (_faceImageView == nil) {
        _faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
        _faceImageView.alpha = 0;
    }
    return _faceImageView;
}


- (void)changeToVideo
{
    self.session.sessionPreset = AVCaptureSessionPreset640x480; // AVCaptureSessionPresetHigh
}
- (void)changeToPhoto
{
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
}


- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray
{
    NSError *error = nil;
    CGSize renderSize = CGSizeMake(0, 0);
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    CMTime totalDuration = kCMTimeZero;
    
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    for (NSURL *fileURL in fileURLArray)
    {
        NSLog(@"fileURL: %@", fileURL);
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        if (!asset)
        {
            // Retry once
            asset = [AVAsset assetWithURL:fileURL];
            if (!asset)
            {
                continue;
            }
        }
        [assetArray addObject:asset];
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        if (!assetTrack)
        {
            // Retry once
            assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            if (!assetTrack)
            {
                NSLog(@"Error reading the transformed video track");
            }
        }
        [assetTrackArray addObject:assetTrack];
        
        NSLog(@"assetTrack.naturalSize Width: %f, Height: %f", assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.width);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.height);
    }
    
    NSLog(@"renderSize width: %f, Height: %f", renderSize.width, renderSize.height);
    if (renderSize.height == 0 || renderSize.width == 0)
    {
        if ([_delegate respondsToSelector:@selector(didRecordingVideosError:)])
        {
            [_delegate didRecordingVideosError:nil];
        }
        
        return;
    }
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++)
    {
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        if ([[asset tracksWithMediaType:AVMediaTypeAudio] count]>0)
        {
            AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:totalDuration error:nil];
        }
        else
        {
            NSLog(@"Reminder: video hasn't audio!");
        }
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        // Fix orientation issue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    // Get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:[CaptureToolKit getVideoMergeFilePathString]];
    
    // Export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    NSLog(@"Video: width = %f, height = %f", renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    // Fix iOS 5.x crash issue by Johnny Xu.
    if (iOS5)
    {
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
    }
    else
    {
        exporter.outputFileType = AVFileTypeMPEG4;
    }
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        // Fix can't export issue under iOS 5.x by Johnny Xu.
        switch ([exporter status])
        {
            case AVAssetExportSessionStatusCompleted:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([_delegate respondsToSelector:@selector(didRecordingVideosSuccess:)])
                    {
                        [_delegate didRecordingVideosSuccess:mergeFileURL];
                    }
                    
                    NSLog(@"Export video success.");
                    
                    // Test
//                    [self writeExportedVideoToAssetsLibrary:mergeFileURL];

                });
                
                break;
            }
            case AVAssetExportSessionStatusFailed:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([_delegate respondsToSelector:@selector(didRecordingVideosError:)])
                    {
                        [_delegate didRecordingVideosError:[exporter error]];
                    }
                    
                    NSLog(@"Export video failed.");
                });
                break;
            }
            case AVAssetExportSessionStatusCancelled:
            {
                NSLog(@"Export canceled");
                break;
            }
            case AVAssetExportSessionStatusWaiting:
            {
                NSLog(@"Export Waiting");
                break;
            }
            case AVAssetExportSessionStatusExporting:
            {
                NSLog(@"Export Exporting");
                break;
            }
            default:
                break;
        }
    }];
}


#pragma mark - Private Methods
- (void)writeExportedVideoToAssetsLibrary:(NSURL *)outputURL
{
    NSURL *exportURL = outputURL; // [NSURL fileURLWithPath:outputURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                 {
                     
                 }
                 else
                 {
                     
                 }
                 
#if !TARGET_IPHONE_SIMULATOR
                 [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
#endif
             });
         }];
    }
    else
    {
        NSLog(@"Video could not be exported to camera roll.");
    }
}
@end
