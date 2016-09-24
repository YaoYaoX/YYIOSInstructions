//
//  YYTransitionDelegate.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTransitonDefine.h"

@interface YYTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL needAnimation;
@property (nonatomic, assign) BOOL needInteraction;
@property (nonatomic, assign) YYTransitionType transitionType;

+ (instancetype)delegateWithController:(UIViewController *)vc;

@end
