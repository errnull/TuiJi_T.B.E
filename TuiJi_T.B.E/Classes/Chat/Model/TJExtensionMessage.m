//
//  TJExtensionMessage.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJExtensionMessage.h"

@implementation TJExtensionMessage

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{TJType : @(self.type),
                           TJData : self.value}; 
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}


@end
