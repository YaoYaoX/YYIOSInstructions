//
//  YYSensorViewController.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/5.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYSensorViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

@interface YYSensorViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pedometerEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *accelerationEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *gyroEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *proximityEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *magnetEnableBtn;

// 光线
@property (weak, nonatomic) IBOutlet UIView *lightVideo;

// 距离传感器
@property (weak, nonatomic) IBOutlet UISwitch *proximitySwitch;

// 计步器
@property (weak, nonatomic) IBOutlet UILabel  *pedometerStartLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerEndLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerNowLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerStepCountLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerDistanceLbl;
@property (weak, nonatomic) IBOutlet UILabel  *pedometerSpeedLbl;


// 加速计
@property (weak, nonatomic) IBOutlet UILabel *accelerationXLbl;
@property (weak, nonatomic) IBOutlet UILabel *accelerationYLbl;
@property (weak, nonatomic) IBOutlet UILabel *accelerationZLbl;
@property (weak, nonatomic) IBOutlet UIImageView *shakeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *santaClausImgV;

// 陀螺仪
@property (weak, nonatomic) IBOutlet UILabel *gyroXLbl;
@property (weak, nonatomic) IBOutlet UILabel *gyroYLbl;
@property (weak, nonatomic) IBOutlet UILabel *gyroZLbl;
@property (weak, nonatomic) IBOutlet UILabel *gyroRateLbl;

// 磁力计
@property (weak, nonatomic) IBOutlet UILabel *magnetXLbl;
@property (weak, nonatomic) IBOutlet UILabel *magnetYLbl;
@property (weak, nonatomic) IBOutlet UILabel *magnetZLbl;

// 其他
@property (nonatomic, strong) CMMotionManager *motionManage;
@property (nonatomic, strong) CMPedometer     *pedometer;

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
    // 控制传感器的更新间隔
    self.motionManage.accelerometerUpdateInterval = 0.2;
    self.motionManage.gyroUpdateInterval = 0.5;
    self.motionManage.magnetometerUpdateInterval = 0.5;
    
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
    
    // 磁力计
    self.magnetEnableBtn.enabled = self.motionManage.isMagnetometerAvailable;
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma makr - 光线检测

- (void)capture{
    
    NSError *error;
    AVCaptureSession *captureSession = [AVCaptureSession new];
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:&error];
    if ([captureSession canAddInput:cameraDeviceInput]) {
        [captureSession addInput:cameraDeviceInput];
    }
    [captureSession startRunning];
    
    
    CMTime frameDuration = CMTimeMake(1, 60);
    NSArray *supportedFrameRateRanges = [cameraDevice.activeFormat videoSupportedFrameRateRanges];
    BOOL frameRateSupported = NO;
    for (AVFrameRateRange *range in supportedFrameRateRanges) {
        if (CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) &&
            CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
            frameRateSupported = YES;
        }
    }
    if (frameRateSupported && [cameraDevice lockForConfiguration:&error]) {
        [cameraDevice setActiveVideoMaxFrameDuration:frameDuration];
        [cameraDevice setActiveVideoMinFrameDuration:frameDuration];
        [cameraDevice unlockForConfiguration];
    }

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.lightVideo.bounds;

    [self.lightVideo.layer addSublayer:previewLayer];
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
    
    // 加速计、陀螺仪、磁力计
    [self.motionManage stopAccelerometerUpdates];
    [self.motionManage stopGyroUpdates];
    [self.motionManage stopMagnetometerUpdates];
    [self.motionManage stopDeviceMotionUpdates];
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
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"%f",[UIScreen mainScreen].brightness);
                
                weakSelf.accelerationXLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.x];
                weakSelf.accelerationYLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.y];
                weakSelf.accelerationZLbl.text = [NSString stringWithFormat:@"%.2f", accelerometerData.acceleration.z];
                
                [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    CGFloat x = accelerometerData.acceleration.x;
                    CGFloat y = accelerometerData.acceleration.y;
                    if(y<0){
                        weakSelf.santaClausImgV.transform = CGAffineTransformMakeRotation(-x*M_PI_2);
                    
                    } else {
                        weakSelf.santaClausImgV.transform = CGAffineTransformMakeRotation(-M_PI_2-(1-x)*M_PI_2);
                    }
                } completion:nil];
            });
        }];
    } else {
        sender.selected = NO;
        [self.motionManage stopAccelerometerUpdates];
    }
}

