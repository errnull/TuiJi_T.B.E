//
//  TJAutoLayoutor.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAutoLayoutor.h"
#import "Masonry.h"

//布局错误提示和错误断言
#define TJLayoutZeroSizeErrorMsg @"The value of view's size must not be CGSizeZero"
#define TJLayoutZeroSizeErrorAssert(view) NSAssert(!CGSizeEqualToSize(view.tjSize, CGSizeZero), TJLayoutZeroSizeErrorMsg)

@implementation TJAutoLayoutor

//清除约束
+ (void)removeLayoutsFromView:(UIView *)view
{
    CGSize size = view.size;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    view.frame = TJRectFromSize(size);
}

+ (void)removeLayoutsFromViewsList:(NSArray *)viewsList
{
    for (UIView *view in viewsList) {
        [self removeLayoutsFromView:view];
    }
}

//中间定位
+ (void)layView:(UIView *)view fullOfTheView:(UIView *)superView
{
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).insets(UIEdgeInsetsZero);
    }];
}
+ (void)layView:(UIView *)view atCenterOfTheView:(UIView *)superView offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(view);
    [superView addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView).with.offset(-offset.width);
        make.centerY.equalTo(superView).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:view targetView:superView maker:make];
    }];
    
}
+ (void)layView:(UIView *)view atTheView:(UIView *)superView margins:(UIEdgeInsets)margins
{
    if (UIEdgeInsetsEqualToEdgeInsets(margins,UIEdgeInsetsZero)) {
        [self layView:view fullOfTheView:superView];
    }else{
        [superView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView).insets(margins);
        }];
    }
}


//左边定位
+ (void)layView:(UIView *)subview atTheLeftTopOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).with.offset(offset.width);
        make.top.equalTo(container).with.offset(offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}
+ (void)layView:(UIView *)subview atTheLeftMiddleOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).with.offset(offset.width);
        make.centerY.equalTo(container).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}
+ (void)layView:(UIView *)subview atTheLeftBottomOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).with.offset(offset.width);
        make.bottom.equalTo(container).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}

//右边定位
+ (void)layView:(UIView *)subview atTheRightTopOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container).with.offset(-offset.width);
        make.top.equalTo(container).with.offset(offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}
+ (void)layView:(UIView *)subview atTheRightMiddleOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container).with.offset(-offset.width);
        make.centerY.equalTo(container).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}
+ (void)layView:(UIView *)subview atTheRightBottomOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container).with.offset(-offset.width);
        make.bottom.equalTo(container).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}

//上下定位
+ (void)layView:(UIView *)subview atTheTopMiddleOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container).with.offset(-offset.width);
        make.top.equalTo(container).with.offset(offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}
+ (void)layView:(UIView *)subview atTheBottomMiddleOfTheView:(UIView *)container offset:(CGSize)offset
{
    TJLayoutZeroSizeErrorAssert(subview);
    [container addSubview:subview];
    __weak typeof(self) weakSelf = self;
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container).with.offset(-offset.width);
        make.bottom.equalTo(container).with.offset(-offset.height);
        [weakSelf fs_setWidthOrHeightForView:subview targetView:container maker:make];
    }];
}


//根据类型，外部定位
+ (void)layView:(UIView *)sourceView toTheLeftOfTheView:(UIView *)targetView span:(CGSize)span
{
    [self layView:sourceView toTheLeftOfTheView:targetView span:span alignmentType:AlignmentCenter];
}
+ (void)layView:(UIView *)sourceView toTheLeftOfTheView:(UIView *)targetView span:(CGSize)span alignmentType:(TJLayoutAlignmentType)alignmentType
{
    TJLayoutZeroSizeErrorAssert(sourceView);
    [targetView.superview addSubview:sourceView];
    __weak typeof(self) weakSelf = self;
    [sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        [weakSelf fs_setWidthOrHeightForView:sourceView targetView:targetView.superview maker:make];
        make.left.equalTo(targetView).with.offset(-CGRectGetWidth(sourceView.frame)-span.width);
        if (AlignmentTop == alignmentType) {
            make.top.equalTo(targetView).with.offset(-span.height);
        }else if (AlignmentBottom == alignmentType){
            make.bottom.equalTo(targetView).with.offset(-span.height);
        }else{
            make.centerY.equalTo(targetView).with.offset(-span.height);
        }
    }];
}



