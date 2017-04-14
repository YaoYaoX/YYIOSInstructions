//
//  YYViewController.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYViewController : UIViewController

@property (nonatomic, assign) BOOL hideNavBar;

- (void)addCloseButton;

/** 用于重写 */
- (void)setupSubviews;

@end
