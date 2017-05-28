//
//  TJURLTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/27.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJURLTool.h"
#import "TJURLList.h"

static TJURLList *_urlList;

@implementation TJURLTool

+ (TJURLList *)URLList
{
    if (!_urlList) {
        
        _urlList = [[TJURLList alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"urlList" ofType:@"plist"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        [_urlList setValuesForKeysWithDictionary:dic];
        
    }
    return _urlList;
}
@end
