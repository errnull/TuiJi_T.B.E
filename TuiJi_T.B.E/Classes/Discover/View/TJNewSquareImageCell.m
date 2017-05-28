//
//  TJNewSquareImageCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewSquareImageCell.h"

#import "TJSquareNews.h"
#import "TJTimeLine.h"

@interface TJNewSquareImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation TJNewSquareImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)setSquareNews:(TJSquareNews *)squareNews{
    _squareNews = squareNews;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_squareNews.imageUrl]
                  placeholderImage:[UIImage imageWithTJColor:TJColorWithRandomListAlpha(1)]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
                         }];
}

- (void)setTimeLine:(TJTimeLine *)timeLine{
    _timeLine = timeLine;

    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_timeLine.imgsUrl firstObject]]
                  placeholderImage:[UIImage imageWithTJColor:TJColorWithRandomListAlpha(1)]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                         }];
}
@end
