//
//  YYScrollTabBar.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYScrollTabBar.h"
#import "UIColor+Additions.h"

@interface YYScrollTabBar ()

@property (nonatomic, weak) UIButton *selectedItemBtn;
@property (nonatomic, weak) UIView *indicatorV;
@property (nonatomic, strong) NSMutableArray<UIButton *> *tabBarItems;

@end

@implementation YYScrollTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor grayColorWithValue:200].CGColor;
        self.layer.shadowRadius = 2;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.5;

        UIView *indicatorV = [[UIView alloc]init];
        indicatorV.backgroundColor = kMainColor;
        [self addSubview:indicatorV];
        self.indicatorV = indicatorV;
        
        self.selectedIndex = 0;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // item布局
    CGSize size = self.frame.size;
    CGFloat width = size.width/self.tabBarItems.count;
    NSInteger index = 0;
    for (UIButton *item in self.tabBarItems) {
        item.frame = CGRectMake(index*width, 0, width, size.height);
        index++;
    }
    
    // 指示线
    self.indicatorV.frame = CGRectMake(self.selectedIndex * width, size.height-3, width, 3);
}

-(void)addItemsWithTitleArray:(NSArray *)titles{
    
    for (NSString *title in titles) {
        [self addSubItemWithTitle:title];
    }
    
    [self setNeedsLayout];
}

-(void)addItemWithTitle:(NSString *)title{
    
    [self addSubItemWithTitle:title];
    [self setNeedsLayout];
}

-(void)addSubItemWithTitle:(NSString *)title{
    
    UIButton *itemBtn = [[UIButton alloc]init];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [itemBtn setTitleColor:kGrayColor_150 forState:UIControlStateNormal];
    [itemBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    [itemBtn addTarget:self action:@selector(tabBarItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:itemBtn];
    [self.tabBarItems addObject:itemBtn];
}

-(void)tabBarItemDidClicked:(UIButton *)btn{
    
    NSInteger index = [self.tabBarItems indexOfObject:btn];
    NSInteger lastIndex = self.selectedIndex;
    if (index != lastIndex) {
        self.selectedIndex = index;
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollTabBar:didSelectedItemAtIndex:lastIndex:)]) {
        [self.delegate scrollTabBar:self didSelectedItemAtIndex:self.selectedIndex lastIndex:lastIndex];
    }
}

#pragma mark - setter & getter

/** 设置指示线所处位置的百分比 */
-(void)setIndicatorXPercent:(CGFloat)indicatorPercent{
    if (self.tabBarItems.count<1) {
        return;
    }
    
    if (indicatorPercent<0) {
        indicatorPercent = 0;
    }
    
    if (indicatorPercent>1) {
        indicatorPercent = 1;
    }
    
    //每个item的width
    CGFloat width = self.frame.size.width / self.tabBarItems.count;
    //指示线x的真实能移动的范围
    CGFloat realMovableWidth = (self.tabBarItems.count-1)* width;
    CGFloat newX = indicatorPercent*realMovableWidth;
    CGRect frame = self.indicatorV.frame;
    frame.origin.x = newX;
    self.indicatorV.frame = frame;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    
    if(self.tabBarItems.count==0){
        _selectedIndex = 0;
        return;
    }
    
    if (selectedIndex<0) {
        selectedIndex = 0;
    }
    
    if (selectedIndex>self.tabBarItems.count-1) {
        selectedIndex = self.tabBarItems.count-1;
    }
    
    //按钮选择与否
    self.selectedItemBtn.selected = NO;
    
    _selectedIndex = selectedIndex;
    
    UIButton *currentBtn = self.tabBarItems[_selectedIndex];
    currentBtn.selected = YES;
    self.selectedItemBtn = currentBtn;
    
    
    //指示线位置
    __weak typeof (self) weakSelf = self;
    CGRect indicatorFrame = self.indicatorV.frame;
    
    //确定滑动时长
    CGFloat diff = indicatorFrame.origin.x - currentBtn.frame.origin.x;
    CGFloat all = self.frame.size.width - indicatorFrame.size.width;
    CGFloat scale = fabs(diff)/ fabs(all);
    if (scale>1) {
        scale = 1;
    }
    CGFloat duration = 0.25 * scale;
    
    indicatorFrame.origin.x = currentBtn.frame.origin.x;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.indicatorV.frame = indicatorFrame;
    }];
}

-(NSMutableArray<UIButton *> *)tabBarItems{
    if (!_tabBarItems) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}
@end
