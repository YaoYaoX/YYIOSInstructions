//
//  YYMiddleController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYMiddleController.h"

@interface YYMiddleController ()

@end

@implementation YYMiddleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    // 图片压缩地址
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"middleImg.jpg" ofType:nil]];
    [self.view addSubview:imageView];
    
    [self addCloseButton];
}

// 方法[[UIApplication sharedApplication] setStatusBarHidden:Yes]在ios9已废弃，通过重写以下方法隐藏statusBar
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
