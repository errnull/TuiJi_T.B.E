//
//  TJNewFeatureCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewFeatureCell.h"

@interface TJNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation TJNewFeatureCell


/**
 *  懒加载
 */
- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        
        [self.contentView addSubview:_imageView];
        
    }
    return _imageView;
}

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;
        
    }
    return _startButton;
}

/**
 *  setter
 */
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = _image;
}

/**
 *  布局
 */
- (void)layoutSubviews{
    [TJAutoLayoutor layView:_imageView fullOfTheView:self.contentView];
    
    // 开始按钮
    self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.9);
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.startButton.hidden = NO;
        
        
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.startButton.hidden = YES;
    }
}

/**
 *  开始微博按钮监听
 */
- (void)start
{
    [TJGuideTool guideRootViewController:TJKeyWindow];
}
@end
