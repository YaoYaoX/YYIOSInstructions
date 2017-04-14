//
//  YYCoverView.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//  带有半透明背景的弹出框

#import <UIKit/UIKit.h>

@interface YYCoverView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign) BOOL   dismissWhenTap;

- (void)show;
- (void)dismiss;

@end
