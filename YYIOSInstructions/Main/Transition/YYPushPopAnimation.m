//
//  YYPushPopAnimation.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYPushPopAnimation.h"

static YYPushPopAnimation *shareInstance = nil;

@implementation YYPushPopAnimation

+ (instancetype)shareAnimation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [YYPushPopAnimation new];
    });
    return shareInstance;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    // It may return nil whenever the animator should not touch the view
    // (based on the presentation style of the incoming view controller).
    // It may also return a different view for the animator to animate.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromVC.view;
        toView = toVC.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    
    
    // If a push is being animated, the incoming view controller will have a
    // higher index on the navigation stack than the current top view
    // controller.
    BOOL isPush = ([toVC.navigationController.viewControllers indexOfObject:toVC] > [fromVC.navigationController.viewControllers indexOfObject:fromVC]);
    
    if (isPush) {
        toView.transform = CGAffineTransformMakeTranslation(toView.frame.size.width, 0);
    } else {
        toView.transform = CGAffineTransformMakeTranslation(-fromView.frame.size.width, 0);
    }
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation/dismissal.
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        toView.transform = CGAffineTransformIdentity;
        
        if (isPush) {
            fromView.transform = CGAffineTransformMakeTranslation(-fromView.frame.size.width*0.3, 0);
        } else {
            fromView.transform = CGAffineTransformMakeTranslation(toView.frame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        
        fromView.transform = CGAffineTransformIdentity;
        
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition finished or not.
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}
@end
