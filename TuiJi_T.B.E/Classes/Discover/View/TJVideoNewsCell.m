//
//  TJVideoNewsCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJVideoNewsCell.h"

//#import "ZXVideoPlayerController.h"
//#import "ZXVideo.h"

@interface TJVideoNewsCell ()

///**
// *  图标
// */
//@property (nonatomic, weak) UIImageView *iconView;
//
///**
// *  更多
// */
//@property (nonatomic, weak) UIButton *moreView;
//
///**
// *  视频框
// */
//@property (nonatomic, weak) UIView *videoView;
//
///**
// *  开始视频按钮
// */
//@property (nonatomic, weak) UIButton *beginVideoView;
//
///**
// *  发布时间
// */
//@property (nonatomic, weak) UILabel *timeView;
//
///**
// *  背景view
// */
//@property (nonatomic, weak) UIView *bgView;
//
//
//@property (nonatomic, strong) ZXVideo *video;
//
//@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@end

@implementation TJVideoNewsCell
//CGRect _frame;
//
//- (ZXVideo *)video{
//    if (!_video) {
//        _video = [[ZXVideo alloc] init];
//        _video.playUrl = @"http://player.youku.com/embed/XMTcwODc3NjMyNA==";
//        _video.title = @"Rollin'Wild 圆滚滚的";
//    }
//    return _video;
//}
//
///**
// *  init
// */
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        //创建所有子控件
//        [self setUpAllSubViews];
//        //自动布局
//        [self layoutAllSubViews];
//        self.backgroundColor = TJColor(245, 245, 245);
//    }
//    return self;
//}
//
//
//#pragma mark - private method
///**
// *  set up all sub views
// */
//- (void)setUpAllSubViews
//{
//    //图标
//    UIImageView *iconView = [TJUICreator createImageViewWithName:@"discover_youtobe" size:TJAutoSizeMake(58, 22)];
//    _iconView = iconView;
//    [self addSubview:_iconView];
//    
//    // 更多
//    UIButton *moreView = [TJUICreator createButtonWithSize:TJAutoSizeMake(30, 20)
//                                               NormalImage:@"discover_morePoint"
//                                          highlightedImage:@"discover_morePoint_h"
//                                                               target:self
//                                                    action:@selector(moreViewClick:)];
//    moreView.imageEdgeInsets = UIEdgeInsetsMake(5.5, 8, 5.5, 8);
//    _moreView = moreView;
//    [self addSubview:_moreView];
//    
//    //视频框
//    UIView *videoView = [TJUICreator createViewWithSize:TJAutoSizeMake(375, 270)
//                                           bgColor:TJColorGray
//                                            radius:0];
//    _videoView = videoView;
//    [self addSubview:_videoView];
//    
//    UIButton *beginVideoView = [TJUICreator createButtonWithSize:TJAutoSizeMake(25, 25)
//                                             NormalImage:@"kr-video-player-play"
//                                        highlightedImage:@""
//                                                  target:self
//                                                  action:@selector(beginVideoViewClick:)];
//    _beginVideoView = beginVideoView;
//    [_videoView addSubview:_beginVideoView];
//    
//    //时间
//    UILabel *timeView = [TJUICreator createLabelWithSize:TJAutoSizeMake(200, 20)
//                                                    text:@"10分钟前"
//                                                   color:TJColorGray
//                                                    font:TJFontWithSize(12)];
//    timeView.textAlignment = NSTextAlignmentRight;
//    _timeView = timeView;
//    [self addSubview:_timeView];
//    
//    // 背景view
//    UIView *bgView = [TJUICreator createViewWithSize:TJAutoSizeMake(361, 441)
//                                             bgColor:TJColorWhite
//                                              radius:0];
//    
//    _bgView = bgView;
//    [self addSubview:_bgView];
//}
//
///**
// *  layout All subViews
// */
//- (void)layoutAllSubViews
//{
////    [TJAutoLayoutor layView:_iconView atTheLeftTopOfTheView:self offset:TJAutoSizeMake(26, 19)];
////    [TJAutoLayoutor layView:_moreView atTheRightTopOfTheView:self offset:TJAutoSizeMake(20, 20)];
////    [TJAutoLayoutor layView:_videoView atCenterOfTheView:self offset:TJSizeWithHeight(-10)];
////    [TJAutoLayoutor layView:_beginVideoView atCenterOfTheView:_videoView offset:CGSizeZero];
////    [TJAutoLayoutor layView:_timeView atTheRightBottomOfTheView:self offset:TJAutoSizeMake(24, 4)];
////    
////    [TJAutoLayoutor layView:_bgView atTheView:self margins:UIEdgeInsetsMake(7, 7, 0, 7)];
////    [self sendSubviewToBack:_bgView];
//}
//
//#pragma mark - private method
//
//- (void)moreViewClick:(UIButton *)sender
//{
//    
//}
//
//- (void)beginVideoViewClick:(UIButton *)sender
//{
//    [self playVideo];
//}
//
//- (void)playVideo
//{
//    if (!self.videoController) {
//        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
//        
//        __weak typeof(self) weakSelf = self;
//        self.videoController.videoPlayerGoBackBlock = ^{
//            __strong typeof(self) strongSelf = weakSelf;
//            
////            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//            
////            [strongSelf.navigationController popViewControllerAnimated:YES];
////            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
//            
//            strongSelf.videoController = nil;
//        };
//        
//        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
//            NSLog(@"切换为竖屏模式");
//            weakSelf.videoView.frame = _frame;
//        };
//        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
//            _frame = weakSelf.videoView.frame;
//            NSLog(@"切换为全屏模式");
////            weakSelf.videoView.frame = TJRectFullVC;
//            [weakSelf.videoController showInView:TJKeyWindow];
//        };
//        
//        [self.videoController showInView:self.videoView];
//    }
//    self.videoController.video = self.video;
//}
@end
