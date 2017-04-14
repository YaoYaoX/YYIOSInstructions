//
//  YYActionSheetTestController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYActionSheetTestController.h"
#import "YYActionSheetView.h"

@implementation YYActionSheetTestController

- (void)setupSubviews{
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [showBtn setTitle:@"show action sheet" forState:UIControlStateNormal];
    [showBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
}

- (void)show{
    YYActionSheetView *asv = [[YYActionSheetView alloc] init];
    // 点击空白处弹出框是否消失
    asv.dismissWhenTap = NO;
    asv.title = @"请选择你的操作";
    
    // 创建item
    YYActionItem *cancle = [[YYActionItem alloc] initWithTitle:@"取消" type:YYActionItemTypeCancle action:nil];
    YYActionItem *delete= [[YYActionItem alloc] initWithTitle:@"删除" type:YYActionItemTypeDestructive action:^{
        // item被选择后
        // 会自动加上消失的方法
        NSLog(@"删除");
    }];
    YYActionItem *share = [[YYActionItem alloc] initWithTitle:@"分享" type:YYActionItemTypeNormal action:^{
        NSLog(@"分享");
        // 分享时弹出新框
        YYActionSheetView *shareASV = [[YYActionSheetView alloc] init];
        shareASV.dismissWhenTap = YES;
        shareASV.title = @"分享到";
        
        YYActionItem *weibo = [[YYActionItem alloc] initWithTitle:@"微博" type:YYActionItemTypeNormal action:^{ NSLog(@"分享到微博"); }];
        YYActionItem *wechat = [[YYActionItem alloc] initWithTitle:@"微信" type:YYActionItemTypeNormal action:^{ NSLog(@"分享到微信"); }];
        YYActionItem *qq = [[YYActionItem alloc] initWithTitle:@"QQ" type:YYActionItemTypeNormal action:^{ NSLog(@"分享到QQ"); }];
        
        [shareASV addAction:weibo];
        [shareASV addAction:wechat];
        [shareASV addAction:qq];
        [shareASV show];
    }];
    
    // 添加items
    [asv addAction:cancle];
    [asv addAction:delete];
    [asv addAction:share];
    
    // 展示
    [asv show];
}
@end
