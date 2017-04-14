//
//  YYViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYViewController.h"

@interface YYViewController ()

@end

@implementation YYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.tabBarItem.title;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.hideNavBar animated:true];
}

- (void)setupSubviews{
    
    CGFloat btnW = 200;
    UIButton *nextPage = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-btnW)*0.5, 200, btnW, 40)];
    nextPage.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextPage setTitle:kLocalString(@"NextPage") forState:UIControlStateNormal];
    [nextPage setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextPage addTarget:self action:@selector(nextPageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPage];
}

- (void)addCloseButton{
    
    CGFloat btnWH = 30;
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-btnWH-15, 20, btnWH, btnWH)];
    [closeBtn setImage:[UIImage imageNamed:@"yy_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)closeBtnClicked:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)nextPageAction:(UIButton *)btn{
    
    YYViewController *VC = [[YYViewController alloc]init];
    //VC.hideNavBar = arc4random_uniform(2)==1;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
