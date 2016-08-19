//
//  UIColor+Additions.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)grayColorWithValue:(NSInteger)value;
+ (UIColor *)grayColorWithValue:(NSInteger)value alpha:(CGFloat)alpha;

@end
