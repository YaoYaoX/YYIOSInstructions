//
//  YYCoverView.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYCoverView.h"

@interface YYCoverView ()

@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;

@end

@implementation YYCoverView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColorWithValue:150 alpha:0.5];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
        self.tapGesture = tapGesture;
        self.dismissWhenTap = YES;
        
        UIView *contentV = [[UIView alloc] init];
        contentV.backgroundColor = [UIColor grayColorWithValue:255 alpha:0.6];
        [self addSubview:contentV];
        _contentView = contentV;
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tapGes{
    
    if (!self.dismissWhenTap) {
        return;
    }
    
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

- (void)show{
    
    __weak typeof (self) weakSelf = self;
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    self.frame = window.bounds;
    [window addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (void)dismiss{
    
    __weak typeof (self) weakSelf = self;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)setDismissWhenTap:(BOOL)dismissWhenTap {
    _dismissWhenTap = dismissWhenTap;
    self.tapGesture.enabled = dismissWhenTap;
}

@end
