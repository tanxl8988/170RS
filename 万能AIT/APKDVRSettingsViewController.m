//
//  APKDVRSettingsViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRSettingsViewController.h"
#import "APKDVR.h"
#import "MBProgressHUD.h"
#import "APKNetworkConfigureViewController.h"
#import "APKAlertTool.h"
#import "APKDVRSettingInfo.h"
#import "APKDVRCommandFactory.h"
#import "APKAboatViewController.h"
#import "APKPromiseView.h"

#define WIFI_NAME_TEXT_FIELD 1000
#define WIFI_PASSWORD_TEXT_FIELD 1001

@interface APKDVRSettingsViewController ()<UITextFieldDelegate>

//cells
@property (weak, nonatomic) IBOutlet UITableViewCell *recordSoundCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *motionDetectionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *clipDurationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *gSensorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *LCDLightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *watermarkCell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateFormatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *exposureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *correctCameraClockCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *formatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *networkConfigureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *factoryResetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *appVersionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *softwareCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wifiPasswordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *SSIDCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *EULACell;
@property (weak, nonatomic) IBOutlet UITableViewCell *openSourceViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *APKPrivacyPolicyCell;

//雄风
@property (weak, nonatomic) IBOutlet UITableViewCell *upsidedownCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *videoModeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *watermarkCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateFormatCell2;


@property (weak, nonatomic) IBOutlet UILabel *networkConfigureLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctCameraClockLabel;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (weak, nonatomic) IBOutlet UILabel *micLabel;
@property (weak, nonatomic) IBOutlet UILabel *clipDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *gSensorLabel;
@property (weak, nonatomic) IBOutlet UILabel *factoryResetLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionL;
@property (weak, nonatomic) IBOutlet UILabel *appVersionValueL;
@property (weak, nonatomic) IBOutlet UILabel *softwareL;
@property (weak, nonatomic) IBOutlet UILabel *softwareValueL;
@property (weak, nonatomic) IBOutlet UILabel *wifiPasswordL;
@property (weak, nonatomic) IBOutlet UILabel *ssidL;
@property (weak, nonatomic) IBOutlet UILabel *wifiPasswordValueL;
@property (weak, nonatomic) IBOutlet UILabel *ssidValueL;
@property (weak, nonatomic) IBOutlet UILabel *openSourceL;
@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyL;

@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *clipDurationSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gSensorSegment;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboatLabel;
@property (weak, nonatomic) IBOutlet UILabel *motionDetectionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *motionDetectionSwitch;
@property (weak, nonatomic) IBOutlet UILabel *LCDLightLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LCDLightSegment;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *watermarkSegment;
@property (weak, nonatomic) IBOutlet UILabel *dateFormatLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateFormatSegment;
@property (weak, nonatomic) IBOutlet UILabel *EVLabel;
@property (weak, nonatomic) IBOutlet UILabel *EVValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *EVSlider;
//雄风
@property (weak, nonatomic) IBOutlet UILabel *upsidedownLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateFormatLabel2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateFormatSegment2;

@property (weak, nonatomic) IBOutlet UISwitch *upsidedownSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoModeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *watermarkSegment2;


@property (weak,nonatomic) UIAlertController *correctCameraClockAlert;
@property (nonatomic) BOOL isSettable;
@property (strong,nonatomic) NSString *currentTime;
@property (strong,nonatomic) NSArray *cells;
@property (strong,nonatomic) NSArray *rowHeights;
@property (assign,nonatomic) APKDVRModal dvrModal;
@property (weak,nonatomic) UITextField *wifiInfoTextField;
@property (weak,nonatomic) UIAlertAction *confirmButton;
@property (nonatomic,retain) UIView *maskView;

@end

