//
//  YYNavigationController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/8.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYNavigationController.h"

@interface YYNavigationController ()

@end

@implementation YYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 处理tabbar的显示隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
