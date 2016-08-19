//
//  YYTabBarController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYTabBarController.h"
#import "YYTabBar.h"
#import "YYViewController.h"
#import "YYMiddleController.h"
#import "YYNavigationController.h"

@interface YYTabBarController ()

@end

@implementation YYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 统一设置颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:kFont(12), NSForegroundColorAttributeName:kColorTabTitle} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:kFont(8), NSForegroundColorAttributeName:kColorTabTitleSelected} forState:UIControlStateSelected];


    YYTabBar *tabbar = [[YYTabBar alloc]init];
    tabbar.delegate = self;
    [self setValue:tabbar forKey:@"tabBar"];

    
    [self addChildVC:@"YYScrollTabTestController"
            withIcon:@"yy_tab_1"
        selectedIcon:@"yy_tab_1_selected"
               title:kLocalString(@"Tab1")];
    
    
    [self addChildVC:@"YYViewController"
            withIcon:@"yy_tab_2"
        selectedIcon:@"yy_tab_2_selected"
               title:kLocalString(@"Tab2")];
    
    // 占位
    [self addChildViewController:[[UIViewController alloc] init]];
    
    
    [self addChildVC:@"YYViewController"
            withIcon:@"yy_tab_3"
        selectedIcon:@"yy_tab_3_selected"
               title:kLocalString(@"Tab3")];
    
    [self addChildVC:@"YYViewController"
            withIcon:@"yy_tab_4"
        selectedIcon:@"yy_tab_4_selected"
               title:kLocalString(@"Tab4")];
}

//添加子控制器
-(void)addChildVC:(NSString *)childVCName withIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon title:(NSString *)title{
    
    Class class = NSClassFromString(childVCName);
    UIViewController *childVC = [[class alloc]init];
    
    if ([childVC isKindOfClass:[UIViewController class]]) {
        
        // 图片不渲染
        childVC.tabBarItem.image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childVC.tabBarItem.title = title;

        // 让子控制器包装一个导航控制器
        YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:childVC];
        [self addChildViewController:nav];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item isKindOfClass:[UIButton class]]) {
        YYMiddleController *VC = [[YYMiddleController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
}

@end
