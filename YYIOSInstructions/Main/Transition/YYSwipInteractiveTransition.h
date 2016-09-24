//
//  YYSwipInteractiveTransition.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/9/24.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTransitonDefine.h"

@interface YYSwipInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign, readonly) BOOL interacting;
@property (nonatomic, assign) YYTransitionType transitionType;
@property (nonatomic, weak) UIViewController *viewController;

- (instancetype)initWithController:(UIViewController *)viewController;

@end