@implementation APKDVRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"设置", nil);
    
    self.networkConfigureLabel.text = NSLocalizedString(@"wifi设置", nil);
    self.correctCameraClockLabel.text = NSLocalizedString(@"校准时间", nil);
    self.formatLabel.text = NSLocalizedString(@"格式化TF卡", nil);
    self.micLabel.text = NSLocalizedString(@"录音设置", nil);
    self.clipDurationLabel.text = NSLocalizedString(@"录制时长", nil);
    self.gSensorLabel.text = NSLocalizedString(@"碰撞灵敏度", nil);
    self.factoryResetLabel.text = NSLocalizedString(@"恢复出厂设置", nil);
    self.helpLabel.text = NSLocalizedString(@"开放源代码许可", nil);
    self.openSourceL.text = NSLocalizedString(@"开放源代码许可", nil);
    self.aboatLabel.text = NSLocalizedString(@"说明书", nil);
    self.EVLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"曝光调整", nil)];
    self.EVValueLabel.text = @"0";
    self.LCDLightLabel.text = NSLocalizedString(@"自动关屏", nil);
    self.watermarkLabel.text = NSLocalizedString(@"视频格式", nil);
    self.dateFormatLabel.text = NSLocalizedString(@"日期格式", nil);
    self.motionDetectionLabel.text = NSLocalizedString(@"移动侦测", nil);
    //雄风
    self.upsidedownLabel.text = NSLocalizedString(@"翻转", nil);
    self.videoModeLabel.text = NSLocalizedString(@"视频模式", nil);
    self.watermarkLabel2.text = NSLocalizedString(@"戳记", nil);
    self.dateFormatLabel2.text = NSLocalizedString(@"日期格式", nil);
    self.appVersionL.text = NSLocalizedString(@"版本号", nil);
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *appVersionStr = [NSString stringWithFormat:@"V %@",appVersion];
    self.appVersionValueL.text = appVersionStr;
    self.softwareL.text = NSLocalizedString(@"软件信息", nil);
    self.softwareValueL.text = [APKDVR sharedInstance].settingInfo.FWVersion;
    self.ssidL.text = NSLocalizedString(@"SSID", nil);
    self.wifiPasswordL.text = NSLocalizedString(@"WiFi密码",nil);
    self.privacyPolicyL.text = NSLocalizedString(@"隐私政策", nil);


    [self.clipDurationSegment setTitle:NSLocalizedString(@"1分钟", nil) forSegmentAtIndex:0];
    [self.clipDurationSegment setTitle:NSLocalizedString(@"3分钟", nil) forSegmentAtIndex:1];
    [self.clipDurationSegment setTitle:NSLocalizedString(@"5分钟", nil) forSegmentAtIndex:2];
    [self.gSensorSegment setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:0];
    [self.gSensorSegment setTitle:NSLocalizedString(@"高", nil) forSegmentAtIndex:1];
    [self.gSensorSegment setTitle:NSLocalizedString(@"中", nil) forSegmentAtIndex:2];
    [self.gSensorSegment setTitle:NSLocalizedString(@"低", nil) forSegmentAtIndex:3];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:0];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"10秒", nil) forSegmentAtIndex:1];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"1分钟", nil) forSegmentAtIndex:2];
    [self.LCDLightSegment setTitle:NSLocalizedString(@"3分钟", nil) forSegmentAtIndex:3];
