//
//  BLImageSize.h
//  ViewTest
//
//  Created by TUIJI on 16/9/27.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface BLImageSize : NSObject
singleton_interface(BLImageSize)
/**
 获取网络图片的Size, 先通过文件头来获取图片大小
 如果失败 会下载完整的图片Data 来计算大小 所以最好别放在主线程
 如果你有使用SDWebImage就会先看下 SDWebImage有缓存过改图片没有
 支持文件头大小的格式 png、gif、jpg
 */
+ (CGSize)downloadImageSizeWithURL:(id)imageURL;
@end
