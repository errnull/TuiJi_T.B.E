//
//  TJSimpleImageFilterViewController.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSimpleImageFilterViewController.h"
#import "FWApplyFilter.h"

#import "GPUImage.h"
#import "SVProgressHUD.h"

#import "CustomImageCell.h"

static NSString *staticCell=@"CustomImageCell";

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface TJSimpleImageFilterViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

{
    NSArray *_filterArray;
    NSMutableArray *_imageArray;
    
    BOOL _DidLayoutSubViews;
}
@property (weak, nonatomic) IBOutlet UICollectionView *bottomScrollView;








/**
 *  last frame of showImgView
 */
@property (nonatomic, assign) CGRect latestFrame;

/**
 *  old frame of showImgView
 */
@property (nonatomic, assign) CGRect oldFrame;

/**
 *  largeFrame of showImgView
 */
@property (nonatomic, assign) CGRect largeFrame;

/**
 *  image show in this view
 */
@property (nonatomic, weak) UIImageView *showImgView;

/**
 *  overlay view (蒙板)
 */
@property (weak, nonatomic) IBOutlet UIView *overlayView;

/**
 *  ratio view
 */
@property (weak, nonatomic) IBOutlet UIView *ratioView;

/**
 *  image up mirrored button
 */
@property (nonatomic, weak) UIButton *upMirroredButton;
/**
 *  confirm button
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/**
 *  cancel button
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)cancelBtnClick:(UIButton *)sender;
- (IBAction)finishBtnClick:(UIButton *)sender;
- (IBAction)upMirrorBtnClick:(UIButton *)sender;


@end

@implementation TJSimpleImageFilterViewController

- (instancetype)initWithImage:(UIImage *)originalImage
                    cropFrame:(CGRect)cropFrame
              limitScaleRatio:(CGFloat)limitRatio
{
    if (self = [super init]) {
        _cropFrame = cropFrame;
        _limitRatio = limitRatio;
        _originalImage = originalImage;
        [self initSubViews];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filterArray=@[@"无",@"心情",@"怀旧",@"老电影",@"好日子"
                   ,@"星空",@"时尚",@"生日",@"心动",@"浪漫"
                   ,@"星光",@"雨天",@"花语",@"经典"];
    _imageArray=@[].mutableCopy;
    
    [self createUI];
    
    
}

/**
 *  Layout all sub views
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

///**
// *  不支持屏幕旋转 解决头像其他方向的问题
// */
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    return NO;
//}

- (UIImage *)applyNashvilleFilter:(UIImage *)image :(GPUImageOutput<GPUImageInput> *)imageFilter
{
    [imageFilter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:imageFilter];
    [pic processImage];
    [imageFilter useNextFrameForImageCapture];
    return [imageFilter imageFromCurrentFramebuffer];
}

#pragma mark - Private Method
- (void)initSubViews
{
    
    //image show in this view
    CGFloat showImgW = _cropFrame.size.width;
    UIImageView *showImgView = [TJUICreator createImageViewWithSize:CGSizeMake(showImgW, _originalImage.size.height * (showImgW / _originalImage.size.width))];
    [showImgView setMultipleTouchEnabled:YES];
    [showImgView setUserInteractionEnabled:YES];
    [showImgView setImage:_originalImage];
    
    [self addGestureRecognizers];
    _showImgView = showImgView;
    [self.view addSubview:_showImgView];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (self.ratioView.width >TJWidthDevice || _DidLayoutSubViews) {
        return;
    }
    
    [self.view sendSubviewToBack:_showImgView];
    _showImgView.center = _ratioView.center;
    
    self.latestFrame = self.showImgView.frame;
    self.oldFrame = self.showImgView.frame;
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    //切出窗口
    [self overLayClipping];
    
    _DidLayoutSubViews = YES;
}

/**
 *  overlay clipping
 */
