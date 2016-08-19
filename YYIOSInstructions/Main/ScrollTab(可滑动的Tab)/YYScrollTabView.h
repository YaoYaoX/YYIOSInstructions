//
//  YYScrollTabView.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/8/12.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYScrollTabView;

@protocol YYScrollTabViewDelegate <NSObject>

@optional
- (void)tabTableView:(YYScrollTabView *)tabTableV didSelectedIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex;

@end



@interface YYScrollTabView : UIView

@property (nonatomic, weak) id<YYScrollTabViewDelegate> delegate;

/** 添加子tab */
-(UITableView *)addItemWithTitle:(NSString *)title tableviewDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate;

@end