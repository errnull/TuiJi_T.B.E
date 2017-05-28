//
//  TJBaseLabel.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJBaseLabel.h"

@implementation TJBaseLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.font = TJFontWithSize(18);
    }
    
    return self;
}
@end
