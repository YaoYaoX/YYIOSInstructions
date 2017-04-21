//
//  YYCustomViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/21.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYCustomViewController.h"
#import "YYDashView.h"

@implementation YYCustomViewController

- (void)setupSubviews{

    CGSize size = self.view.frame.size;
    YYDashView *dashview = [[YYDashView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    dashview.center = CGPointMake(size.width*0.5, 100);
    [self.view addSubview:dashview];
    [dashview doAnimation];
}
@end
