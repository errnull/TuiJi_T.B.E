//
//  TJInPutView.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJInPutView : UIView

@property (nonatomic, assign) id target;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, weak) TJVerityButton *rightView;
/**
 *  set up method
 *
 *  @param size          inputView size
 *  @param imageNamed    left image name
 *  @param inPutViewType textField type
 *
 *  @return TJInPutView
 */
- (instancetype)initWithsize:(CGSize)size
                        Type:(TJInPutViewType)inPutViewType;

- (void)startAnimation;

@end