- (void)overLayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    //Left side of the ratio view
    CGPathAddRect(path, nil, TJRectFromSize(CGSizeMake(self.ratioView.x, self.overlayView.height)));
    
    //Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(self.ratioView.x + self.ratioView.width,
                                        0,
                                        self.overlayView.width - self.ratioView.x - _ratioView.width,
                                        self.overlayView.height));
    
    //Top side of the ratio view
    CGPathAddRect(path, nil, TJRectFromSize(CGSizeMake(self.overlayView.width, self.ratioView.y)));
    
    //Buttom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.ratioView.y + self.ratioView.height,
                                        self.overlayView.width,
                                        self.overlayView.height - self.ratioView.y + self.ratioView.height));
    
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}




- (void)createUI
{
    
    _bottomScrollView.delegate=self;
    _bottomScrollView.dataSource=self;
    [_bottomScrollView registerNib:[UINib nibWithNibName:@"CustomImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:staticCell];
    dispatch_async(dispatch_queue_create("create.ui.com", DISPATCH_QUEUE_SERIAL), ^{
        
        UIImage *image = _originalImage;
        
        //得到基础的图片后 然后将
        //准备资源
        [_imageArray addObject:image];
        
        for (int i=1; i<_filterArray.count; i++) {
            
            switch (i) {
                case 1:
                {
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[TJ1977Filter alloc] init]]];
                    
                    [self imageArray:_imageArray addFilter:[[FWNashvilleFilter alloc] init]];
                    
                    
                }
                    break;
                    //无
                case 2:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWLordKelvinFilter alloc] init]];
                    
                    
                    
                    
                    
                    
                }
                    break;
                    //无
                case 3:
                {
                    [self imageArray:_imageArray addFilter:[[FWRiseFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWRiseFilter alloc] init]]];
                    
                    
                }
                    break;
                    //无
                case 4:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWXproIIFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWXproIIFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 5:
                {
                    [self imageArray:_imageArray addFilter:[[FWWaldenFilter alloc] init]];
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWWaldenFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 6:
                {
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWEarlybirdFilter alloc] init]]];
                    [self imageArray:_imageArray addFilter:[[FWEarlybirdFilter alloc] init]];
                    
                }
                    break;
                    //无
                case 7:
                {
                    [self imageArray:_imageArray addFilter:[[FWToasterFilter alloc] init]];
                    
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWToasterFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 8:
                {
                    [self imageArray:_imageArray addFilter:[[FWBrannanFilter alloc] init]];
                    
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWBrannanFilter alloc] init]]];
                    
                }
                    break;
                case 9:
                {
                    [self imageArray:_imageArray addFilter:[[FWInkwellFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWInkwellFilter alloc] init]]];
                    
                }
                    break;
                case 10:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWSierraFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWSierraFilter alloc] init]]];
                    
                }
                    break;
                case 11:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWHefeFilter alloc] init]];
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWHefeFilter alloc] init]]];
                    
                    
                }
                    break;
                case 12:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWValenciaFilter alloc] init]];
                    
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWValenciaFilter alloc] init]]];
                    
                }
                    break;
                case 13:
                {
                    
                    [self imageArray:_imageArray addFilter:[[FWSutroFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWSutroFilter alloc] init]]];
                }
                    break;
                case 14:
                {
                    
                    
                    [self imageArray:_imageArray addFilter:[[FWAmaroFilter alloc] init]];
                    //                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWAmaroFilter alloc] init]]];
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
        
        
        if (_imageArray.count-_filterArray.count==0) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                [_bottomScrollView reloadData];
//                [_juhuaUI stopAnimating];
//                
//                _juhuaUI.hidden=YES;
                
                
                //                for(int i=0;i<_filterArray.count;i++)
                //                {
                //
                //                    CustomClickView *button=[[CustomClickView alloc] initWithFrame:CGRectMake(i*115+10*(i+1), 0, 115, 115) :imageArray[i] :_filterArray[i]];
                //                    button.tag=9000+i;
                //
                //                    [button addTarget:self action:@selector(addFilterToMovie:) forControlEvents:UIControlEventTouchUpInside];
                //                    [_bottomScrollView addSubview:button];
                //                }
                //
                //                [_bottomScrollView setContentSize:CGSizeMake(_filterArray.count*115+10*(_filterArray.count+1), 0)];
                
                
                
            });
        }
    });
}

