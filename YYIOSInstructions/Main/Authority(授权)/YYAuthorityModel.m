//
//  YYAuthorityModel.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/12.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYAuthorityModel.h"

@implementation YYAuthorityModel

+ (NSString *)titleWithType:(YYAuthorityType)type{
    
    NSString *title = nil;
    switch (type) {
        case YYAuthorityTypeLocation:
            title = @"定位服务";
            break;
            
        case YYAuthorityTypeContact:
            title = @"通讯录";
            break;
            
        case YYAuthorityTypeCalendar:
            title = @"日历";
            break;
            
        case YYAuthorityTypeReminder:
            title = @"提醒事项";
            break;
            
        case YYAuthorityTypePhoto:
            title = @"照片";
            break;
            
        case YYAuthorityTypeBluetooth:
            title = @"蓝牙共享";
            break;
            
        case YYAuthorityTypeMicrophone:
            title = @"麦克风";
            break;
            
        case YYAuthorityTypeSpeechRecognition:
            title = @"语音识别";
            break;
            
        case YYAuthorityTypeCamera:
            title = @"相机";
            break;
            
        case YYAuthorityTypeHealth:
            title = @"健康";
            break;
            
        case YYAuthorityTypeHomeKit:
            title = @"HomeKit";
            break;
            
        case YYAuthorityTypeMediaLibrary:
            title = @"媒体资料库";
            break;
            
        case YYAuthorityTypeMotion:
            title = @"运动与健康";
            break;
            
        default:
            break;
    }
    return title;
}

+ (YYAuthorityModel *)modelWithType:(YYAuthorityType)type{
    YYAuthorityModel *model = [[YYAuthorityModel alloc] init];
    model.type = type;
    model.needAuthorize = YES;
    model.detail = nil;
    return model;
}
@end
