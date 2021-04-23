//
//  APKPreviewViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/21.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKPreviewViewController.h"
#import "APKDVR.h"
#import "MBProgressHUD.h"
#import "APKAlertTool.h"
#import "APKDVRCommandFactory.h"
#import "APKRealTimeViewingController.h"
#import "APKLockRemainingTimeRecorder.h"
#import "APKPromiseView.h"
#import "sys/utsname.h"

@interface APKPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet UIView *disconnectView;
@property (weak, nonatomic) IBOutlet UILabel *disconnectLabel;
@property (weak, nonatomic) IBOutlet UIButton *captureButton2;
@property (weak, nonatomic) IBOutlet UIButton *videocamButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIView *xiongfengComponentsView;
@property (weak, nonatomic) IBOutlet UILabel *lockRemainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *eventBtnView;
@property (strong,nonatomic) APKRealTimeViewingController *realTimeViewing;
@property (assign,nonatomic) CGRect playerViewFrame1;//竖屏frame
@property (assign,nonatomic) CGRect playerViewFrame2;//横屏frame
@property (assign,nonatomic) CGRect fullScreenButtonFrame1;//竖屏frame
@property (assign,nonatomic) CGRect fullScreenButtonFrame2;//横屏frame
@property (assign,nonatomic) CGRect captureButtonFrame1;//竖屏frame
@property (assign,nonatomic) CGRect captureButtonFrame2;//横屏frame
@property (assign,nonatomic) CGRect xiongfengComponentsViewFrame1;//
@property (assign,nonatomic) CGRect captureButton2Frame1;//
@property (assign,nonatomic) CGRect videocamButtonFrame1;//
@property (assign,nonatomic) CGRect lockButtonFrame1;//
@property (assign,nonatomic) CGRect xiongfengComponentsViewFrame2;//
@property (assign,nonatomic) CGRect captureButton2Frame2;//
@property (assign,nonatomic) CGRect videocamButtonFrame2;//
@property (assign,nonatomic) CGRect lockButtonFrame2;//
@property (assign,nonatomic) BOOL isFullScreenMode;
@property (assign,nonatomic) BOOL isGettingRTSPUrl;
@property (assign,nonatomic) BOOL isRecording;
@property (strong,nonatomic) APKLockRemainingTimeRecorder *lockRemainingTimeRecorder;
@property (nonatomic,retain) UIView *backgroundView;

@property (nonatomic,retain) UILabel *disConnectedLable;
@property (strong,nonatomic) NSTimer *captureTimer;
@property (assign,nonatomic) CGFloat captureWaitingTime;//录制时间
@property (weak, nonatomic) IBOutlet UIButton *startEventBtn;
@property (strong,nonatomic) MBProgressHUD *captureHUD;
@property (nonatomic,retain) UIButton *eventBtn;
@end

@implementation APKPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"摄像机", nil);
    self.disconnectLabel.text = NSLocalizedString(@"未连接摄像机提示信息", nil);
    
    [self setupFrames];
    self.playerView.frame = self.playerViewFrame1;
    self.fullScreenButton.frame = self.fullScreenButtonFrame1;
//    self.captureButton.frame = self.captureButtonFrame1;
    self.xiongfengComponentsView.frame = self.xiongfengComponentsViewFrame1;
    self.captureButton2.frame = self.captureButton2Frame1;
    self.videocamButton.frame = self.videocamButtonFrame1;
    self.lockButton.frame = self.lockButtonFrame1;
    self.lockRemainingTimeLabel.frame = self.lockButtonFrame1;
    
    [self.view sendSubviewToBack:self.titleView];
    [self.view bringSubviewToFront:self.playerView];
    [self.view bringSubviewToFront:self.fullScreenButton];
    [self.view sendSubviewToBack:self.eventBtnView];
    
    self.titleL.text = NSLocalizedString(@"摄像机", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
           
    NSString *iphone = [self getIphoneType];
    if ([iphone isEqualToString:@"iPhone 12 mini"]) {
        self.captureButton.frame = CGRectMake(CGRectGetMinX(self.captureButton.frame), CGRectGetMinY(self.captureButton.frame), 90, 90);
        self.startEventBtn.frame = CGRectMake(CGRectGetMinX(self.startEventBtn.frame), CGRectGetMinY(self.startEventBtn.frame), 90, 90);

    }
}

