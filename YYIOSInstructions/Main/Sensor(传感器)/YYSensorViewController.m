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
#import <ImageIO/CGImageProperties.h>

@interface YYSensorViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIButton   *pedometerEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton   *accelerationEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton   *gyroEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton   *proximityEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton   *magnetEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton   *cameraEnableBtn;

// 光线
@property (weak, nonatomic) IBOutlet UIView     *lightVideoV;
@property (weak, nonatomic) IBOutlet UILabel    *screenBightnessLbl;
@property (weak, nonatomic) IBOutlet UILabel    *cameraBightnessLbl;

// 距离传感器
@property (weak, nonatomic) IBOutlet UISwitch   *proximitySwitch;

// 计步器
@property (weak, nonatomic) IBOutlet UILabel    *pedometerStartLbl;
@property (weak, nonatomic) IBOutlet UILabel    *pedometerEndLbl;
@property (weak, nonatomic) IBOutlet UILabel    *pedometerNowLbl;
@property (weak, nonatomic) IBOutlet UILabel    *pedometerStepCountLbl;
@property (weak, nonatomic) IBOutlet UILabel    *pedometerDistanceLbl;
@property (weak, nonatomic) IBOutlet UILabel    *pedometerSpeedLbl;

// 加速计
@property (weak, nonatomic) IBOutlet UILabel    *accelerationXLbl;
@property (weak, nonatomic) IBOutlet UILabel    *accelerationYLbl;
@property (weak, nonatomic) IBOutlet UILabel    *accelerationZLbl;
@property (weak, nonatomic) IBOutlet UIImageView *shakeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *santaClausImgV;

// 陀螺仪
@property (weak, nonatomic) IBOutlet UILabel    *gyroXLbl;
@property (weak, nonatomic) IBOutlet UILabel    *gyroYLbl;
@property (weak, nonatomic) IBOutlet UILabel    *gyroZLbl;
@property (weak, nonatomic) IBOutlet UILabel    *gyroRateLbl;

// 磁力计
@property (weak, nonatomic) IBOutlet UILabel    *magnetXLbl;
@property (weak, nonatomic) IBOutlet UILabel    *magnetYLbl;
@property (weak, nonatomic) IBOutlet UILabel    *magnetZLbl;

// 其他
@property (nonatomic, strong) CMMotionManager   *motionManage;
@property (nonatomic, strong) CMPedometer       *pedometer;
@property (nonatomic, strong) AVCaptureSession  *captureSession;
@property (nonatomic, strong) NSTimer           *brightnessTimer;

@end

@implementation YYSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkEnable];
}

- (void)setupSubviews {
    // 距离传感器默认是关闭的
    self.proximitySwitch.on = NO;
}

// 检查设备的可用性
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
    
    // 摄像头
    self.magnetEnableBtn.enabled = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 显示提示信息
- (void)showWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

// 结束处理
- (void)dealloc{
    
    // 光线
    if(self.brightnessTimer) {
        [self.brightnessTimer invalidate];
        self.brightnessTimer = nil;
    }
    if(_captureSession){
        [self.captureSession stopRunning];
        self.captureSession = nil;
    }
    
    // 距离传感器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 计步器
    if (_pedometer) {
        [self.pedometer stopPedometerUpdates];
        [self.pedometer stopPedometerEventUpdates];
        self.pedometer = nil;
    }
    
    // 加速计、陀螺仪、磁力计
    if (_motionManage) {
        [self.motionManage stopAccelerometerUpdates];
        [self.motionManage stopGyroUpdates];
        [self.motionManage stopMagnetometerUpdates];
        [self.motionManage stopDeviceMotionUpdates];
        self.motionManage = nil;
    }
}

- (CMMotionManager *)motionManage {
    if (!_motionManage) {
        
        _motionManage = [[CMMotionManager alloc] init];
        // 控制传感器的更新间隔
        _motionManage.accelerometerUpdateInterval = 0.2;
        _motionManage.gyroUpdateInterval = 0.5;
        _motionManage.magnetometerUpdateInterval = 0.5;
    }
    return _motionManage;
}

