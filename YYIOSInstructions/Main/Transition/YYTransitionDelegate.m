//
//  YYTransitionDelegate.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//  统一代理

#import "YYTransitionDelegate.h"
#import "YYPresentAnimation.h"
#import "YYPushPopAnimation.h"
#import "YYSwipInteractiveTransition.h"

@interface YYTransitionDelegate ()

@property (nonatomic, strong) YYPresentAnimation            *presentDismissAnimation;
@property (nonatomic, strong) YYPushPopAnimation            *pushPopAnimation;
@property (nonatomic, strong) YYSwipInteractiveTransition   *swipInteractive;

@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation YYTransitionDelegate

+ (instancetype)delegateWithController:(UIViewController *)vc{
    YYTransitionDelegate *delegate = [[self alloc] init];
    delegate.viewController = vc;
    return delegate;
}

- (YYPresentAnimation *)presentDismissAnimation{
    if (!_presentDismissAnimation) {
        _presentDismissAnimation = [YYPresentAnimation shareAnimation];
    }
    return _presentDismissAnimation;
}

- (YYPushPopAnimation *)pushPopAnimation{
    if (!_pushPopAnimation) {
        _pushPopAnimation = [YYPushPopAnimation shareAnimation];
    }
    return _pushPopAnimation;
}

- (YYSwipInteractiveTransition *)swipInteractive{
    
    if(!self.needInteraction)
        return nil;
    
    if (!_swipInteractive) {
        _swipInteractive = [[YYSwipInteractiveTransition alloc] init];
    }

    if (_swipInteractive.viewController != self.viewController) {
        _swipInteractive.viewController = self.viewController;
    }
    
    return _swipInteractive;
}

- (void)setTransitionType:(YYTransitionType)transitionType{
    _transitionType = transitionType;
    self.swipInteractive.transitionType = transitionType;
}

- (void)setNeedInteraction:(BOOL)needInteraction{
    _needInteraction = needInteraction;
    if (!needInteraction) {
        self.swipInteractive = nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

// 1.modal方式：指定自定义的动画代理
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    // present的时候的动画,nil代表使用默认过渡效果
    return self.needAnimation? self.presentDismissAnimation : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    // dismiss的时候的动画,nil代表使用默认过渡效果
    return self.needAnimation? self.presentDismissAnimation : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.needInteraction? self.swipInteractive : nil;
}

#pragma mark - UINavigationControllerDelegate

// 1.push/pop方式：指定自定义的动画代理
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    return self.needAnimation? self.pushPopAnimation : nil;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{

    BOOL isPop = navigationController.viewControllers.lastObject != self.viewController;
    if (self.needInteraction && isPop) {
        return self.swipInteractive;
    } else {
        return nil;
    }
}

@end
