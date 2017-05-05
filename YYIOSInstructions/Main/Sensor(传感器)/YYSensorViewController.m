//
//  YYSensorViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/5.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYSensorViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface YYSensorViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pedometerEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *accelerationEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *gyroEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *proximityEnableBtn;

@property (weak, nonatomic) IBOutlet UISwitch *proximitySwitch;

@property (weak, nonatomic) IBOutlet UILabel  *pedometerStartLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerEndLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerNowLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerStepCountLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerDistanceLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerSpeedLbl;


@property (weak, nonatomic) IBOutlet UILabel *accelerationXLbl;
@property (weak, nonatomic) IBOutlet UILabel *accelerationYLbl;
@property (weak, nonatomic) IBOutlet UILabel *accelerationZLbl;

@property (weak, nonatomic) IBOutlet UILabel *gyroRateLbl;

@property (nonatomic, strong) CMMotionManager *motionManage;
@property (nonatomic, strong) CMPedometer     *pedometer;
@property (nonatomic, assign) CMAcceleration  currentAcceleration;

@end

@implementation YYSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSensor];
    [self checkEnable];
}

- (void)setupSubviews {
    // 距离传感器默认是关闭的
    self.proximitySwitch.on = NO;
}

- (void)initSensor {
    
    self.motionManage = [[CMMotionManager alloc] init];
    // 控制加速计更新间隔
    self.motionManage.accelerometerUpdateInterval = 0.5;
    // 控制陀螺仪更新间隔
    self.motionManage.gyroUpdateInterval = 0.5;
    
    self.pedometer = [[CMPedometer alloc] init];
}

- (void)checkEnable{
    
    // 距离传感器
    // 当设置proximityMonitoringEnabled为YES后，属性值仍然为NO，说明传感器不可用。
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    self.proximityEnableBtn.enabled = [UIDevice currentDevice].proximityMonitoringEnabled;
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    
    // 计步器
    // 有记步、距离、步数...的检测，这里简单检测记步功能
    self.pedometerEnableBtn.enabled = [CMPedometer isStepCountingAvailable];
    
    // 加速计
    self.accelerationEnableBtn.enabled = self.motionManage.isAccelerometerAvailable;
    
    // 陀螺仪
    self.gyroEnableBtn.enabled = self.motionManage.isGyroAvailable;
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 距离传感器

- (IBAction)proximitySwitch:(UISwitch *)sender {
    
    [UIDevice currentDevice].proximityMonitoringEnabled = sender.on;
    
    // 不可用提示
    if (sender.on && ![UIDevice currentDevice].proximityMonitoringEnabled) {
        sender.on = NO;
        [self showWithTitle:@"距离传感器不可用" message:nil];
        return;
    }
    
    // 通知监听状态
    if (sender.on) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil
         ];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)proximityStateChange:(NSNotification *)noti {
    UIDevice *device = noti.object;
    if ([device isKindOfClass:[UIDevice class]]) {
        // 是否有物体靠近
        NSLog(@"%@", (device.proximityState? @"物体靠近" : @"物体离开"));
    }
}

- (void)dealloc{
    
    // 距离传感器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 计步器
    [self.pedometer stopPedometerUpdates];
    [self.pedometer stopPedometerEventUpdates];
    
    // 加速计、陀螺仪
    [self.motionManage stopAccelerometerUpdates];
    [self.motionManage stopGyroUpdates];
}

#pragma mark - 计步器

/* 
 * 使用计步器需添加权限NSMotionUsageDescription描述
 * 第一次使用的时候系统自动会向用户请求授权 
 * 授权判断：[CMSensorRecorder isAuthorizedForRecording];
 */
- (IBAction)recordStepCount:(UIButton *)sender {
    
    BOOL start = !sender.selected;
    if(start){
        
        // 可用性检测
        if(![CMPedometer isStepCountingAvailable]){
            [self showWithTitle:@"计步器不可用" message:nil];
            return;
        }
        
        // 授权判断
        if(![CMSensorRecorder isAuthorizedForRecording]){
            [self showWithTitle:@"未授权" message:@"前往设置－>隐私->运动与健康，点击允许访问"];
            return;
        }
        sender.selected = YES;
        
        // 监测计步器状态：暂停、恢复
        __weak typeof (self) weakSelf = self;
        [self.pedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
            NSLog(@"%@",pedometerEvent.type==CMPedometerEventTypePause? @"暂停":@"继续");
        }];
        
        // 监测计步器数据
        [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (pedometerData) {
                // 回调不在主线程，所以需要回到主线程处理
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = @"HH:mm:ss";
                    weakSelf.pedometerStartLbl.text = [df stringFromDate:pedometerData.startDate];
                    weakSelf.pedometerEndLbl.text = [df stringFromDate:pedometerData.endDate];
                    weakSelf.pedometerNowLbl.text = [df stringFromDate:[NSDate date]];
                    weakSelf.pedometerStepCountLbl.text = [NSString stringWithFormat:@"%ld", pedometerData.numberOfSteps.integerValue];
                    weakSelf.pedometerDistanceLbl.text = [NSString stringWithFormat:@"%f", pedometerData.distance.floatValue];
                    weakSelf.pedometerSpeedLbl.text = [NSString stringWithFormat:@"%f",3.6/pedometerData.averageActivePace.floatValue];
                });
            }
        }];
    } else {
        // 结束记步
        sender.selected = NO;
        [self.pedometer stopPedometerUpdates];
        [self.pedometer stopPedometerEventUpdates];
    }
}

#pragma mark - 加速计

- (IBAction)accelerometerTest:(UIButton *)sender {
    
    BOOL start = !sender.selected;
    if (start) {
        
        // 可用性检测
        if(![self.motionManage isAccelerometerAvailable]){
            [self showWithTitle:@"加速计不可用" message:nil];
            return;
        }
        
        sender.selected = YES;
        
        // 更新比较频繁，建议不使用主线程
        __weak typeof (self) weakSelf = self;
        [self.motionManage startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            CGFloat x = accelerometerData.acceleration.x;
            CGFloat y = accelerometerData.acceleration.y;
            CGFloat z = accelerometerData.acceleration.z;
            BOOL changedX = fabs(weakSelf.currentAcceleration.x - x) >=0.1;
            BOOL changedY = fabs(weakSelf.currentAcceleration.y - y) >=0.1;
            BOOL changedZ = fabs(weakSelf.currentAcceleration.z - z) >=0.1;
            
            // 数据更新比较敏感，只在变化在一定范围内再更新界面上的数据
            if (changedX || changedY || changedZ) {
                CMAcceleration acceleration = {x, y, z};
                weakSelf.currentAcceleration = acceleration;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.accelerationXLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.x];
                    weakSelf.accelerationYLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.y];
                    weakSelf.accelerationZLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.z];
                });
            }
        }];
        
        [self.motionManage startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            NSLog(@"x:%.2f  y:%.2f  z:%.2f",gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
            CGFloat x = gyroData.rotationRate.x;
            CGFloat y = gyroData.rotationRate.y;
            CGFloat z = gyroData.rotationRate.z;
            CGFloat rate = sqrt(x*x + y*y + z*z);
            weakSelf.gyroRateLbl.text = [NSString stringWithFormat:@"%.2f", rate];
        }];
        
    } else {
        sender.selected = NO;
        [self.motionManage stopAccelerometerUpdates];
        [self.motionManage stopGyroUpdates];
    }
}

@end
