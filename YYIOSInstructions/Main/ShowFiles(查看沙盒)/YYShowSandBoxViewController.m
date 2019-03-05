//
//  YYShowSandBoxViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 2019/3/5.
//  Copyright © 2019 YY. All rights reserved.
//

#import "YYShowSandBoxViewController.h"

#define KCustomGreenColor [UIColor colorWithRed:90/256.0 green:196/256.0 blue:84/256.0 alpha:1]

typedef NS_ENUM(NSUInteger, YYFileType) {
    YYFileTypeUnKnow,
    YYFileTypeDocument,
    YYFileTypeImage,
    YYFileTypeText,
    YYFileTypeMultiMedia,
    YYFileTypeLastPage
};

@interface YYShowSandBoxViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, weak) UIButton *airDropBtn;

@end

@implementation YYShowSandBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查看文件";
    self.currentPath = NSHomeDirectory();
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kTopArea)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    [self.view addSubview:tableview];
    self.tableview = tableview;
    [self loadFileData];
    
    // airdrop
    UIButton *airdropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    airdropBtn.frame = CGRectMake(0, 0,06, 40);
    airdropBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [airdropBtn setTitleColor:KCustomGreenColor forState:UIControlStateNormal];
    [airdropBtn setTitle:@"AirDrop" forState:UIControlStateNormal];
    [airdropBtn addTarget:self action:@selector(airDropCurrentDocument) forControlEvents:UIControlEventTouchUpInside];
    self.airDropBtn = airdropBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:airdropBtn];
}

- (void)airDropCurrentDocument {
    [self airDropWithFileName:nil];
}

- (void)airDropWithFileName:(NSString *)fileName {
    NSString *path = self.currentPath;
    if (fileName.length > 0) {
        path = [path stringByAppendingPathComponent:fileName];
    }
    
    NSString *homePath = NSHomeDirectory();
    if (![path hasPrefix:homePath] ||
        [path isEqualToString:homePath]) {
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }
    
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    if (fileUrl) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrl] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

// 返回上一层
- (void)gotoLastDocument {
    NSString *path = [self.currentPath stringByDeletingLastPathComponent];
    if (![path hasPrefix:NSHomeDirectory()]) {
        return;
    }
    self.currentPath = path;
    [self loadFileData];
}

// 加载文件列表
- (void)loadFileData {
    self.airDropBtn.hidden = [self.currentPath isEqualToString:NSHomeDirectory()];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *file = [fileMgr contentsOfDirectoryAtPath:self.currentPath error:nil];
    self.array = [NSMutableArray arrayWithArray:file];
    [self.tableview reloadData];
}

- (YYFileType)typeOfFile:(NSString *)fileName {
    NSString *path = [self.currentPath stringByAppendingPathComponent:fileName];
    BOOL isdir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    if (isdir) {
        return YYFileTypeDocument;
    } else {
        NSString *pathExtension = [path pathExtension].lowercaseString;
        if ([@[@"jpeg",@"bmp",@"gif",@"jpg",@"pic",@"png",@"tif"] containsObject:pathExtension]) {
            return YYFileTypeImage;
        } else if ([@[@"txt",@"pdf",@"doc"] containsObject:pathExtension]) {
            return YYFileTypeText;
        } else if ([@[@"mov",@"avi",@"mp4"] containsObject:pathExtension]) {
            return YYFileTypeMultiMedia;
        }
    }
    return YYFileTypeUnKnow;
}

- (UIImage *)iconOfType:(YYFileType)fileType {
    switch (fileType) {
        case YYFileTypeText:
            return [UIImage imageNamed:@"doc_text"];
        case YYFileTypeImage:
            return [UIImage imageNamed:@"doc_image"];
        case YYFileTypeDocument:
            return [UIImage imageNamed:@"doc_folder"];
        case YYFileTypeMultiMedia:
            return [UIImage imageNamed:@"doc_media"];
        case YYFileTypeLastPage:
            return [UIImage imageNamed:@"doc_back"];
        default:
            return [UIImage imageNamed:@"doc_unknown"];
    }
}

#pragma mark - delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"返回上一层";
        cell.imageView.image = [self iconOfType:YYFileTypeLastPage];
    } else {
        NSString *name = self.array[indexPath.row-1];
        cell.textLabel.text = name;
        YYFileType fileType = [self typeOfFile:name];
        cell.imageView.image = [self iconOfType:fileType];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self gotoLastDocument];
    } else {
        NSString *name = self.array[indexPath.row-1];
        NSString *path = [self.currentPath stringByAppendingPathComponent:name];
        BOOL isdir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
        if (isdir) {
            self.currentPath = [self.currentPath stringByAppendingPathComponent:name];
            [self loadFileData];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        __weak typeof(self) weakSelf = self;
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSString *name = weakSelf.array[indexPath.row - 1];
            NSString *path = [weakSelf.currentPath stringByAppendingPathComponent:name];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [weakSelf.array removeObjectAtIndex:indexPath.row-1];
            [weakSelf.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
        
        UITableViewRowAction *airdrop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"AirDrop" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSString *name = weakSelf.array[indexPath.row - 1];
            [weakSelf airDropWithFileName:name];
        }];
        airdrop.backgroundColor = KCustomGreenColor;
        
        return @[delete,airdrop];
    }
    return nil;
}

@end
