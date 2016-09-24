//
//  YYTransitionMainNavController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYTransitionMainNavController.h"
#import "YYTransitionDelegate.h"
#import "YYTransitionMainController.h"
#import "YYSwipInteractiveTransition.h"

@interface YYTransitionMainNavController ()

@end

@implementation YYTransitionMainNavController

+ (instancetype)controller{
    
    YYTransitionMainController *rootVC = [[YYTransitionMainController alloc] init];
    YYTransitionMainNavController *MC = [[YYTransitionMainNavController alloc] initWithRootViewController:rootVC];
    return MC;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

@end
