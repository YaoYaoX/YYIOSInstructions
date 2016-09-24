//
//  YYSwipInteractiveTransition.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/9/24.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYSwipInteractiveTransition.h"

#define kBaseHeight 400
#define kBaseWidth 200

@interface YYSwipInteractiveTransition ()

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIPanGestureRecognizer *gesture;

@end

@implementation YYSwipInteractiveTransition

#pragma mark - init

- (instancetype)initWithController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.transitionType = YYTransitionTypePush;
        self.viewController = viewController;
    }
    return self;
}

- (void)dealloc{
    [self removeGesture];
}

#pragma mark - add gesture

/// 1.添加手势
- (void)setViewController:(UIViewController *)viewController{
    _viewController = viewController;
    [self removeGesture];
    [self addGestureToView:viewController.view];
}

- (void)removeGesture{
    
    [self.viewController.view removeGestureRecognizer:self.gesture];
    [self.gesture removeTarget:self action:@selector(handleGesture:)];
    self.gesture = nil;
}

- (void)addGestureToView:(UIView *)view{
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gesture = gesture;
    [view addGestureRecognizer:gesture];
}

#pragma mark - handle gesture

/// 2.处理手势
- (void)handleGesture:(UIPanGestureRecognizer *)panGes{
    
    CGPoint translation = [panGes translationInView:panGes.view.superview];
    
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:{
            // 2.1手势开始，返回
            self->_interacting = YES;
            self.shouldComplete = NO;
            
            if (self.transitionType == YYTransitionTypePush) {
                [self.viewController.navigationController popViewControllerAnimated:YES];
            } else {
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
            // 2.2手势过程中，修改转场百分比
            CGFloat percent = 0;
            if (self.transitionType == YYTransitionTypePush) {
                percent = translation.x/self.viewController.view.frame.size.width;
            } else {
                percent = translation.y/self.viewController.view.frame.size.height;
            }
            percent = fminf(fmaxf(percent, 0.0), 1.0);
            self.shouldComplete = percent>0.3;
            NSLog(@"%@",@(percent));
            [self updateInteractiveTransition:percent];
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:{
            // 2.3手势结束，处理转场状态
            self->_interacting = NO;
            if (!self.shouldComplete || panGes.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
            
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

@end
