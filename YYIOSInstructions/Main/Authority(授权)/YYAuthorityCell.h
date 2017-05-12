//
//  YYAuthorityCell.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/12.
//  Copyright © 2017年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAuthorityModel;

@interface YYAuthorityCell : UITableViewCell

@property (nonatomic, strong) YYAuthorityModel *model;
@property (nonatomic, copy) void(^authorizeBlock)(YYAuthorityModel *);

@end
