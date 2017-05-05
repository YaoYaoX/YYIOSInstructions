//
//  YYPolygon.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/14.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYPolygon.h"
#import "Masonry.h"

#define KDuration 0.25

@interface YYPolygon ()

@property (nonatomic, weak)     UIView                  *polygonView;
@property (nonatomic, weak)     CAShapeLayer            *polygonLayer;
@property (nonatomic, weak)     UIPanGestureRecognizer  *panGesture;
@property (nonatomic, assign)   CGAffineTransform       lastTransform;
/// 每个角的度数
@property (nonatomic, readonly) CGFloat                 angleBase;
/// 每次转动的度数
@property (nonatomic, readonly) CGFloat                 rotateAnagle;

@end

@implementation YYPolygon

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    self.numberOfSide = 6;
    self.rotateNum = 1;
    
    // 多边形
    UIView *polygonView =[ [UIView alloc] init];
    polygonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:polygonView];
    self.polygonView = polygonView;
    
    // mask
    CAShapeLayer *polygonLayer = [[CAShapeLayer alloc] init];
    polygonView.layer.mask = polygonLayer;
    self.polygonLayer = polygonLayer;
    
    // arrow
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"arrow"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    arrow.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.polygonView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    // 手势
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGes];
    self.panGesture = panGes;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubviews];
}

- (void)resetSubviews{
    
    // 多边形
    CGSize size = self.frame.size;
    CGFloat wh = MIN(size.width, size.height);
    [self.polygonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        // 居中摆放
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(wh,wh));
    }];
    
    // 多边形mask
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radius = wh * 0.5;
    CGFloat arcAngle = 4 * (M_PI / 180); // 4为圆角的弧度
    CGFloat tempX = radius / (1 / tan(arcAngle) +  1 / tan((M_PI - self.angleBase) * 0.5));
    CGFloat anotherRadius = tempX /sin(arcAngle);
    
    // 根据角度、半径计算点的位置
    CGPoint(^getPoint)(CGFloat, CGFloat) = ^(CGFloat angle, CGFloat radius){
        // 为计算方便，将坐标移到了view的中心，计算完后在加上x、y轴的偏移量，即wh*0.5
        CGFloat x = wh * 0.5 + radius * cos(angle);
        CGFloat y = wh * 0.5 + radius * sin(angle);
        return CGPointMake(x, y);
    };
    
    // 带圆弧的多边形
    for (int i=0; i<=self.numberOfSide-1; i++) {
        
        CGFloat angle = self.angleBase * i - M_PI_2;
        
        // 多边形的边
        CGPoint point1 = getPoint(angle-arcAngle, anotherRadius);
        if (i == 0) {
            [path moveToPoint:point1];
        } else {
            [path addLineToPoint:point1];
        }
        
        // 多边形的角改成弧
        CGPoint point = getPoint(angle,radius);
        CGPoint point2 = getPoint(angle+arcAngle,anotherRadius);
        [path addQuadCurveToPoint:point2 controlPoint:point];
        
    }
    [path stroke];
    self.polygonLayer.path = path.CGPath;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGes{
    
    CGPoint translate = [panGes translationInView:self];
    CGFloat width = self.frame.size.width;
    CGFloat rotateScale = translate.x / width * self.rotateNum;  // 转动比例，“self.rotateNum”用于调整滑动的敏感度
    
    // 1.记录开始时的transform
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.lastTransform = self.polygonView.transform;
    }
    
    // 2.转盘转动
    // 每次都相对于上次停止的位置更改transform
    self.polygonView.transform = CGAffineTransformRotate(self.lastTransform, self.rotateAnagle * rotateScale);
    
    // 3.确定转盘最终位置
    if(panGes.state == UIGestureRecognizerStateEnded) {
        CGFloat minRotateAngle = self.rotateAnagle;
        CGFloat currentAngle = [self angle_360WithTransform:self.polygonView.transform];
        CGFloat scale = currentAngle / minRotateAngle;
        // 切换临界点：可调整
        CGFloat line = 0.3;
        if ((scale - (NSInteger)scale) != 0) {
            CGFloat minAngle = (NSInteger)scale * minRotateAngle;
            CGFloat maxAngle = ((NSInteger)scale + 1) * minRotateAngle;
            CGFloat diff = scale-(NSInteger)scale;
            
            CGFloat finalAngle = 0;
            if (translate.x>0) {
                // 顺时针
                finalAngle = diff > 1 - line ? maxAngle : minAngle;
            } else {
                // 逆时针
                finalAngle = diff > line ? maxAngle : minAngle;
            }
            
            __weak typeof (self) weakSelf = self;
            CGFloat duration = ABS(finalAngle-currentAngle) / (minRotateAngle*0.5) * KDuration;
            [UIView animateWithDuration:duration animations:^{
                weakSelf.polygonView.transform = CGAffineTransformMakeRotation(-finalAngle);
            } completion:nil];
        }
    }
}

// 获取360角度
- (CGFloat)angle_360WithTransform:(CGAffineTransform)transform{
    
    // 只能获取到0～180的角度
    CGFloat angle = acosf(transform.a);
    
    // b为负数的时候，角度调整下就能获取到0～360的角度
    if (transform.b < 0) {
        angle = M_PI*2 -angle;
    }
    
    // 为了适应转盘转动方向，换成逆时针
    angle = M_PI*2 - angle;
    return angle;
}

- (void)setNumberOfSide:(NSUInteger)numberOfSide{
    if (numberOfSide < 3) {
        numberOfSide = 3;
    }
    _numberOfSide = numberOfSide;
    _angleBase = M_PI*2/self.numberOfSide;
    _rotateAnagle = _rotateNum*_angleBase;
    [self setNeedsLayout];
}

- (void)setRotateNum:(NSUInteger)rotateNum{
    if (rotateNum < 1) {
        rotateNum = 1;
    }
    _rotateNum = rotateNum;
    _rotateAnagle = rotateNum*self.angleBase;
}

- (void)rotateToIndex:(NSUInteger)index {
    CGFloat angle = (index * self.rotateAnagle);
    angle = angle - (NSUInteger)(angle/(2*M_PI)) * (2*M_PI);
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:2 animations:^{
        weakSelf.polygonView.transform = CGAffineTransformMakeRotation(-angle);
    } completion:nil];

}

@end
