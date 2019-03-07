//
//  YYShowFileController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 2019/3/7.
//  Copyright © 2019 YY. All rights reserved.
//

#import "YYShowFileController.h"

@interface YYShowFileController ()

- (void)setupSubviews;
- (void)loadFile:(NSURL *)url;

@end


@implementation YYShowFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.title = self.name;
    [self loadFile:self.url];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadFile:(NSURL *)url {
}

- (void)setName:(NSString *)name {
    _name = name;
    self.title = name;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self loadFile:_url];
}

+ (instancetype)controllerWithFileType:(YYFileType)fileType {
    if (fileType == YYFileTypeText) {
        YYShowTxtFileController *txtVC = [[YYShowTxtFileController alloc] init];
        return txtVC;
    } else if (fileType == YYFileTypeImage) {
        YYShowImageController *txtVC = [[YYShowImageController alloc] init];
        return txtVC;
    } else {
        YYShowFileController *txtVC = [[YYShowFileController alloc] init];
        return txtVC;
    }
}

@end





@interface YYShowTxtFileController ()
@property (nonatomic, weak) UIScrollView *scrollview;
@property (nonatomic, weak) UILabel *label;
@end

@implementation YYShowTxtFileController
- (void)setupSubviews {
    [super setupSubviews];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopArea)];
    scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0)];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [scrollview addSubview:label];
    self.label = label;
}

- (void)loadFile:(NSURL *)url {
    if (url) {
        // TODO：大文件加载异常
        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        self.label.text = string;
        CGFloat height = [string boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8]} context:nil].size.height;
        CGRect frame = self.label.frame;
        frame.size.height = height;
        self.label.frame = frame;
        self.scrollview.contentSize = CGSizeMake(0, height + 20);
    }
}

@end





@interface YYShowImageController ()
@property (nonatomic, weak) UIImageView *imageview;
@end

@implementation YYShowImageController
- (void)setupSubviews {
    [super setupSubviews];
    
    CGFloat top = kTopArea + 40;
    CGFloat margin = 10;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(margin, top + margin, kScreenWidth - margin * 2, kScreenHeight - top - margin * 2)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.layer.shadowColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1].CGColor;
    imageview.layer.shadowOffset = CGSizeMake(0, 4);
    imageview.layer.shadowRadius = 10;
    imageview.layer.shadowOpacity = 0.4;
    self.imageview = imageview;
    [self.view addSubview:imageview];
}

- (void)loadFile:(NSURL *)url {
    if (url) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.imageview.image = image;
    }
}
@end