-(void)correctTime
{
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
        NSString *currentTime = [dateFormatter stringFromDate:date];
        [[APKDVRCommandFactory setCommandWithProperty:@"TimeSettings" value:currentTime] execute:^(id responseObject) {
            } failure:^(int rval) {
        }];
}

- (NSString*)getIphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];

    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    if([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    return platform;
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];

    [self updateUIWithConnectState];
    [self updateUIWithCameraModal];
    
    if (dvr.isConnected) {
        
        [self startLive];
    }
    
    if ([APKDVR sharedInstance].isJoinPlayBackMode) {
        
        [self quitCapturing];
        [APKDVR sharedInstance].isJoinPlayBackMode = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr removeObserver:self forKeyPath:@"isConnected"];
    
    if (dvr.isConnected) {
        
        [self.realTimeViewing stop];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isConnected"]) {
        
        __weak typeof(self) weakSelf = self;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateUIWithConnectState];
            [self updateUIWithCameraModal];

            BOOL isConnected = [change[@"new"] boolValue];
            if (isConnected) {
                [[APKDVRCommandFactory setCommandWithProperty:@"Playback" value:@"exit"] execute:^(id responseObject) {
                    [weakSelf startLive];
                } failure:^(int rval) {
                    
                }];
            }
            else{
                [self.realTimeViewing stop];
                
                if (self.isFullScreenMode)
                    [self clickFullScreenButton:nil];
            }
        });
    }
}

- (void)handleApplicationState:(NSNotification *)notification{
    
    if([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]){
        
        [UIPasteboard generalPasteboard].string = @"";
        
        if ([APKDVR sharedInstance].isConnected) {
            
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [[APKDVRCommandFactory setCommandWithProperty:@"Net" value:@"findme"] execute:^(id responseObject) {
                exit(0);
            } failure:^(int rval) {
                exit(0);
            }];
        }else
            exit(0);
    }
}

#pragma mark - private method
static bool isShowEULA = YES;
-(void)showPromiseView
{
//    APKTabBarController *tabBar = (APKTabBarController *)self.tabBarController;

    self.tabBarController.tabBar.hidden = YES;
    
    NSString *promiseValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"promiseValue"];
    if (![promiseValue isEqualToString:@"yes"]) {
        
        APKPromiseView *view = [[NSBundle mainBundle] loadNibNamed:@"APKPromiseView" owner:nil options:nil].firstObject;
        view.center = self.view.center;
        view.frame = CGRectMake(16, 40, CGRectGetWidth(self.backgroundView.frame)-32, CGRectGetHeight(self.backgroundView.frame)-50);
        view.isEULA = isShowEULA ? YES : NO;
        [view setUpWebView];
        view.wkWebView.frame = CGRectMake(-15,0, self.view.bounds.size.width, CGRectGetHeight(self.backgroundView.frame)-93);
        view.refuseButton.hidden = NO;
        view.sureButton.hidden = NO;
        view.clickActionButton = ^(NSInteger tag) {
            
            if (tag == 100) {
                [self exitApplication];
            }else{
                
                if (!isShowEULA) {
                    self.tabBarController.tabBar.hidden = NO;
                    [self.backgroundView removeFromSuperview];
                }else{
                    isShowEULA = NO;
                    [self showPromiseView];
                }
            }
        };
        [self.backgroundView addSubview:view];
    }else
        self.tabBarController.tabBar.hidden = NO;
//        tabBar.customTabBar.hidden = NO;
}

- (void)exitApplication {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}


- (void)updateUIWithConnectState{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    self.playerView.hidden = !dvr.isConnected;
    self.fullScreenButton.hidden = !dvr.isConnected;
    self.disconnectView.hidden = dvr.isConnected;
        
    if (!dvr.isConnected) {
        
        self.isRecording = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    self.disConnectedLable.hidden = dvr.isConnected == NO ? NO : YES;
    [self showPromiseView];

}

- (void)updateUIWithCameraModal{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (dvr.modal == kAPKDVRModalAosibi) {
        self.captureButton.hidden = NO;
        self.xiongfengComponentsView.hidden = YES;
    }
    else if (dvr.modal == kAPKDVRModalXiongFeng){
        self.captureButton.hidden = YES;
        self.xiongfengComponentsView.hidden = NO;
    }
}

- (void)capturePhoto{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (!dvr.isConnected) {
        //        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {
        //        }];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[APKDVRCommandFactory captureCommand] execute:^(id responseObject) {
        
        [hud hideAnimated:NO];
        
//        UIView *aView = self.isFullScreenMode ? self.realTimeViewing.view : self.view;
//        MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:aView animated:YES];
//        textHUD.mode = MBProgressHUDModeText;
//        textHUD.label.text = NSLocalizedString(@"设备拍照成功！", nil);
//        textHUD.userInteractionEnabled = NO;
//        [textHUD hideAnimated:YES afterDelay:1.f];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:NO];
        
        UIView *aView = self.isFullScreenMode ? self.realTimeViewing.view : self.view;
        MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:aView animated:YES];
        textHUD.mode = MBProgressHUDModeText;
        textHUD.label.text = NSLocalizedString(@"设备拍照失败！", nil);
        textHUD.userInteractionEnabled = NO;
        [textHUD hideAnimated:YES afterDelay:1.f];
    }];
}