//    [self.watermarkSegment setTitle:NSLocalizedString(@"日期+型号", nil) forSegmentAtIndex:0];
    [self.watermarkSegment setTitle:NSLocalizedString(@"1080 p", nil) forSegmentAtIndex:0];
    [self.watermarkSegment setTitle:NSLocalizedString(@"720 p", nil) forSegmentAtIndex:1];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"无", nil) forSegmentAtIndex:0];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"年月日", nil) forSegmentAtIndex:1];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"月日年", nil) forSegmentAtIndex:2];
    [self.dateFormatSegment setTitle:NSLocalizedString(@"日月年", nil) forSegmentAtIndex:3];

    self.clipDurationSegment.layer.borderColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1].CGColor;
    self.clipDurationSegment.layer.borderWidth = 0.5;
    
    self.gSensorSegment.layer.borderColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1].CGColor;
    self.gSensorSegment.layer.borderWidth = 0.5;

    self.LCDLightSegment.layer.borderColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1].CGColor;
    self.LCDLightSegment.layer.borderWidth = 0.5;


    self.watermarkSegment.layer.borderColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1].CGColor;
    self.watermarkSegment.layer.borderWidth = 0.5;


    self.dateFormatSegment.layer.borderColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1].CGColor;
    self.dateFormatSegment.layer.borderWidth = 0.5;



    //雄风
    UIFont *font = [UIFont boldSystemFontOfSize:7.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.videoModeSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.videoModeSegment setTitle:@"2560*1440 30fps" forSegmentAtIndex:0];
    [self.videoModeSegment setTitle:@"1920*1080 60fps" forSegmentAtIndex:1];
    [self.videoModeSegment setTitle:@"1920*1080 30fps" forSegmentAtIndex:2];
    [self.videoModeSegment setTitle:@"1280*720 60fps" forSegmentAtIndex:3];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"日期+型号", nil) forSegmentAtIndex:0];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"日期", nil) forSegmentAtIndex:1];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"型号", nil) forSegmentAtIndex:2];
    [self.watermarkSegment2 setTitle:NSLocalizedString(@"关闭", nil) forSegmentAtIndex:3];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"年月日", nil) forSegmentAtIndex:0];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"月日年", nil) forSegmentAtIndex:1];
    [self.dateFormatSegment2 setTitle:NSLocalizedString(@"日月年", nil) forSegmentAtIndex:2];
    
    APKDVR *dvr = [APKDVR sharedInstance];
    dvr.appIsInSettingVC = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutWIFI:) name:UITextFieldTextDidChangeNotification object:nil];

    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];

    [self updateUIWithDVRModal];
    [self updateUIWithSettingInfo];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    APKDVR *dvr = [APKDVR sharedInstance];
    [dvr removeObserver:self forKeyPath:@"isConnected"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isConnected"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateUIWithDVRModal];
            [self updateUIWithSettingInfo];
        });
    }
}

- (void)checkoutWIFI:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:UITextFieldTextDidChangeNotification]) {
        
        if (self.wifiInfoTextField.tag == WIFI_NAME_TEXT_FIELD) {
            
            if (self.wifiInfoTextField.text.length == 0 || [self.wifiInfoTextField.text isEqualToString:self.ssidValueL.text] || self.wifiInfoTextField.text.length > 11) {
                
                self.confirmButton.enabled = NO;
            }
            else{
                
                self.confirmButton.enabled = YES;
            }
        }
        else if (self.wifiInfoTextField.tag == WIFI_PASSWORD_TEXT_FIELD){
            
            if (self.wifiInfoTextField.text.length != 8 || [self.wifiInfoTextField.text isEqualToString:self.wifiPasswordValueL.text]) {
                
                self.confirmButton.enabled = NO;
            }
            else{
                
                self.confirmButton.enabled = YES;
            }
        }
    }
}

#pragma mark - private method

