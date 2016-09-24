//
//  YYDeomController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYDeomController.h"
#import "YYTransitionMainNavController.h"
#import "YYTransitionTestViewController.h"

static NSString *ID = @"reuseIdentifier";

@interface YYDeomController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation YYDeomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = @[@{@"title":@"自定义转场动画"}];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = (id<UITableViewDataSource>)self;
    tableView.delegate = (id<UITableViewDelegate>)self;
    tableView.rowHeight = 60;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {

        YYTransitionMainNavController *nav = [YYTransitionMainNavController controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
