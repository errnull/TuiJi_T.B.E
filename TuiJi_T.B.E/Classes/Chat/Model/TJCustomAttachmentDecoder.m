//
//  TJCustomAttachmentDecoder.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCustomAttachmentDecoder.h"
#import "NSDictionary+NTESJson.h"
#import "TJExtensionMessageDefine.h"
#import "TJExtensionMessage.h"

@implementation TJCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    
    id<NIMCustomAttachment> attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:TJType];
            NSDictionary *data = [dict jsonDict:TJData];
            
            
            switch (type) {
                case 6:
                {
                    attachment = [[TJExtensionMessage alloc] init];
                    ((TJExtensionMessage *)attachment).type = type;
                    ((TJExtensionMessage *)attachment).value = data;
                }
                    break;
                case 5:
                {
                    attachment = [[TJExtensionMessage alloc] init];
                    ((TJExtensionMessage *)attachment).type = type;
                    ((TJExtensionMessage *)attachment).value = data;
                }
                    break;
            }
        }
    }
    return attachment;
}

@end