- (void)setupFrames{
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat topLayoutGuide = statusBarHeight + navigationBarHeight;
    CGFloat bottomLayoutGuide = self.tabBarController.tabBar.frame.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat height = screenWidth / 16.f * 9.f;
    self.playerViewFrame1 = CGRectMake(0, CGRectGetMinY(self.playerView.frame), screenWidth, height);
    
    CGFloat X = screenWidth / 2.f - screenHeight / 2.f;
    CGFloat Y = screenHeight / 2.f - screenWidth / 2.f;
    self.playerViewFrame2 = CGRectMake(X, Y, screenHeight, screenWidth);
    
    CGFloat border = 20;
    CGFloat width = 50;
    height = 50;
    X = screenWidth - width - border;
    Y = CGRectGetMaxY(self.playerViewFrame1) - height - border;
    self.fullScreenButtonFrame1 = CGRectMake(X, Y, width, height);
    
    Y = border;
    self.fullScreenButtonFrame2 = CGRectMake(X - 20, screenHeight - 100, width, height);
    
    
    width = 100;
    height = 100;
    X = screenWidth / 2.f - width / 2.f;
    CGFloat captureButtonBGHeight = screenHeight - CGRectGetMaxY(self.playerViewFrame1) - bottomLayoutGuide;
    CGFloat captureButtonTopBorder = (captureButtonBGHeight - width) / 2;
    Y = CGRectGetMaxY(self.playerViewFrame1) + captureButtonTopBorder;
    self.captureButtonFrame1 = CGRectMake(X, Y, width, height);
    
    Y = screenHeight - height - border;
    self.captureButtonFrame2 = CGRectMake(X, Y, width, height);
    
    width = screenWidth - border * 2;
    height = 72;
    X =  border;
    Y = CGRectGetMaxY(self.playerViewFrame1) + (captureButtonBGHeight - height) / 2;
    self.xiongfengComponentsViewFrame1 = CGRectMake(X, Y, width, height);
    
    Y = screenHeight - height - border;
    self.xiongfengComponentsViewFrame2 = CGRectMake(X, Y, width, height);

    
    width = width / 3;
    X = width * 0;
    Y = 0;
    self.captureButton2Frame1 = CGRectMake(X, Y, width, height);
    
    X = width * 1;
    self.videocamButtonFrame1 = CGRectMake(X, Y, width, height);

    X = width * 2;
    self.lockButtonFrame1 = CGRectMake(X, Y, width, height);
    
    X = (width - height) / 2;
    Y = height / 2 - width / 2;
    self.captureButton2Frame2 = CGRectMake(X, Y, height, width);
    
    X = CGRectGetWidth(self.xiongfengComponentsViewFrame1) / 2 - height / 2;
    Y = height / 2 - width / 2;
    self.videocamButtonFrame2 = CGRectMake(X, Y, height, width);
    
    X = CGRectGetWidth(self.xiongfengComponentsViewFrame1) - height - (width - height) / 2;
    Y = height / 2 - width / 2;
    self.lockButtonFrame2 = CGRectMake(X, Y, height, width);
}

- (void)startLive{
    
    if (self.isGettingRTSPUrl)
        return;
    
    self.isGettingRTSPUrl = YES;
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory getLiveUrlCommand] execute:^(id responseObject) {
        
        weakSelf.isGettingRTSPUrl = NO;
//        if (weakSelf.tabBarController.selectedViewController != weakSelf.navigationController)
//            return;
        
        BOOL isRecording = [[responseObject objectForKey:@"isRecording"] boolValue];
        weakSelf.isRecording = isRecording;
        
        NSURL *url = [responseObject objectForKey:@"rtspUrl"];
        weakSelf.realTimeViewing.url = url;
        [weakSelf.realTimeViewing play];
        
    } failure:^(int rval) {
        
        weakSelf.isGettingRTSPUrl = NO;
    }];
}

