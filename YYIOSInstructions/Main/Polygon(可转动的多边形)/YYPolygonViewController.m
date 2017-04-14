//
//  YYPolygonViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/14.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYPolygonViewController.h"
#import "YYPolygon.h"
#import "YYDashView.h"

@implementation YYPolygonViewController

- (void)setupSubviews{
    
    CGFloat margin = 10;
    CGFloat top = 100;
    CGFloat wh = (self.view.frame.size.width - 3*margin)/2;
    
    YYPolygon *hexagon = [[YYPolygon alloc] initWithFrame:CGRectMake(margin, top+margin, wh, wh)];
    hexagon.backgroundColor = [UIColor grayColorWithValue:200];
    [self.view addSubview:hexagon];
    
    
    YYPolygon *heptagon = [[YYPolygon alloc] initWithFrame:CGRectMake(wh+2*margin, top+margin, wh, wh)];
    heptagon.numberOfSide = 7;
    heptagon.backgroundColor = [UIColor grayColorWithValue:200];
    [self.view addSubview:heptagon];
    
    
    YYPolygon *octagon = [[YYPolygon alloc] initWithFrame:CGRectMake(margin, top+wh+2*margin, wh, wh)];
    octagon.numberOfSide = 8;
    octagon.rotateNum = 2;
    octagon.backgroundColor = [UIColor grayColorWithValue:200];
    [self.view addSubview:octagon];
    
    
    YYPolygon *another = [[YYPolygon alloc] initWithFrame:CGRectMake(wh+2*margin, top+wh+2*margin, wh, wh)];
    another.numberOfSide = 15;
    another.rotateNum = 3;
    another.backgroundColor = [UIColor grayColorWithValue:200];
    [self.view addSubview:another];
    
    YYDashView *dashview = [[YYDashView alloc] initWithFrame:CGRectMake(margin, top+wh*2+3*margin, 200, 40)];
    [self.view addSubview:dashview];
    [dashview doAnimation];
}

@end
