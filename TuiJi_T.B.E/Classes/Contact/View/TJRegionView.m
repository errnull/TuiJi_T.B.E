//
//  TJRegionView.m
//  ViewTest
//
//  Created by TUIJI on 16/8/13.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJRegionView.h"

@interface TJRegionView ()

@property (weak, nonatomic) IBOutlet UILabel *countryView;

@property (weak, nonatomic) IBOutlet UIImageView *flagView;

@end

@implementation TJRegionView


- (instancetype)initWithRegionStr:(NSString *)regionStr font:(UIFont *)font
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TJRegionView" owner:nil options:nil] lastObject];
        
        [self setUpAllSubViewsRegionStr:regionStr font:font];
        
    }
    return self;
}


#pragma mark - private method
- (void)setUpAllSubViewsRegionStr:(NSString *)regionStr font:(UIFont *)font
{
    regionStr = TJStringIsNull(regionStr) ? @"中国_&CHI" : regionStr;
    regionStr = ([regionStr isEqualToString:@"null"]) ? @"中国_&CHI" : regionStr;
    //将地区和flag标识分开
    NSRange range = [regionStr rangeOfString:TJFlagRange];
    NSString *originalStr;
    NSString *flagStr;
    
        originalStr = [regionStr substringToIndex:range.location];
        flagStr = [regionStr substringFromIndex:range.location+range.length];

    
    self.countryView.text = originalStr;
    self.countryView.font = font;

    UIImage *flag = [UIImage imageNamed:flagStr];
    self.flagView.image = flag;
    
    CGSize strSize = [originalStr sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat flagW = (strSize.height - 4) * (flag.size.width / flag.size.height);
    
    self.width = strSize.width + 4 + flagW + 2;
    self.height = strSize.height;
    
}

@end
