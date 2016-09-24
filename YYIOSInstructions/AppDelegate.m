//
//  AppDelegate.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "AppDelegate.h"
#import "YYLaunchViewController.h"
#import "YYTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建window
    YYLaunchViewController *launchVC = [[YYLaunchViewController alloc] init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = launchVC;
    [self.window makeKeyAndVisible];
    
    // 延长启动时间
    __weak typeof (self) weakSelf = self;
    YYTabBarController *tabVC = [[YYTabBarController alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.window.rootViewController = tabVC;
    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/// app当前正在展示的控制器
- (UIViewController *)currentController{
    
    // 从rootController开始，检索出下一个根控制器，以便继续搜索出app正展示的controller
    UIViewController *(^getNextRootController)(UIViewController *) = ^(UIViewController *rootController){
        
        UIViewController *nextRootVC = rootController;
        
        if (rootController.presentedViewController) {
            
            UIViewController *presentedVC = rootController.presentedViewController;
            
            // 如果presentedVC是系统控制器，默认先dismiss，在搜寻
            if ([presentedVC isKindOfClass:[UIImagePickerController class]]){
                [presentedVC dismissViewControllerAnimated:NO completion:nil];
            } else {
                // 如果控制器有modal过controller，presentedViewController为下一个rootVC
                nextRootVC = presentedVC;
            }
        }
        
        if ([nextRootVC isKindOfClass:[UINavigationController class]]){
            // 如果为导航控制器，rootVC为childViewControllers的最后一个
            nextRootVC = [(UINavigationController *)rootController childViewControllers].lastObject;
        } else if ([nextRootVC isKindOfClass:[UITabBarController class]]) {
            // 如果是tabbar控制器，rootVC则是选中的选中tab的controller
            nextRootVC = [(UITabBarController *)rootController selectedViewController];
        }
        
        return nextRootVC;
    };
    
    // 根控制器
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *nextRootVC = getNextRootController(rootVC);
    UIViewController *currentVC = rootVC;
    while (currentVC != nextRootVC) {
        currentVC = nextRootVC ;
        nextRootVC = getNextRootController(nextRootVC);
    }
        
    return currentVC;
}

@end
