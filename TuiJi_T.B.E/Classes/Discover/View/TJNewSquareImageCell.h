//
//  TJNewSquareImageCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJSquareNews;
@class TJTimeLine;
@interface TJNewSquareImageCell : UICollectionViewCell

@property (nonatomic, strong) TJSquareNews *squareNews;
@property (nonatomic, strong) TJTimeLine *timeLine;

@end
