//
//  TJDropDownMenu.h
//  自定制下拉菜单
//
//  Created by hezhijingwei on 16/6/28.
//  Copyright © 2016年 秦传龙. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^indexPressedBlock)(NSInteger index);



// 箭头的方向
typedef NS_ENUM(NSInteger,TJDirectionType) {

    TJDirectionTypeTop, // 上
    TJDirectionTypeBottom, //下 默认是朝下的出现的
    TJDirectionTypeLeft, //左
    TJDirectionTypeRight, //右
//    TJDirectionTypeAutomatic NS_AVAILABLE(2_6, 4_0) // 自动待后期更新

};


@interface TJDropDownMenu : UIView

/**
 *  这个是用来设置弹出菜单的方向的
 */
@property (nonatomic, assign) TJDirectionType direction;

/**
 *  这个是用来设置弹出菜单title数组的
 */
@property (nonatomic ,strong) NSArray *dropDownMenuModel;


/*
 *  弹出菜单的设置 把他添加到适当的位置  一般添加到self.view上
 *
 *  @param frame        这个frame是btn在window的尺寸和位置的大小
 *  @param indexPressed 返回点击按钮的个数
 *
 *  @return 返回的是自己
 */
-(instancetype)initWithBtnPressedByWindowFrame:(CGRect)frame Pressed:(indexPressedBlock)indexPressed;





@end