#pragma mark - event response

- (IBAction)clickLockButton:(UIButton *)sender {
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (!dvr.isConnected)
        return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[APKDVRCommandFactory setCommandWithProperty:@"VideoLock" value:@"Lock"] execute:^(id responseObject) {
        
        [hud hideAnimated:YES];
        
        self.lockButton.hidden = YES;
        [self.lockRemainingTimeRecorder launchWithUpdateRemainingTimeHandler:^(int remainingTime) {
        
            if (remainingTime < 0) {
                
                self.lockRemainingTimeLabel.text = nil;
                self.lockButton.hidden = NO;
                
                self.lockRemainingTimeRecorder = nil;
            }
            else{
                
                self.lockRemainingTimeLabel.text = [NSString stringWithFormat:@"%ds",remainingTime];
            }
        }];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
    }];
}

- (IBAction)clickVideocamButton:(UIButton *)sender {
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (!dvr.isConnected)
        return;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[APKDVRCommandFactory setCommandWithProperty:@"Video" value:@"record"] execute:^(id responseObject) {
        
        self.isRecording = !self.isRecording;
        [hud hideAnimated:YES];
        
        //如果在锁定的过程中停止录像，锁定也会中断
        if (!self.isRecording && _lockRemainingTimeRecorder)
            [_lockRemainingTimeRecorder interrupt];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
    }];
}

- (IBAction)clickCaptureButton2:(UIButton *)sender {
    
    [self capturePhoto];
}

- (IBAction)clickFullScreenButton:(UIButton *)sender {
    
    if (self.isFullScreenMode) {
        
        self.titleView.hidden = NO;
        
        self.isFullScreenMode = !self.isFullScreenMode;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playerView.transform = CGAffineTransformIdentity;
            self.fullScreenButton.transform = CGAffineTransformIdentity;
//            self.captureButton.transform = CGAffineTransformIdentity;
            self.captureButton2.transform = CGAffineTransformIdentity;
            self.videocamButton.transform = CGAffineTransformIdentity;
            self.lockButton.transform = CGAffineTransformIdentity;
            self.lockRemainingTimeLabel.transform = CGAffineTransformIdentity;

            self.playerView.frame = self.playerViewFrame1;
            self.fullScreenButton.frame = self.fullScreenButtonFrame1;
            [self.view bringSubviewToFront:self.fullScreenButton];
//            self.captureButton.frame = self.captureButtonFrame1;
            self.xiongfengComponentsView.frame = self.xiongfengComponentsViewFrame1;
            self.captureButton2.frame = self.captureButton2Frame1;
            self.videocamButton.frame = self.videocamButtonFrame1;
            self.lockButton.frame = self.lockButtonFrame1;
            self.lockRemainingTimeLabel.frame = self.lockButtonFrame1;
            
        }];
    }
    else{
        
        self.titleView.hidden = YES;
        
        self.isFullScreenMode = !self.isFullScreenMode;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"quit_fullScreen"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playerView.frame = self.playerViewFrame2;
            self.fullScreenButton.frame = self.fullScreenButtonFrame2;
//            self.captureButton.frame = self.captureButtonFrame2;
            self.xiongfengComponentsView.frame = self.xiongfengComponentsViewFrame2;
            self.captureButton2.frame = self.captureButton2Frame2;
            self.videocamButton.frame = self.videocamButtonFrame2;
            self.lockButton.frame = self.lockButtonFrame2;
            self.lockRemainingTimeLabel.frame = self.lockButtonFrame2;
            
            self.playerView.transform = CGAffineTransformRotate(self.playerView.transform, M_PI_2);
            self.fullScreenButton.transform = CGAffineTransformRotate(self.fullScreenButton.transform, M_PI_2);
//            self.captureButton.transform = CGAffineTransformRotate(self.captureButton.transform, M_PI_2);
//            self.captureButton2.transform = CGAffineTransformRotate(self.captureButton2.transform, M_PI_2);
            self.videocamButton.transform = CGAffineTransformRotate(self.videocamButton.transform, M_PI_2);
            self.lockButton.transform = CGAffineTransformRotate(self.lockButton.transform, M_PI_2);
            self.lockRemainingTimeLabel.transform = CGAffineTransformRotate(self.lockRemainingTimeLabel.transform, M_PI_2);
        }];
        
        [self prefersStatusBarHidden];
    }
}