- (void)imageArray:(NSMutableArray *)imageArray addFilter:(GPUImageFilterGroup *)Filter{
    
    UIImage *filterImage = [self applyNashvilleFilter:[imageArray firstObject] : Filter];
    
    if (!filterImage) {
        filterImage = [imageArray firstObject];
    }
    
    [imageArray addObject:filterImage];
    
}

#pragma mark -瀑布流

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count>0?_imageArray.count:0;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    UIImage *image = _imageArray[indexPath.row];
    
    self.showImgView.image = image;
    
    self.originalImage = image;
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake(125, 125);
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomImageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:staticCell forIndexPath:indexPath];
    cell.filterImage.image=_imageArray[indexPath.row];
    cell.filterLab.text=_filterArray[indexPath.row];
    
    return cell;
    
}





/**
 *  register all gestures
 */
- (void)addGestureRecognizers
{
    //add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    //add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

/**
 *  pinch gesture handler
 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        
        
        
        
        //        newFrame = CGRectMake(newFrame.origin.x + (newFrame.size.width / 8.0), newFrame.origin.y, newFrame.size.width * (3/4.0), newFrame.size.height * (3/4.0));
        
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
    
}

/**
 *  pan gesture handler
 */
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
    
}


- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = CGRectMake(self.oldFrame.origin.x, self.oldFrame.origin.y, self.oldFrame.size.width * 0.75, self.oldFrame.size.height * 0.75);
        //        NSLog(@"%f..%f..%f..%f",self.oldFrame.origin.x,self.oldFrame.origin.y,self.oldFrame.size.width,self.oldFrame.size.height);
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    
    CGRect cropFrame = self.cropFrame;
    
    if (newFrame.size.width > cropFrame.size.width) {
        cropFrame = CGRectMake(self.cropFrame.origin.x + (self.cropFrame.size.width / 8.0), self.cropFrame.origin.y, self.cropFrame.size.width * 0.75, self.cropFrame.size.height);
    }
    
    // horizontally
    if (newFrame.origin.x > cropFrame.origin.x){
        newFrame.origin.x = cropFrame.origin.x;
    }
    
    if (CGRectGetMaxX(newFrame) < cropFrame.size.width){
        newFrame.origin.x = (self.cropFrame.size.width - newFrame.size.width) * 0.5;
    }
    // vertically
    if (newFrame.origin.y > cropFrame.origin.y){
        newFrame.origin.y = cropFrame.origin.y;
    }
    
    if (CGRectGetMaxY(newFrame) < cropFrame.origin.y + cropFrame.size.height) {
        newFrame.origin.y = cropFrame.origin.y + cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= cropFrame.size.height) {
        newFrame.origin.y = cropFrame.origin.y + (cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}



- (IBAction)cancelBtnClick:(UIButton *)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([self.delegate respondsToSelector:@selector(imageCropperDidCancel:)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (IBAction)finishBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imageCropper:didFinished:)]) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}

- (IBAction)upMirrorBtnClick:(UIButton *)sender {
    UIImage *upMirrorImage = [_showImgView.image imageToUpMirrored];
    [_showImgView setImage:upMirrorImage];
    _originalImage = upMirrorImage;
    
}

-(UIImage *)getSubImage{
    //    _originalImage = _showImgView.image;
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    
    
    
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    
    
    if ((squareFrame.origin.x - self.latestFrame.origin.x) < 0) {
        
        x = 0;
        y = (self.cropFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
        w = self.latestFrame.size.width / scaleRatio;
        h = ((self.cropFrame.size.width * self.cropFrame.size.width) / self.latestFrame.size.width) / scaleRatio;
        
    }
    if ((squareFrame.origin.y - self.latestFrame.origin.y) < 0) {
        x = (self.cropFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
        y = 0;
        w = ((self.cropFrame.size.height * self.cropFrame.size.height) / self.latestFrame.size.height) / scaleRatio;
        h = self.latestFrame.size.height / scaleRatio;
    }
    
    if (self.latestFrame.size.width == self.latestFrame.size.height) {
        x = 0;
        y = 0;
        w = self.latestFrame.size.width / scaleRatio;
        h = self.latestFrame.size.height / scaleRatio;
    }
    
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end
