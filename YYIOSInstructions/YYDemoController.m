//
//  YYDemoController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/25.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "YYDemoController.h"
#import "YYTransitionMainNavController.h"
#import "YYTransitionTestViewController.h"

static NSString *ID = @"reuseIdentifier";

@interface YYDemoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation YYDemoController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = @[//@{@"title":@"转场动画"},
                  @{@"title":@"ActionSheet", @"class":@"YYActionSheetTestController"},
                  @{@"title":@"多边形", @"class":@"YYPolygonViewController"},
                  @{@"title":@"自定义View", @"class":@"YYCustomViewController"}];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
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
    if ([self.data[indexPath.row][@"title"] isEqualToString:@"转场动画"]) {
        YYTransitionMainNavController *nav = [YYTransitionMainNavController controller];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSString *classStr = self.data[indexPath.row][@"class"];
    if (classStr) {
        id contrller = [[NSClassFromString(classStr) alloc] init];
        if([contrller isKindOfClass:[UIViewController class]]){
            [self.navigationController pushViewController:contrller animated:YES];
        }
    }

}

@end