- (IBAction)clickCaptureButton:(UIButton *)sender {
    
    [self capturePhoto];
}

- (IBAction)clickEventButton:(UIButton *)sender {
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (!dvr.isConnected)
        return;

//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.eventBtn = sender;
    sender.enabled = NO;
    [[APKDVRCommandFactory setCommandWithProperty:@"Video" value:@"rec_emer"] execute:^(id responseObject) {
        
        self.startEventBtn.hidden = YES;
        self.captureHUD = [MBProgressHUD showHUDAddedTo:sender.superview animated:YES];
        self.captureHUD.detailsLabel.text = NSLocalizedString(@"正在录制事件...", nil);
        self.captureHUD.mode = MBProgressHUDModeAnnularDeterminate;
        
        self.captureWaitingTime = 0;
        self.captureTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(captureTimerMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.captureTimer forMode:NSRunLoopCommonModes];
        
    } failure:^(int rval) {
        
        sender.enabled = YES;
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"拍摄事件失败", nil) confirmHandler:nil];
//        [hud hideAnimated:YES];
    }];
}

- (void)quitCapturing{
    
    [self.captureTimer invalidate];
    self.captureTimer = nil;
    
//    [self.captureHUD hideAnimated:YES];
    [self.captureHUD setHidden:YES];
    self.startEventBtn.hidden = NO;
    self.eventBtn.enabled = YES;
}

- (void)captureTimerMethod:(NSTimer *)timer{
    
    self.captureWaitingTime++;
    int captureLockTime = 32;
    CGFloat progress = self.captureWaitingTime / captureLockTime;
    self.captureHUD.progress = progress;
    if (progress == 1)
        [self quitCapturing];
}


#pragma mark - setter


- (void)setIsRecording:(BOOL)isRecording{
    
    _isRecording = isRecording;
    
    NSString *imageName = isRecording ? @"videocam" : @"videocam_off";
    [self.videocamButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    self.lockButton.enabled = isRecording;
}

#pragma mark - getter

- (APKLockRemainingTimeRecorder *)lockRemainingTimeRecorder{
    
    if (!_lockRemainingTimeRecorder) {
        
        _lockRemainingTimeRecorder = [[APKLockRemainingTimeRecorder alloc] init];
    }
    return _lockRemainingTimeRecorder;
}

- (APKRealTimeViewingController *)realTimeViewing{
    
    if (!_realTimeViewing) {
        
        for (id obj in self.childViewControllers) {
            if ([obj isKindOfClass:[APKRealTimeViewingController class]]) {
                _realTimeViewing = obj;
                break;
            }
        }
    }
    return _realTimeViewing;
}

-(UILabel *)disConnectedLable
{
    if (!_disConnectedLable) {
        _disConnectedLable = [[UILabel alloc] initWithFrame:self.view.bounds];
        _disConnectedLable.backgroundColor = [UIColor whiteColor];
        _disConnectedLable.textAlignment = NSTextAlignmentCenter;
        _disConnectedLable.text = NSLocalizedString(@"未连接", nil);
        _disConnectedLable.hidden = YES;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y + 100, 100, 40)];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:NSLocalizedString(@"重新连接", nil) forState:UIControlStateNormal];
        NSString *content = btn.titleLabel.text;
        UIFont *font = btn.titleLabel.font;
        CGSize size = CGSizeMake(MAXFLOAT, 40);
        CGSize buttonSize = [content boundingRectWithSize:size
                                                  options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{ NSFontAttributeName:font}
                                                  context:nil].size;
        btn.frame = CGRectMake(self.view.center.x - buttonSize.width/2 - 10, self.view.center.y + 100,buttonSize.width + 20, 40);
        [btn addTarget:self action:@selector(clickReconnectBtn) forControlEvents:UIControlEventTouchUpInside];
//        self.disConnectedBtn = btn;
        [self.view addSubview:_disConnectedLable];
        
        NSString *isDark = [[NSUserDefaults standardUserDefaults] objectForKey:@"DARKMODE"];
        if ([isDark isEqualToString:@"YES"]) {
            _disConnectedLable.backgroundColor = [UIColor blackColor];
            _disConnectedLable.textColor = [UIColor whiteColor];
        }
//        [self.view addSubview:btn];
        
    }
    return _disConnectedLable;
}

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.tabBarController.viewControllers.firstObject.view.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.userInteractionEnabled = YES;
        [self.tabBarController.viewControllers.firstObject.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

@end
