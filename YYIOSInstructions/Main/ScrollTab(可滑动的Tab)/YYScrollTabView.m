//
//  YYScrollTabView.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYScrollTabView.h"
#import "YYScrollTabBar.h"

// 每个subTabView之间的间距
// |-margin-subTabView-margin-...margin-subTabView-margin-|
#define margin 10

@interface YYScrollTabView ()<YYScrollTabBarDelegate,UIScrollViewDelegate>

@property (nonatomic, assign)   CGFloat             contentWidth;
@property (nonatomic, weak)     YYScrollTabBar      *topTabbar;
@property (nonatomic, weak)     UIScrollView        *contentScrollV;
@property (nonatomic, strong)   NSMutableArray      *subTabviews;
@property (nonatomic, assign)   BOOL                drag;

@end

@implementation YYScrollTabView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.drag = NO;
        
        //topTab
        YYScrollTabBar *tabBar = [[YYScrollTabBar alloc]init];
        tabBar.delegate = self;
        self.topTabbar = tabBar;
        [self addSubview:tabBar];
        
        //content
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeZero;
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        self.contentScrollV = scrollView;
    }
    return self;
}

-(void)layoutSubviews{
    
    CGRect frame = self.frame;
    CGSize size = frame.size;
    self.contentWidth = size.width;
    
    // 顶部tab
    self.topTabbar.frame = CGRectMake(0, 0, size.width, 45);
    
    // 可滑动的内容区
    CGFloat svY = CGRectGetMaxY(self.topTabbar.frame);
    self.contentScrollV.frame = CGRectMake(-margin*0.5, svY, size.width+margin, size.height-svY);
    
    // 子tab的内容区
    CGSize contentSize = CGSizeZero;
    CGFloat subFrameWidth = size.width;
    CGFloat subFrameHeight = size.height;
    CGFloat subFrameX = margin*0.5;
    UIView *lastSubTabV = nil;
    for (UIView *subTabV in self.subTabviews) {
        if (lastSubTabV) {
            subFrameX = CGRectGetMaxX(lastSubTabV.frame)+margin;
        }
        contentSize.width += (subFrameWidth+margin);
        lastSubTabV = subTabV;
        CGRect subFrame = CGRectMake(subFrameX, 0, subFrameWidth, subFrameHeight);
        subTabV.frame = subFrame;
    }
    
    //设置contentSize
    self.contentScrollV.contentSize = contentSize;
}

/** 添加一个tab，并添加子view，这里添加tableview，有其他需求的可自行定义*/
-(UITableView *)addItemWithTitle:(NSString *)title tableviewDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate{
    
    //添加tab标题
    [self.topTabbar addItemWithTitle:title];
    
    //添加tableview（自定义的view）
    UITableView *tableview = [[UITableView alloc]init];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = delegate;
    tableview.dataSource = delegate;
    tableview.backgroundColor = [UIColor clearColor];
    [self.contentScrollV addSubview:tableview];
    
    //*test
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHex:0x222222];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [tableview addSubview:label];
    tableview.backgroundColor = [UIColor colorWithRed:0.8+arc4random_uniform(100)/1000.0 green:0.8+arc4random_uniform(100)/1000.0 blue:0.8+arc4random_uniform(100)/1000.0 alpha:1];
     //*/
    
    //后续
    [self.subTabviews addObject:tableview];
    [self setNeedsLayout];
    
    return tableview;
}

#pragma mark - 顶部tab点击，改变家tab

-(void)scrollTabBar:(YYScrollTabBar *)tabBar didSelectedItemAtIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex{
    
    if (index != lastIndex) {
        //修改内容区的位置
        CGPoint contentOffset = self.contentScrollV.contentOffset;
        contentOffset.x = index*(self.contentWidth+margin);
        [self.contentScrollV setContentOffset:contentOffset];
    }
    
    if ([self.delegate respondsToSelector:@selector(tabTableView:didSelectedIndex:lastIndex:)]) {
        [self.delegate tabTableView:self didSelectedIndex:index lastIndex:lastIndex];
    }
}

#pragma mark - 内容区滑动，改变tab

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.drag = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //只有手势滑动的时候才处理
    if (self.drag) {
        //真实该移动的范围：第一页内容区左边 ～ 最后一页内容区的左边
        CGFloat width = scrollView.contentSize.width-self.contentWidth-margin;
        CGFloat offsetX = scrollView.contentOffset.x-margin*0.5;
        CGFloat scale = offsetX/width;
        //修改top的指示线的位置
        [self.topTabbar setIndicatorXPercent:scale];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //确定最终选定的tab
    self.drag = NO;
    NSInteger lastIndex = self.topTabbar.selectedIndex;
    NSInteger currentIndex = (NSInteger)((*targetContentOffset).x/(self.contentWidth+margin));
    self.topTabbar.selectedIndex = currentIndex;
    
    if (lastIndex!=currentIndex) {
        if ([self.delegate respondsToSelector:@selector(tabTableView:didSelectedIndex:lastIndex:)]) {
            [self.delegate tabTableView:self didSelectedIndex:currentIndex lastIndex:lastIndex];
        }
    }
}

#pragma mark - getter

- (NSMutableArray *)subTabviews{
    if (!_subTabviews) {
        _subTabviews = [NSMutableArray array];
    }
    return _subTabviews;
}

#pragma mark - public

- (UITableView *)selectedTableView{
    
    NSInteger selectedIndex = self.topTabbar.selectedIndex;
    if (self.subTabviews.count>0 && selectedIndex>=0 && selectedIndex<self.subTabviews.count) {
        
        return self.subTabviews[selectedIndex];
    }
    
    return nil;
}

@end
