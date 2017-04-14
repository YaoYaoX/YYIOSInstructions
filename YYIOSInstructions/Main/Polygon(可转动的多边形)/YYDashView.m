//
//  YYDashView.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/14.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYDashView.h"

@interface YYDashView ()

@property (nonatomic, weak) CAShapeLayer *borderLayer;

@end

@implementation YYDashView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addBorderLayer];
    }
    return self;
}

- (void)addBorderLayer{
    
    CGSize size = self.frame.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height-20)];
    [path addLineToPoint:CGPointMake(size.width-20, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(0, 20)];
    [path addLineToPoint:CGPointMake(20, 0)];
    [path closePath];
    [path stroke];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = path.CGPath;
    borderLayer.lineDashPattern = @[@20,@20];
    borderLayer.lineCap = kCALineCapButt;
    borderLayer.lineDashPhase = 40;
    [borderLayer setStrokeColor:kMainColor.CGColor];
    [borderLayer setFillColor:[UIColor clearColor].CGColor];
    self.borderLayer = borderLayer;
    
    [self.layer addSublayer:borderLayer];
}

- (void)doAnimation{
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(ani) userInfo:nil repeats:YES];
}

- (void)ani{
    self.borderLayer.lineDashPhase -= 2;
}


@end
