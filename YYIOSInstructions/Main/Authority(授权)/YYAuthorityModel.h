//
//  YYAuthorityModel.h
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/12.
//  Copyright © 2017年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YYAuthorityType) {
    /// 定位服务
    YYAuthorityTypeLocation,
    /// 通讯录
    YYAuthorityTypeContact,
    /// 日历
    YYAuthorityTypeCalendar,
    /// 提醒事项
    YYAuthorityTypeReminder,
    /// 照片
    YYAuthorityTypePhoto,
    /// 蓝牙共享
    YYAuthorityTypeBluetooth,
    /// 麦克风
    YYAuthorityTypeMicrophone,
    /// 语音识别
    YYAuthorityTypeSpeechRecognition,
    /// 相机
    YYAuthorityTypeCamera,
    /// 健康
    YYAuthorityTypeHealth,
    /// HomeKit
    YYAuthorityTypeHomeKit,
    /// 媒体资料库
    YYAuthorityTypeMediaLibrary,
    /// 运动与健康
    YYAuthorityTypeMotion
};

@interface YYAuthorityModel : NSObject

@property (nonatomic, assign) YYAuthorityType type;
@property (nonatomic, assign) YYAuthorityType needAuthorize;
@property (nonatomic, assign) NSString *detail;

+ (YYAuthorityModel *)modelWithType:(YYAuthorityType)type;
+ (NSString *)titleWithType:(YYAuthorityType)type;

@end
