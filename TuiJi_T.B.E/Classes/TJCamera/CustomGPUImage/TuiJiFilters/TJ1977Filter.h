//
//  TJ1977Filter.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@interface TJFilter1 : GPUImageThreeInputFilter

@end


@interface TJ1977Filter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
}
@end
