//
//  YYActionItem.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//  ActionSheet上的item

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYActionItemType) {
    YYActionItemTypeNormal,
    YYActionItemTypeCancle,
    YYActionItemTypeDestructive,
    YYActionItemTypeTitle
};

typedef void(^YYItemAction)();

@interface YYActionItem : UIView

@property (nonatomic, copy) YYItemAction actionBlock;
@property (nonatomic, readonly) YYActionItemType type;
@property (nonatomic, assign) BOOL hideLine;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title type:(YYActionItemType)type action:(YYItemAction)action;

@end
