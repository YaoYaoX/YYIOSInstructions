//
//  YYPolygon.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/14.
//  Copyright © 2017年 YY. All rights reserved.
//  带圆弧的多边形View

#import <UIKit/UIKit.h>

@interface YYPolygon : UIView

/// 边数
@property (nonatomic, assign) NSUInteger numberOfSide;
/// 每次旋转时转动的角个数
@property (nonatomic, assign) NSUInteger rotateNum;

- (void)rotateToIndex:(NSUInteger)index;
@end
