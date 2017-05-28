//
//  CCCameraManger.h
//  CustomCamera
//
//  Created by zhouke on 16/8/31.
//  Copyright © 2016年 zhongkefuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+CCTool.h"

#import "CameraRecorder.h"

@protocol TJCameraRecorderDelegate <NSObject>

@optional
- (void)didStartCurrentRecording:(NSURL *)fileURL;

- (void)didFinishCurrentRecording:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDuration:(CGFloat)totalDuration error:(NSError *)error;

- (void)doingCurrentRecording:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDuration:(CGFloat)totalDuration;

- (void)didRemoveCurrentVideo:(NSURL *)fileURL totalDuration:(CGFloat)totalDuration error:(NSError *)error;

@required
- (void)didRecordingMultiVideosSuccess:(NSArray *)outputFilesURL;
- (void)didRecordingVideosSuccess:(NSURL *)outputFileURL;
- (void)didRecordingVideosError:(NSError*)error;

- (void)didTakePictureSuccess:(NSString *)outputFile;
- (void)didTakePictureError:(NSError*)error;

@end

@interface CCCameraManger : NSObject

@property (weak, nonatomic) id <TJCameraRecorderDelegate> delegate;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) BOOL faceRecognition;
@property (nonatomic, copy) void(^getimageBlock)(UIImage *image);
@property (nonatomic, assign) BOOL isStartGetImage; // 是否开始从输出数据流捕捉单一图像帧

- (instancetype)initWithParentView:(UIView *)parent;

- (void)startUp;
// 开启闪光灯
- (void)openFlashLight;
// 关闭闪光灯z
- (void)closeFlashLight;
// 切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
// 拍照
- (void)takePhotoWithImageBlock:(void(^)(UIImage *originImage,UIImage *scaledImage,UIImage *croppedImage))block;
// 对焦
- (void)focusInPoint:(CGPoint)devicePoint;

//切换到摄像模式
- (void)changeToVideo;
- (void)changeToPhoto;

- (void)startRecordingToOutputFileURL:(NSURL *)fileURL;
- (void)stopCurrentVideoRecording;

- (void)deleteAllVideo;
- (void)deleteLastVideo;

- (void)endVideoRecording;

// 现在录了多少视频
- (NSUInteger)getVideoCount;
@end
