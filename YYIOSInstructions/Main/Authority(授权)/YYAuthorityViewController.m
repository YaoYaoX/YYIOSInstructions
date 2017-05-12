//
//  YYAuthorityViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/12.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYAuthorityViewController.h"
#import "YYAuthorityCell.h"
#import "YYAuthorityModel.h"
#import <CoreLocation/CoreLocation.h>

@interface YYAuthorityViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation YYAuthorityViewController

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self.tableView registerNib:[UINib nibWithNibName:@"YYAuthorityCell" bundle:nil] forCellReuseIdentifier:@"YYAuthorityCell"];
}

- (void)setupData{
    
    YYAuthorityModel *location = [YYAuthorityModel modelWithType:YYAuthorityTypeLocation];
    YYAuthorityModel *contact = [YYAuthorityModel modelWithType:YYAuthorityTypeContact];
    YYAuthorityModel *calendar = [YYAuthorityModel modelWithType:YYAuthorityTypeCalendar];
    YYAuthorityModel *reminder = [YYAuthorityModel modelWithType:YYAuthorityTypeReminder];
    YYAuthorityModel *photo = [YYAuthorityModel modelWithType:YYAuthorityTypePhoto];
    YYAuthorityModel *bluetooth = [YYAuthorityModel modelWithType:YYAuthorityTypeBluetooth];
    YYAuthorityModel *microphone = [YYAuthorityModel modelWithType:YYAuthorityTypeMicrophone];
    YYAuthorityModel *speechRecognition = [YYAuthorityModel modelWithType:YYAuthorityTypeSpeechRecognition];
    YYAuthorityModel *camera = [YYAuthorityModel modelWithType:YYAuthorityTypeCamera];
    YYAuthorityModel *health = [YYAuthorityModel modelWithType:YYAuthorityTypeHealth];
    YYAuthorityModel *homeKit = [YYAuthorityModel modelWithType:YYAuthorityTypeHomeKit];
    YYAuthorityModel *mediaLibrary = [YYAuthorityModel modelWithType:YYAuthorityTypeMediaLibrary];
    YYAuthorityModel *motion = [YYAuthorityModel modelWithType:YYAuthorityTypeMotion];
    
    [self.datas addObject:location];
    [self.datas addObject:contact];
    [self.datas addObject:calendar];
    [self.datas addObject:reminder];
    [self.datas addObject:photo];
    [self.datas addObject:bluetooth];
    [self.datas addObject:microphone];
    [self.datas addObject:speechRecognition];
    [self.datas addObject:camera];
    [self.datas addObject:health];
    [self.datas addObject:homeKit];
    [self.datas addObject:mediaLibrary];
    [self.datas addObject:motion];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYAuthorityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYAuthorityCell"];
    cell.model = self.datas[indexPath.row];
    __weak typeof (self) weakSelf = self;
    cell.authorizeBlock = ^(YYAuthorityModel *model){
        [weakSelf authorizeWithType:model.type];
    };
    return cell;
}

- (void)authorizeWithType:(YYAuthorityType)type {
    
    switch (type) {
        case YYAuthorityTypeLocation:{
            self.locationManager.delegate = self;
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
            
        case YYAuthorityTypeContact:{
            break;
        }
            
        case YYAuthorityTypeCalendar:{
            break;
        }
            
        case YYAuthorityTypeReminder:{
            break;
        }
            
        case YYAuthorityTypePhoto:{
            break;
        }
            
        case YYAuthorityTypeBluetooth:{
            break;
        }
            
        case YYAuthorityTypeMicrophone:{
            break;
        }
            
        case YYAuthorityTypeSpeechRecognition:{
            break;
        }
            
        case YYAuthorityTypeCamera:{
            break;
        }
            
        case YYAuthorityTypeHealth:{
            break;
        }
            
        case YYAuthorityTypeHomeKit:{
            break;
        }
            
        case YYAuthorityTypeMediaLibrary:{
            break;
        }
            
        case YYAuthorityTypeMotion:{
            break;
        }
            
        default:
            break;
    }
    
}

- (NSString *)checkEnableWithType:(YYAuthorityType)type{
    NSString *detail = nil;
    switch (type) {
        case YYAuthorityTypeLocation:{
            BOOL enable = [CLLocationManager locationServicesEnabled];
            if (!enable) {
                detail = @"系统的定位服务未开启";
            }
            break;
        }
            
        case YYAuthorityTypeContact:{
            break;
        }
            
        case YYAuthorityTypeCalendar:{
            break;
        }
            
        case YYAuthorityTypeReminder:{
            break;
        }
            
        case YYAuthorityTypePhoto:{
            break;
        }
            
        case YYAuthorityTypeBluetooth:{
            break;
        }
            
        case YYAuthorityTypeMicrophone:{
            break;
        }
            
        case YYAuthorityTypeSpeechRecognition:{
            break;
        }
            
        case YYAuthorityTypeCamera:{
            break;
        }
            
        case YYAuthorityTypeHealth:{
            break;
        }
            
        case YYAuthorityTypeHomeKit:{
            break;
        }
            
        case YYAuthorityTypeMediaLibrary:{
            break;
        }
            
        case YYAuthorityTypeMotion:{
            break;
        }
            
        default:
            break;
    }
    return detail;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

- (NSString *)configure{
    NSString *config = @"\
    <!-- 相册 -->\
    <key>NSPhotoLibraryUsageDescription</key>\
    <string>App需要您的同意,才能访问相册</string>\
    <!-- 相机 -->\
    <key>NSCameraUsageDescription</key>\
    <string>App需要您的同意,才能访问相机</string>\
    <!-- 麦克风 -->\
    <key>NSMicrophoneUsageDescription</key>\
    <string>App需要您的同意,才能访问麦克风</string>\
    <!-- 位置 -->\
    <key>NSLocationUsageDescription</key>\
    <string>App需要您的同意,才能访问位置</string>\
    <!-- 在使用期间访问位置 -->\
    <key>NSLocationWhenInUseUsageDescription</key>\
    <string>App需要您的同意,才能在使用期间访问位置</string>\
    <!-- 始终访问位置 -->\
    <key>NSLocationAlwaysUsageDescription</key>\
    <string>App需要您的同意,才能始终访问位置</string>\
    <!-- 日历 -->\
    <key>NSCalendarsUsageDescription</key>\
    <string>App需要您的同意,才能访问日历</string>\
    <!-- 提醒事项 -->\
    <key>NSRemindersUsageDescription</key>\
    <string>App需要您的同意,才能访问提醒事项</string>\
    <!-- 运动与健身 -->\
    <key>NSMotionUsageDescription</key> <string>App需要您的同意,才能访问运动与健身</string>\
    <!-- 健康更新 -->\
    <key>NSHealthUpdateUsageDescription</key>\
    <string>App需要您的同意,才能访问健康更新 </string>\
    <!-- 健康分享 -->\
    <key>NSHealthShareUsageDescription</key>\
    <string>App需要您的同意,才能访问健康分享</string>\
    <!-- 蓝牙 -->\
    <key>NSBluetoothPeripheralUsageDescription</key>\
    <string>App需要您的同意,才能访问蓝牙</string> \
    <!-- 媒体资料库 --> \
    <key>NSAppleMusicUsageDescription</key>\
    <string>App需要您的同意,才能访问媒体资料库</string>";
    return config;
}
@end
