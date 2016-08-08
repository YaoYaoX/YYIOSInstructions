//
//  UIImage+Additions.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    
    // 获取参数
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 画
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, r, g, b, a);
    CGContextFillRect(contextRef, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
