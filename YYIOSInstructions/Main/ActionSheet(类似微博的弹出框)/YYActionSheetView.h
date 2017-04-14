//
//  YYActionSheetView.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//  ActionSheet的内容区

#import "YYCoverView.h"
#import "YYActionItem.h"

@interface YYActionSheetView : YYCoverView

@property (nonatomic, copy) NSString *title;

- (void)addAction:(YYActionItem *)item;
- (void)removeAction:(YYActionItem *)item;

@end