- (void)updateUIWithDVRModal{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    if (self.dvrModal == dvr.modal) {
        return;
    }
    self.dvrModal = dvr.modal;
    
    if (self.dvrModal == kAPKDVRModalAosibi) {
        self.cells = @[self.recordSoundCell,self.motionDetectionCell,self.clipDurationCell,self.gSensorCell,self.LCDLightCell,self.watermarkCell1,self.dateFormatCell,self.exposureCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell];
        self.rowHeights = @[@(62),@(62),@(98),@(98),@(98),@(98),@(98),@(100),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    else if (self.dvrModal == kAPKDVRModalXiongFeng){
        self.cells = @[self.recordSoundCell,self.upsidedownCell,self.motionDetectionCell,self.videoModeCell,self.clipDurationCell,self.gSensorCell,self.LCDLightCell,self.watermarkCell2,self.dateFormatCell2,self.exposureCell,self.correctCameraClockCell,self.formatCell,self.networkConfigureCell,self.factoryResetCell,self.helpCell,self.aboatCell];
        self.rowHeights = @[@(62),@(62),@(62),@(98),@(98),@(98),@(98),@(98),@(98),@(100),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    
    [self.tableView reloadData];
}

- (void)updateUIWithSettingInfo{
    
    APKDVR *dvr = [APKDVR sharedInstance];
    APKDVRSettingInfo *settingInfo = dvr.settingInfo;
    if (settingInfo) {
        
        self.micSwitch.on = settingInfo.recordSound;
        self.clipDurationSegment.selectedSegmentIndex = settingInfo.VideoClipTime;
        self.gSensorSegment.selectedSegmentIndex = settingInfo.GSensor;
        self.EVValueLabel.text = [self exposureValueWithSettingInfoValue:settingInfo.exposure];
        self.EVSlider.value = [self exposureSliderValueWithSettingInfoValue:settingInfo.exposure];
        self.motionDetectionSwitch.on = settingInfo.motionDetection;
        self.LCDLightSegment.selectedSegmentIndex = settingInfo.LCDPowerSave;
        self.dateFormatSegment.selectedSegmentIndex = settingInfo.dateFormat;
        self.watermarkSegment.selectedSegmentIndex = settingInfo.watermark;
        if (self.dvrModal == kAPKDVRModalAosibi) {
            self.watermarkSegment.selectedSegmentIndex = settingInfo.watermark;
            self.dateFormatSegment.selectedSegmentIndex = settingInfo.dateFormat;
        }
        else{
            self.watermarkSegment2.selectedSegmentIndex = settingInfo.watermark;
            self.dateFormatSegment2.selectedSegmentIndex = settingInfo.dateFormat;
        }
        //雄风
        self.upsidedownSwitch.on = settingInfo.upsidedown;
        self.videoModeSegment.selectedSegmentIndex = settingInfo.videoRes;
        
        [self getWifiInfo];
    }
    else{
        
        self.micSwitch.on = NO;
        self.clipDurationSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.gSensorSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.EVValueLabel.text = [self exposureValueWithSettingInfoValue:0];
        self.EVSlider.value = [self exposureSliderValueWithSettingInfoValue:0];
        self.motionDetectionSwitch.on = NO;
        self.LCDLightSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.dateFormatSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.watermarkSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        //雄风
        self.upsidedownSwitch.on = NO;
        self.videoModeSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.watermarkSegment2.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.dateFormatSegment2.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
}

-(void)getWifiInfo
{
    __weak typeof(self) weakSelf = self;
    [[APKDVRCommandFactory getWifiInfoCommand] execute:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *info = responseObject;
            weakSelf.ssidValueL.text = info.allKeys.firstObject;
            weakSelf.wifiPasswordValueL.text = info.allValues.firstObject;
        });
        
    } failure:^(int rval) {
    }];
}

- (void)updateUIWithTimer:(NSTimer *)timer{
    
    if (self.correctCameraClockAlert) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.correctCameraClockAlert.message = self.currentTime;
        });
        
    }else{
        
        [timer invalidate];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = self.cells[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.helpCell || cell == self.aboatCell || cell == self.openSourceViewCell) {
        
        return;
    }
    
    if (![APKDVR sharedInstance].isConnected && cell != self.EULACell && cell != self.APKPrivacyPolicyCell) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {}];
        return;
    }
    
    if (cell == self.networkConfigureCell) {
        
        [self performSegueWithIdentifier:@"networkConfigure" sender:nil];
    
    }else if(cell == self.correctCameraClockCell){
        
        NSString *title = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"校准时间", nil)];//NSLocalizedString(@"摄像机时间将会校准为：", nil)
        self.correctCameraClockAlert = [APKAlertTool showAlertInViewController:self title:title message:self.currentTime cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
            __weak typeof(self) weakSelf = self;
            NSDate *date = [NSDate date];
//            NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
//
//            NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
//
//            NSDate *dateNow = [date dateByAddingTimeInterval:time];//
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
            NSString *currentTime = [dateFormatter stringFromDate:date];
            [[APKDVRCommandFactory setCommandWithProperty:@"TimeSettings" value:currentTime] execute:^(id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"校准时间成功！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
                
            } failure:^(int rval) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"校准时间失败！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                    
                });
            }];
        }];

        [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateUIWithTimer:) userInfo:nil repeats:YES];
        
    }else if (cell == self.formatCell){
        
        NSString *message = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"格式化TF卡", nil)];
        [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
            __weak typeof(self) weakSelf = self;
            [[APKDVRCommandFactory setCommandWithProperty:@"SD0" value:@"format"] execute:^(id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"格式化TF卡成功！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
                
            } failure:^(int rval) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"格式化TF卡失败！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
            }];
        }];
        
    }else if (cell == self.factoryResetCell){
        
        NSString *message = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"恢复出厂设置详情", nil)];
        [APKAlertTool showAlertInViewController:self title:nil message:message cancelHandler:nil confirmHandler:^(UIAlertAction *action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
            
            NSString *property = @"FactoryReset",*value = @"Camera";
            if ([APKDVR sharedInstance].modal == kAPKDVRModalXiongFeng)
                property = @"ResetSetup",value = @"YES";
            __weak typeof(self) weakSelf = self;
            [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKDVR sharedInstance].isConnected = NO;
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"恢复出厂设置成功！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
                
            } failure:^(int rval) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"恢复出厂设置失败！", nil) confirmHandler:nil];
                    [hud hideAnimated:YES];
                });
            }];
        }];
    }else if (cell == self.SSIDCell){
        [self showModifyWifiAccountAlert];
    }else if (cell == self.wifiPasswordCell){
        [self showModifyWifiPasswordAlert];
    }else if (cell == _EULACell){
        
        [self showThePolicyView:YES];
    }else if (cell == self.APKPrivacyPolicyCell){
        [self showThePolicyView:NO];
    }
}