#pragma mark 自带的通过加速计检测摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"motionBegan");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"motionCancelled ");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"motionEnded");
    CAKeyframeAnimation *ani = [[CAKeyframeAnimation alloc] init];
    ani.values = @[@-M_PI_4,@M_PI_4,@-M_PI_4,@M_PI_4,@-M_PI_4,@M_PI_4];
    ani.duration = 0.25;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.shakeImgV.layer addAnimation:ani forKey:@"transform.rotation"];
}

#pragma mark - 陀螺仪

- (IBAction)gyroTest:(UIButton *)sender {
    
    BOOL start = !sender.selected;
    if (start) {
        
        // 可用性检测
        if(![self.motionManage isAccelerometerAvailable]){
            [self showWithTitle:@"陀螺仪不可用" message:nil];
            return;
        }
        
        sender.selected = YES;
        
        __weak typeof (self) weakSelf = self;
        [self.motionManage startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            
            CGFloat x = gyroData.rotationRate.x;
            CGFloat y = gyroData.rotationRate.y;
            CGFloat z = gyroData.rotationRate.z;
            CGFloat rate = sqrt(x*x + y*y + z*z);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.gyroXLbl.text = [NSString stringWithFormat:@"%.2f", x];
                weakSelf.gyroYLbl.text = [NSString stringWithFormat:@"%.2f", y];
                weakSelf.gyroZLbl.text = [NSString stringWithFormat:@"%.2f", z];
                weakSelf.gyroRateLbl.text = [NSString stringWithFormat:@"%.2f", rate];
            });
        }];
        
    } else {
        sender.selected = NO;
        [self.motionManage stopGyroUpdates];
    }
}

#pragma mark -  磁力

- (IBAction)magnetTest:(UIButton *)sender {
    
    BOOL start = !sender.selected;
    if (start) {
        
        // 可用性检测
        if(![self.motionManage isMagnetometerAvailable]){
            [self showWithTitle:@"磁力计不可用" message:nil];
            return;
        }
        
        sender.selected = YES;
        
        __weak typeof (self) weakSelf = self;
        [self.motionManage startMagnetometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            
            CGFloat x = magnetometerData.magneticField.x;
            CGFloat y = magnetometerData.magneticField.y;
            CGFloat z = magnetometerData.magneticField.z;

            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.magnetXLbl.text = [NSString stringWithFormat:@"%.2f", x];
                weakSelf.magnetYLbl.text = [NSString stringWithFormat:@"%.2f", y];
                weakSelf.magnetZLbl.text = [NSString stringWithFormat:@"%.2f", z];
            });
        }];
        
    } else {
        sender.selected = NO;
        [self.motionManage stopMagnetometerUpdates];
    }
}

#pragma mark -  综合

- (IBAction)motionTest:(UIButton *)sender {
    
    BOOL start = !sender.selected;
    if (start) {
        
        // 检测加速计和陀螺仪，由于设备都有加速计，所以等效于陀螺仪检测
        if(![self.motionManage isDeviceMotionAvailable]){
            return;
        }
        
        sender.selected = YES;
        
        // 获取的数据综合了加速计、陀螺仪、磁力计
        [self.motionManage startDeviceMotionUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            // 数据处理
            /*
            CMAttitude *attitude =  motion.attitude;
            CMRotationRate rotationRate = motion.rotationRate;
            CMCalibratedMagneticField magnet = motion.magneticField;
            CMAcceleration gravity = motion.gravity;
            CMAcceleration userAcceleration = motion.userAcceleration;
             */
        }];
        
    } else {
        sender.selected = NO;
        [self.motionManage stopDeviceMotionUpdates];
    }
}

@end
