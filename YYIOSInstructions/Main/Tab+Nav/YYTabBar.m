//
//  YYTabBar.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/5.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYTabBar.h"

@interface YYTabBar ()

@property (nonatomic, weak) UIButton *middleBtn;

@end

@implementation YYTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 类似新浪微博：中间添加一个自定义按钮
        // 由于与tabBar的样式有差别，需要重新调整item的位置，调整请看layoutSubviews
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.middleBtn = button;
        
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.tag = 1000;
        imgv.image = [UIImage imageNamed:@"yy_tab_middle"];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imgv];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //    // 1. 直接重新调整item的位置
    //    [self resetSubItemFrame1];
    
    // 2.更简便调整item的方法：在UITabbarController中多添加加一个控制器，再调整中间的button位置就行
    [self resetSubItemFrame2];
    
    
    // 调整图片位置
    for (UITabBarItem *item in self.items) {
        item.imageInsets = UIEdgeInsetsMake(-7, 0, 7, 0);
    }
}

/** 调整Item方式1 */
- (void)resetSubItemFrame1{
    
    CGSize size = self.frame.size;
    CGFloat directW = 60;
    CGFloat directH = 60;
    self.middleBtn.frame = CGRectMake((size.width-directW)*0.5, size.height-directH-15, directW, directH);
    UIView *imgV = [self.middleBtn viewWithTag:1000];
    imgV.frame = CGRectMake(0, directH-80, directW, 70);
    
    //排序(可能是由于selectedIndex的原因，子tab的顺序不定，只好根据x值给tab排序下先)
    NSMutableArray *tabBarItems = [NSMutableArray array];
    for (UIView *item in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([item isKindOfClass:class]) {
            //根据x给子tab排序
            NSInteger index = 0;
            CGFloat itemX = item.frame.origin.x;
            for (UIView *existItem in tabBarItems) {
                CGFloat existX = existItem.frame.origin.x;
                if (itemX < existX) {
                    break;
                }
                index++;
            }
            
            [tabBarItems insertObject:item atIndex:index];
        }
    }
    
    
    // 设置其他tabbarButton的frame
    NSInteger  count = self.items.count;
    CGFloat    itemWidth = (size.width-directW) / count;
    CGFloat    lastItemX = 0;
    NSInteger  itemIndex = 0;
    for (UIView *child in tabBarItems) {
        
        // 调整tabbarButton的位置及尺寸
        CGRect frame = child.frame;
        frame.origin.x = lastItemX;
        frame.size.width = itemWidth;
        child.frame = frame;
        
        // 确定下个item位置
        itemIndex++;
        if(itemIndex == count/2){
            lastItemX = CGRectGetMaxX(self.middleBtn.frame);
        } else {
            lastItemX = CGRectGetMaxX(frame);
        }
    }
}

/** 调整Item方式2: 在UITabbarController中多添加加一个控制器 */
- (void)resetSubItemFrame2{

    // 获取item的尺寸
    CGSize size = self.frame.size;
    CGSize itemSize = size;
    for (UIView *item in self.subviews) {
        if ([item isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            itemSize = item.frame.size;
            break;
        }
    }
    
    // 调整中间按钮以便完整覆盖占位item
    self.middleBtn.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    self.middleBtn.center = CGPointMake(size.width*0.5, size.height-itemSize.height*0.5);
    [self.middleBtn.superview bringSubviewToFront:self.middleBtn];
    UIView *imgV = [self.middleBtn viewWithTag:1000];
    imgV.frame = CGRectMake(0, itemSize.height-80, itemSize.width, 70);
}

- (void)buttonDidClicked:(id )btn{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:btn];
    }
}
@end