-(void)showThePolicyView:(BOOL)isEULA
{
    __weak APKPromiseView *view = [[NSBundle mainBundle] loadNibNamed:@"APKPromiseView" owner:nil options:nil].firstObject;
    view.center = self.view.center;
    view.setSureButton.hidden = NO;
    view.isEULA = isEULA;
    view.frame = CGRectMake(20, 30, CGRectGetWidth(self.maskView.frame)-40, CGRectGetHeight(self.maskView.frame)-60);
    [view setUpWebView];
    view.clickActionButton = ^(NSInteger tag) {
        
        [self.maskView removeFromSuperview];
        [view removeFromSuperview];
    };
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    view.wkWebView.frame = CGRectMake(-15, 0, self.view.bounds.size.width, CGRectGetHeight(self.maskView.frame)-103);

    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:view];
}

- (void)showModifyWifiPasswordAlert{
    
    if (!self.isSettable) return;

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *account = self.ssidValueL.text;
        NSString *password = self.wifiInfoTextField.text;
        [self modifyWifiWithAccount:account password:password];
    }];
    confirm.enabled = NO;
    self.confirmButton = confirm;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"WiFi密码", nil) message:NSLocalizedString(@"请输入8位Wi-Fi密码：", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.text = self.wifiPasswordValueL.text;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.tag = WIFI_PASSWORD_TEXT_FIELD;
        self.wifiInfoTextField = textField;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showModifyWifiAccountAlert{
    
    if (!self.isSettable) return;
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *account = self.wifiInfoTextField.text;
        NSString *password = self.wifiPasswordValueL.text;
        [self modifyWifiWithAccount:account password:password];
    }];
    confirm.enabled = NO;
    self.confirmButton = confirm;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"WiFi名称", nil) message:NSLocalizedString(@"请输入1-11位Wi-Fi名称：", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.text = self.ssidValueL.text;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.tag = WIFI_NAME_TEXT_FIELD;
        self.wifiInfoTextField = textField;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)modifyWifiWithAccount:(NSString *)account password:(NSString *)password{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
    
    [self.view endEditing:YES];

    NSString *wifiName = [account stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    __weak typeof(self) weakSelf = self;
    [[APKDVRCommandFactory modifyWifiCommandWithAccount:wifiName password:password] execute:^(id responseObject) {
        
        [[APKDVRCommandFactory rebotWifiCommand] execute:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                [APKAlertTool showAlertInViewController:weakSelf title:NSLocalizedString(@"修改成功！", nil) message:NSLocalizedString(@"DVR将会重启Wi-Fi", nil) confirmHandler:^(UIAlertAction *action) {
                    [APKDVR sharedInstance].isConnected = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        } failure:^(int rval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                [APKAlertTool showAlertInViewController:weakSelf title:NSLocalizedString(@"修改成功！", nil) message:NSLocalizedString(@"DVR将会重启Wi-Fi", nil) confirmHandler:^(UIAlertAction *action) {
                    [APKDVR sharedInstance].isConnected = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
        }];
        
    } failure:^(int rval) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"修改失败！", nil) confirmHandler:nil];
            [hud hideAnimated:YES];
        });
    }];
}

