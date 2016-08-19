//
//  YYScrollTabBar.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYScrollTabBar;

@protocol YYScrollTabBarDelegate <NSObject>

@optional
-(void)scrollTabBar:(YYScrollTabBar *)tabBar didSelectedItemAtIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex;

@end


@interface YYScrollTabBar : UIView

@property (nonatomic, assign) NSInteger                 selectedIndex;
@property (nonatomic, weak) id<YYScrollTabBarDelegate>  delegate;

- (void)addItemWithTitle:(NSString *)title;
/** 通过百分比设置指示线位置 */
- (void)setIndicatorXPercent:(CGFloat)indicatorPercent;

@end