//
//  YYTransitionMainController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/9/23.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYTransitionMainController.h"
#import "YYTransitionTestViewController.h"
#import "YYTransitionDelegate.h"
#import "YYSwipInteractiveTransition.h"
#import "YYTransitionDelegate.h"

@interface YYTransitionMainController ()

@property (nonatomic, weak) UISegmentedControl *segmentC;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, strong) id transitionDelegate;

@end

@implementation YYTransitionMainController

#pragma mark - UI

- (void)setupSubviews{
    
    self.title = @"Transition";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    
    //自定义动画
    UIButton *animateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    animateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [animateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [animateBtn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [animateBtn setTitle:@"自定义动画" forState:UIControlStateNormal];
    animateBtn.tag = 1000;
    [self.view addSubview:animateBtn];
    
    //自定义手势
    UIButton *interectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    interectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [interectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [interectBtn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [interectBtn setTitle:@"自定义手势" forState:UIControlStateNormal];
    interectBtn.tag = 2000;
    [self.view addSubview:interectBtn];
    
    //自定义动画＋手势
    UIButton *aniIntBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    aniIntBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [aniIntBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [aniIntBtn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [aniIntBtn setTitle:@"自定义动画＋手势" forState:UIControlStateNormal];
    aniIntBtn.tag = 3000;
    [self.view addSubview:aniIntBtn];
    
    //显示方式
    UISegmentedControl *segC = [[UISegmentedControl alloc]initWithItems:@[@"push", @"present"]];
    segC.frame = CGRectMake(0, 0, 150, 20);
    segC.selectedSegmentIndex = 0;
    [segC addTarget:self action:@selector(segCValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC];
    self.isPush = YES;
    self.segmentC = segC;
    
    //中心布局
    segC.center = CGPointMake(kScreenWidth*0.5, 150);
    animateBtn.center = CGPointMake(kScreenWidth*0.5, CGRectGetMaxY(segC.frame)+30);
    interectBtn.center = CGPointMake(kScreenWidth*0.5, CGRectGetMaxY(animateBtn.frame)+20);
    aniIntBtn.center = CGPointMake(kScreenWidth*0.5, CGRectGetMaxY(interectBtn.frame)+20);

}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)segCValueChanged{
    self.isPush = self.segmentC.selectedSegmentIndex == 0;
}

#pragma mark - test action

/// Animaiton Test
- (void)buttonDidClicked:(UIButton *)btn{
    
    // 1.设置toViewController
    YYTransitionTestViewController *toVC = [[YYTransitionTestViewController alloc] init];
    toVC.type = self.isPush? YYTransitionTypePush:YYTransitionTypePresent;
    
    // 2.转场代理设置
    YYTransitionDelegate *delegate = [YYTransitionDelegate delegateWithController:toVC];
    delegate.transitionType = self.isPush? YYTransitionTypePush : YYTransitionTypePresent;
    switch (btn.tag) {
        case 1000://自定义动画
            delegate.needAnimation = YES;
            delegate.needInteraction = NO;
            break;
            
        case 2000://自定义手势
            delegate.needAnimation = NO;
            delegate.needInteraction = YES;
            break;
            
        case 3000://自定义动画＋手势
            delegate.needAnimation = YES;
            delegate.needInteraction = YES;
            break;
            
        default:
            break;
    }
    
    // 3.跳转并修改转场代理
    self.transitionDelegate = delegate;//需要强引用，不然会被释放
    if (self.isPush) {
        self.navigationController.delegate = delegate;
        [self.navigationController pushViewController:toVC animated:YES];
    } else {
        toVC.transitioningDelegate = delegate;
        [self presentViewController:toVC animated:YES completion:nil];
    }
}

@end