#pragma mark - event response

- (IBAction)finishUpdateEVSlider:(UISlider *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSDictionary *info = [self exposureInfoWithSliderValue:sender.value];
    NSString *value = info.allValues.firstObject;
    NSString *property = @"EV";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.exposure = [[APKDVR sharedInstance].settingInfo.exposureMap indexOfObject:value];
        
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            weakSelf.EVSlider.value = [weakSelf exposureSliderValueWithSettingInfoValue:[APKDVR sharedInstance].settingInfo.exposure];
            weakSelf.EVValueLabel.text = [weakSelf exposureValueWithSettingInfoValue:[APKDVR sharedInstance].settingInfo.exposure];
        }];
    }];
}

- (IBAction)updateEVSlider:(UISlider *)sender {
    
    NSDictionary *info = [self exposureInfoWithSliderValue:sender.value];
    self.EVValueLabel.text = info.allKeys.firstObject;
}

- (IBAction)updateDateFormatSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.dateFormatMap[sender.selectedSegmentIndex];
    NSString *property = @"TimeFormat";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.dateFormat = sender.selectedSegmentIndex;
        
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.dateFormat;
        }];
    }];
}

- (IBAction)updateWatermarkSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.watermarkMap[sender.selectedSegmentIndex];
    NSString *property = @"Videores";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.watermark = sender.selectedSegmentIndex;
        
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.watermark;
        }];
    }];
}

- (IBAction)updateLCDLightSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.LCDPowerSaveMap[sender.selectedSegmentIndex];
    NSString *property = @"LCDPowerSave";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.LCDPowerSave = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.LCDPowerSave;
        }];
    }];
}

- (IBAction)toggleMotionDetectionSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.motionDetectionMap[sender.isOn];
    NSString *property = @"MTD";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.motionDetection = sender.isOn;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.on = !sender.isOn;
        }];
    }];
}

- (IBAction)updateGSensorSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.GSensorMap[sender.selectedSegmentIndex];
    NSString *property = @"GSensor";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.GSensor = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.GSensor;
        }];
    }];
}

- (IBAction)updateClipDurationSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.VideoClipTimeMap[sender.selectedSegmentIndex];
    NSString *property = @"VideoClipTime";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.VideoClipTime = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.VideoClipTime;
        }];
    }];
}

- (IBAction)toggleMicSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
    
    APKDVRModal dvrModal = [APKDVR sharedInstance].modal;
    NSString *property;
    NSString *value;
    if (dvrModal == kAPKDVRModalAosibi) {
        property = @"Video";
        value = sender.isOn ? @"unmute" : @"mute";
    }
    else{
        property = @"SoundRecord";
        value = sender.isOn ? @"OFF" : @"ON";
    }
    
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.recordSound = sender.isOn;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            sender.on = !sender.on;
        }];
    }];
}

#pragma mark 雄风

- (IBAction)toggleUpsidedownSwitch:(UISwitch *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *property = @"UpsideDown";
    NSString *value = sender.isOn ? @"Upsidedown" : @"Normal";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.upsidedown = sender.isOn;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            sender.on = !sender.on;
        }];
    }];
}

- (IBAction)updateVideoModeSegment:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];
    
    NSString *value = [APKDVR sharedInstance].settingInfo.videoResMap[sender.selectedSegmentIndex];
    NSString *property = @"Videores";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.videoRes = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.videoRes;
        }];
    }];
}

- (IBAction)updateWatermarkSegment2:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.watermarkMap2[sender.selectedSegmentIndex];
    NSString *property = @"TimeStamp";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.watermark = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.watermark;
        }];
    }];
}
- (IBAction)updateDateFormatSegment2:(UISegmentedControl *)sender {
    
    if (!self.isSettable) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.viewControllers.lastObject.view animated:YES];

    NSString *value = [APKDVR sharedInstance].settingInfo.dateFormatMap2[sender.selectedSegmentIndex];
    NSString *property = @"TimeFormat";
    __weak typeof(self)weakSelf = self;
    [[APKDVRCommandFactory setCommandWithProperty:property value:value] execute:^(id responseObject) {
        
        [APKDVR sharedInstance].settingInfo.dateFormat = sender.selectedSegmentIndex;
        [hud hideAnimated:YES];
        
    } failure:^(int rval) {
        
        [hud hideAnimated:YES];
        [APKAlertTool showAlertInViewController:weakSelf title:nil message:NSLocalizedString(@"设置失败！", nil) confirmHandler:^(UIAlertAction *action) {
            
            sender.selectedSegmentIndex = [APKDVR sharedInstance].settingInfo.dateFormat;
        }];
    }];
}