+ (void)layView:(UIView *)sourceView toTheRightOfTheView:(UIView *)targetView span:(CGSize)span
{
    [self layView:sourceView toTheRightOfTheView:targetView span:span alignmentType:AlignmentCenter];
}
+ (void)layView:(UIView *)sourceView toTheRightOfTheView:(UIView *)targetView span:(CGSize)span alignmentType:(TJLayoutAlignmentType)alignmentType
{
    TJLayoutZeroSizeErrorAssert(sourceView);
    [targetView.superview addSubview:sourceView];
    __weak typeof(self) weakSelf = self;
    [sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        [weakSelf fs_setWidthOrHeightForView:sourceView targetView:targetView.superview maker:make];
        make.right.equalTo(targetView).with.offset(CGRectGetWidth(sourceView.frame)+span.width);
        if (AlignmentTop == alignmentType) {
            make.top.equalTo(targetView).with.offset(-span.height);
        }else if (AlignmentBottom == alignmentType){
            make.bottom.equalTo(targetView).with.offset(-span.height);
        }else{
            make.centerY.equalTo(targetView).with.offset(-span.height);
        }
    }];
}



+ (void)layView:(UIView *)sourceView aboveTheView:(UIView *)targetView span:(CGSize)span
{
    [self layView:sourceView aboveTheView:targetView span:span alignmentType:AlignmentCenter];
}
+ (void)layView:(UIView *)sourceView aboveTheView:(UIView *)targetView span:(CGSize)span alignmentType:(TJLayoutAlignmentType)alignmentType
{
    TJLayoutZeroSizeErrorAssert(sourceView);
    [targetView.superview addSubview:sourceView];
    __weak typeof(self) weakSelf = self;
    [sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        [weakSelf fs_setWidthOrHeightForView:sourceView targetView:targetView.superview maker:make];
        make.top.equalTo(targetView).with.offset(-CGRectGetHeight(sourceView.frame)-span.height);
        if (AlignmentLeft == alignmentType) {
            make.left.equalTo(targetView).with.offset(-span.width);
        }else if (AlignmentRight == alignmentType){
            make.right.equalTo(targetView).with.offset(-span.width);
        }else{
            make.centerX.equalTo(targetView).with.offset(-span.width);
        }
    }];
}


+ (void)layView:(UIView *)sourceView belowTheView:(UIView *)targetView span:(CGSize)span
{
    [self layView:sourceView belowTheView:targetView span:span alignmentType:AlignmentCenter];
}
+ (void)layView:(UIView *)sourceView belowTheView:(UIView *)targetView span:(CGSize)span alignmentType:(TJLayoutAlignmentType)alignmentType
{
    TJLayoutZeroSizeErrorAssert(sourceView);
    [targetView.superview addSubview:sourceView];
    __weak typeof(self) weakSelf = self;
    [sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        [weakSelf fs_setWidthOrHeightForView:sourceView targetView:targetView.superview maker:make];
        make.bottom.equalTo(targetView).with.offset(CGRectGetHeight(sourceView.frame)+span.height);
        if (AlignmentLeft == alignmentType) {
            make.left.equalTo(targetView).with.offset(-span.width);
        }else if (AlignmentRight == alignmentType){
            make.right.equalTo(targetView).with.offset(-span.width);
        }else{
            make.centerX.equalTo(targetView).with.offset(-span.width);
        }
    }];
}

#pragma mark - 设定空间宽高
+ (void)fs_setWidthOrHeightForView:(UIView *)sourceView targetView:(UIView *)targetView maker:(MASConstraintMaker *)make
{
    if (CGRectGetWidth(sourceView.frame) == 0) {
        make.width.equalTo(targetView);
    }else{
        make.width.mas_equalTo(@(CGRectGetWidth(sourceView.frame)));
    }
    
    if (CGRectGetHeight(sourceView.frame) == 0) {
        make.height.equalTo(targetView);
    }else{
        make.height.mas_equalTo(@(CGRectGetHeight(sourceView.frame)));
    }
}


@end
