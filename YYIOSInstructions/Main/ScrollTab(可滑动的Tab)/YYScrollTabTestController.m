//
//  YYScrollTabTestController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/18.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYScrollTabTestController.h"
#import "YYScrollTabView.h"

@interface YYScrollTabTestController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YYScrollTabTestController

- (void)setupSubviews{
    [super setupSubviews];
    
    self.navigationItem.title = @"Scrollable tab test";
    
    YYScrollTabView *stv = [[YYScrollTabView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    stv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stv];
    
    [stv addItemWithTitle:@"tab1" tableviewDelegate:self];
    [stv addItemWithTitle:@"tab2" tableviewDelegate:self];
    [stv addItemWithTitle:@"tab3" tableviewDelegate:self];
}

#pragma mark - tableview delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