#pragma mark - Utilities

- (CGFloat)exposureSliderValueWithSettingInfoValue:(NSInteger)value{
    
    if (value == -1) {
        
        return 0;
    }
    
    CGFloat map[] = {-2,-1.7,-1.3,-1,-0.7,-0.3,0,0.3,0.7,1,1.3,1.7,2};
    CGFloat f = map[value];
    return f;
}

- (NSString *)exposureValueWithSettingInfoValue:(NSInteger)value{
    
    if (value == -1) {
        
        return @"0";
    }
    
    NSArray *map = @[@"-2",@"-1.7",@"-1.3",@"-1",@"-0.7",@"-0.3",@"0",@"0.3",@"0.7",@"1",@"1.3",@"1.7",@"2"];
    NSString *str = map[value];
    return str;
}

- (NSDictionary *)exposureInfoWithSliderValue:(CGFloat)value{
    
    NSString *setValue = nil;
    NSString *displayValue = nil;
    if (value > -0.15 && value < 0.15) {
        
        displayValue = @"0";
        setValue = @"EV0";
        
    }else{
        
        BOOL isPositive = value > 0 ? YES : NO;
        if (!isPositive) value = -value;
        
        if (value >= 0.15 && value < 0.5) {
            
            displayValue = isPositive ? @"0.3" : @"-0.3";
            setValue = isPositive ? @"EVP033" : @"EVN033";
        }
        else if (value >= 0.5 && value < 0.85){
            
            displayValue = isPositive ? @"0.7" : @"-0.7";
            setValue = isPositive ? @"EVP067" : @"EVN067";

        }
        else if (value >= 0.85 && value < 1.15){
            
            displayValue = isPositive ? @"1" : @"-1";
            setValue = isPositive ? @"EVP100" : @"EVN100";

        }
        else if (value >= 1.15 && value < 1.5){
            
            displayValue = isPositive ? @"1.3" : @"-1.3";
            setValue = isPositive ? @"EVP133" : @"EVN133";

        }
        else if (value >= 1.5 && value < 1.85){
            
            displayValue = isPositive ? @"1.7" : @"-1.7";
            setValue = isPositive ? @"EVP167" : @"EVN167";
        }
        else{
        
            displayValue = isPositive ? @"2" : @"-2";
            setValue = isPositive ? @"EVP200" : @"EVN200";
        }
    }
    
    return @{displayValue:setValue};
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"checkAboat"]) {
        
        APKAboatViewController *vc = segue.destinationViewController;
        vc.firmwareVersion = [APKDVR sharedInstance].settingInfo.FWVersion;
    }
}

#pragma mark - getter

- (NSArray *)rowHeights{
    
    if (!_rowHeights) {
        _rowHeights = @[@(98),@(92),@(62),@(62),@(62),@(62),@(62),@(62),@(62),@(62),@(62)];
    }
    return _rowHeights;
}

- (NSArray *)cells{
    
    if (!_cells) {
        
        _cells = @[self.clipDurationCell,self.watermarkCell1,self.SSIDCell,self.wifiPasswordCell,self.factoryResetCell,self.softwareCell,self.aboatCell,self.openSourceViewCell,self.appVersionCell,self.EULACell,self.APKPrivacyPolicyCell];
    }
    return _cells;
}

- (NSString *)currentTime{
    
    //获取手机当前时间
    NSDate *date = [[NSDate alloc] init];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    return currentTime;
}

- (BOOL)isSettable{
    
    BOOL isSettable = YES;
    
    if (![APKDVR sharedInstance].isConnected) {
        
        [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {}];
        
        isSettable = NO;
    }
    
    return isSettable;
}

-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.tabBarController.viewControllers.lastObject.view.frame];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
    }
    return _maskView;
}

@end
