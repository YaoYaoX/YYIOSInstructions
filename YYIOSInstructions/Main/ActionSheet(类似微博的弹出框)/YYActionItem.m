//
//  YYActionItem.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/4/13.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYActionItem.h"
#import "Masonry.h"

@interface YYActionItem ()

@property (nonatomic, assign) YYActionItemType  innerType;
@property (nonatomic, weak)   UIView            *lineView;
@property (nonatomic, weak)   UIButton          *button;

@end

@implementation YYActionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
        [self addSubview:lineView];
        self.lineView = lineView;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        self.innerType = YYActionItemTypeNormal;
        self.hideLine = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title type:(YYActionItemType)type action:(YYItemAction)action{
    self = [self init];
    self.title = title;
    self.innerType = type;
    self.actionBlock = action;
    return self;
}

- (void)itemDidClicked:(UIButton *)btn{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)setInnerType:(YYActionItemType)innerType{
    _innerType = innerType;
    
    UIColor *color = nil;
    CGFloat fontSize = 18;
    
    switch (innerType) {
        case YYActionItemTypeTitle:{
            color = [UIColor grayColorWithValue:120];
            fontSize = 12;
            break;
        }
            
        case YYActionItemTypeCancle:{
            color = [UIColor grayColorWithValue:50];
            break;
        }
            
        case YYActionItemTypeDestructive:{
            color = [UIColor colorWithHex:0xDD1D35];
            break;
        }
            
        default:{
            color = [UIColor grayColorWithValue:50];
            break;
        }
    }
    
    [self.button setTitleColor:color forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    self.lineView.hidden = hideLine;
}

- (YYActionItemType)type {
    return self.innerType;
}
@end
