//
//  YYShowFileController.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 2019/3/7.
//  Copyright © 2019 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYFileType) {
    YYFileTypeUnKnow,
    YYFileTypeDocument,
    YYFileTypeImage,
    YYFileTypeText,
    YYFileTypeMultiMedia,
    YYFileTypeLastPage
};

@interface YYShowFileController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *name;

+ (instancetype)controllerWithFileType:(YYFileType)fileType;

@end

@interface YYShowTxtFileController : YYShowFileController

@end

@interface YYShowImageController : YYShowFileController
@end

NS_ASSUME_NONNULL_END