- (CMPedometer *)pedometer {
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer;
}


#pragma makr - 光线检测
/*
 1.  <GraphicsServices/GraphicsServices.h>提供光线强度的检测，但为苹果私有api，不允许上架产品使用，所以使用其它方式检测
 
 2. 检测屏幕亮度
        1. 对手机自动亮度调节进行设置，设置-->显示与亮度-->允许自动亮度调节
        2. 当手机感受到外界光线亮度变化时，会自动调节屏幕亮度；或手动调节屏幕亮度
        3. 通过[UIScreen mainScreen].brightness，可以获取屏幕亮度
 
 3. 摄像头检测：通过对摄像头捕获的视频流进行分析
 */

// 屏幕光线检测
- (IBAction)screenBrightnessTest:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        __weak typeof (self) weakSelf = self;
        self.brightnessTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakSelf.screenBightnessLbl.text = [NSString stringWithFormat:@"%.2f",[UIScreen mainScreen].brightness];
        }];
    } else {
        sender.selected = NO;
        [self.brightnessTimer invalidate];
        self.brightnessTimer = nil;
    }
}

// 摄像头光线检测
- (IBAction)cameraBrightnessTest:(UIButton *)sender {
    if (!sender.selected) {
        
        BOOL cameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!cameraAvailable) {
            [self showWithTitle:@"摄像头不可用" message:nil];
            return;
        }
        
        __weak typeof (self) weakSelf = self;
        // 第一次会弹框请求授权，之后直接获取授权状态；如果未授权，视频为黑色画面，音频没声音
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // 非主线程
            NSLog(@"%@", [NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                //获取授权状态
                //AVAuthorizationStatus cameraAS = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (!granted) {
                    [weakSelf showWithTitle:@"摄像头未被授权" message:@"前往设置-->隐私-->相机 选择允许访问"];
                    return ;
                }
                sender.selected = YES;
                [weakSelf.captureSession startRunning];
            });
        }];
    } else {
        sender.selected = NO;
        [self.captureSession stopRunning];
    }
}

// 初始化视频流
- (AVCaptureSession *)captureSession {
    // 第一次创建AVCaptureDeviceInput对象时系统会自动向用户请求授权
    if (!_captureSession) {
        
        NSError *error;
        AVCaptureSession *captureSession = [AVCaptureSession new];
        _captureSession = captureSession;
        
        // 输入
        AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:&error];
        if ([captureSession canAddInput:cameraDeviceInput]) {
            [captureSession addInput:cameraDeviceInput];
        }
        
        // 输出
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        if ([captureSession canAddOutput:output]) {
            [captureSession addOutput:output];
        }
        
        // 实时预览
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
        previewLayer.frame = self.lightVideoV.bounds;
        [self.lightVideoV.layer addSublayer:previewLayer];
    }
    return _captureSession;
}

// 输出视频流
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    
    NSDictionary *exifMetadata = [metadata[(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [exifMetadata[(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    self.cameraBightnessLbl.text = [NSString stringWithFormat:@"%.2f",brightnessValue];
}

#pragma mark - 距离传感器

// 距离传感器测试
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
        
        // pedometer第一次被使用时，才会由系统提示用户授权“运动与健康”;但没找到授权的相关方法，通过该方式也可以实现需求
        __weak typeof (self) weakSelf = self;
        [self.pedometer queryPedometerDataFromDate:[NSDate date] toDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            // 用户选择了授权与否之后，该block才会被调用，不在主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // 授权判断
                if(![CMSensorRecorder isAuthorizedForRecording]){
                    [weakSelf showWithTitle:@"未授权" message:@"前往设置－>隐私->运动与健康，点击允许访问"];
                    return;
                }
                sender.selected = YES;
                
                // 监测计步器状态：暂停、恢复
                [weakSelf.pedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
                    NSLog(@"%@",pedometerEvent.type==CMPedometerEventTypePause? @"暂停":@"继续");
                }];
                
                // 监测计步器数据
                [weakSelf.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
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
            });
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
