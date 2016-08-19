//
//  UIColor+Additions.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)


+ (UIColor *)colorWithHex:(NSInteger)hex{
    
    return  [self colorWithHex:hex alpha:1];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha{
    
    CGFloat red = ((hex & 0xFF0000) >> 16)/255.0;
    CGFloat green = ((hex & 0xFF00) >> 8)/255.0;
    CGFloat blue = (hex & 0xFF)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)grayColorWithValue:(NSInteger)value{
    
    return [self grayColorWithValue:value alpha:1];
}

+ (UIColor *)grayColorWithValue:(NSInteger)value alpha:(CGFloat)alpha{
    
    CGFloat colorValue = value/255.0;
    return [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:alpha];
}
@end
