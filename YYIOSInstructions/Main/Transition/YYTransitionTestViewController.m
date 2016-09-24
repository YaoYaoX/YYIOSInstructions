//
//  YYTransitionTestViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYTransitionTestViewController.h"

@interface YYTransitionTestViewController ()

@end

@implementation YYTransitionTestViewController

- (void)setupSubviews{

    self.navigationItem.title = @"transition";
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    dismissBtn.center = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5-30);
    [dismissBtn setTitle:@"返回" forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
}


- (void)dismissBtnDidClicked:(UIButton *)btn{
    
    id delegate = nil;
    
    if (self.type == YYTransitionTypePresent) {
        delegate = self.transitioningDelegate;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        delegate = self.navigationController.delegate;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
