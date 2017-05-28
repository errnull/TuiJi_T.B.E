//
//  TJ1977Filter.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJ1977Filter.h"

NSString *const TJ1977ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation TJFilter1

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:TJ1977ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

@implementation TJ1977Filter

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    TJFilter1 *filter = [[TJFilter1 alloc] init];
    [self addFilter:filter];
    
    UIImage *image = [UIImage imageNamed:@"tuiji_1977"];
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
}

@end
