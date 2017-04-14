//
//  YYActionSheetView.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYActionSheetView.h"
#import "YYActionItem.h"
#import "Masonry.h"

#define KITEMHEIGHT 60

@interface YYActionSheetView ()

@property (nonatomic, strong) NSMutableArray *cancleItems;
@property (nonatomic, strong) NSMutableArray *normalItems;
@property (nonatomic, weak) YYActionItem *titleItem;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation YYActionSheetView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        YYActionItem *titleItem = [[YYActionItem alloc] initWithTitle:nil type:YYActionItemTypeTitle action:nil];
        [self addAction:titleItem];
    }
    return self;
}

- (NSMutableArray *)cancleItems {
    if (!_cancleItems) {
        _cancleItems = [NSMutableArray array];
    }
    return _cancleItems;
}

- (NSMutableArray *)normalItems {
    if (!_normalItems) {
        _normalItems = [NSMutableArray array];
    }
    return _normalItems;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetSubviews];
}

- (void)resetSubviews {
    
    BOOL needTitle = self.title.length > 0;
    CGFloat height = 0;
    
    // 取消
    for (int i = 0; i < self.cancleItems.count; i++) {
        YYActionItem *item = self.cancleItems[i];
        item.hideLine = i < 1;
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(KITEMHEIGHT);
            make.bottom.mas_equalTo(-height);
        }];
        height += KITEMHEIGHT;
    }
    
    // 间隔
    if (self.normalItems.count > 0 || needTitle) {
        height += 5;
    }
    
    // 按钮
    for (int i = 0; i < self.normalItems.count; i++) {
        YYActionItem *item = self.normalItems[i];
        item.hideLine = i < 1;
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(KITEMHEIGHT);
            make.bottom.mas_equalTo(-height);
        }];
        height += KITEMHEIGHT;
    }
    
    // 标题
    self.titleItem.hideLine =  self.normalItems.count < 1;
    [self.titleItem mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(needTitle ? KITEMHEIGHT : 0);
        make.bottom.mas_equalTo(-height);
    }];
    if (needTitle) {
        height += KITEMHEIGHT;
    }
    
    // 内容区调整
    self.contentHeight = height;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    
}

- (void)addAction:(YYActionItem *)item {
    if (item.type == YYActionItemTypeCancle) {
        [self.cancleItems addObject:item];
    } else if (item.type == YYActionItemTypeTitle) {
        self.titleItem = item;
    } else {
        [self.normalItems addObject:item];
    }
    
    if (item.type != YYActionItemTypeTitle) {
        __weak typeof (self) weakSelf = self;
        YYItemAction action = [item.actionBlock copy];
        if (!action) {
            action = ^(){ [weakSelf dismiss]; };
        } else {
            action = ^(){
                action();
                [weakSelf dismiss];
            };
        }
        item.actionBlock = action;        
    }
    
    [self.contentView addSubview:item];
    [self setNeedsLayout];
}

- (void)removeAction:(YYActionItem *)item{
    if (item.type == YYActionItemTypeCancle) {
        [self.cancleItems removeObject:item];
    } else {
        [self.normalItems removeObject:item];
    }
    [item removeFromSuperview];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleItem.title = title;
}

- (void)show {
    [super show];
    
    __weak typeof (self) weakSelf = self;
    [self resetSubviews];
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentHeight);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentHeight);

    }];
    [super dismiss];
}

@end
