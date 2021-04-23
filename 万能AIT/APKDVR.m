//
//  APKDVR.m
//  AITBrain
//
//  Created by Mac on 17/3/20.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVR.h"
#import "APKWifiTool.h"
#import "APKDVRCommandFactory.h"
#import <UIKit/UIKit.h>

#define LASTDVRMODAL @"lastDVRModal"
@interface APKDVR ()
@property (strong,nonatomic) dispatch_source_t heartBeatTimer;

@end
@implementation APKDVR

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        APKDVRModal modal = [[NSUserDefaults standardUserDefaults] integerForKey:LASTDVRMODAL];
        _modal = modal;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationState:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

+ (instancetype)sharedInstance{
    
    static APKDVR *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APKDVR alloc] init];
    });
    
    return instance;
}

#pragma mark - public method

- (void)tryToUpdateConnectState{
    
    NSString *aitWifiAddress = @"192.72.1.1";
    NSString *wifiAddress = [APKWifiTool getWifiAddress];
//    NSString *aitWifiAddress = @"192.168.2.1";
    BOOL isConnectedDVRWifi = [wifiAddress isEqualToString:aitWifiAddress];
    if (isConnectedDVRWifi && !self.isConnected) {
        
        [[APKDVRCommandFactory getSettingInfoCommand] execute:^(id responseObject) {
            
            self.settingInfo = responseObject;
            NSString *version = self.settingInfo.FWVersion;
            if ([version hasPrefix:@"RR530"]) {
                self.modal = kAPKDVRModalAosibi;
            }
            else if ([version hasPrefix:@"RR535"] || [version isEqualToString:@"1207"]){
                self.modal = kAPKDVRModalXiongFeng;
            }
            else{
                NSLog(@"⚠️连接的不是我们的DVR！");
//                return;
            }
            self.isConnected = YES;
            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [self correctTime];
//            });
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self correctTime];
            });
            
            
            dispatch_resume(self.heartBeatTimer);

        } failure:^(int rval) {
        }];
    }
    else if (!isConnectedDVRWifi && self.isConnected){
        
        self.settingInfo = nil;
        self.isConnected = NO;
        dispatch_suspend(self.heartBeatTimer);

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

#pragma mark - private method

- (void)handleApplicationState:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
            
        [self tryToUpdateConnectState];
        
    }else if([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]){

        if (self.isConnected) {
            
            self.settingInfo = nil;
            self.isConnected = NO;
        }
        
    }
}

#pragma mark - setter

- (void)setModal:(APKDVRModal)modal{
    
    _modal = modal;
    
    [[NSUserDefaults standardUserDefaults] setInteger:modal forKey:LASTDVRMODAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (dispatch_source_t)heartBeatTimer{
    
    if (_heartBeatTimer == nil) {
        
        //5秒定时器发送心跳包
        _heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(_heartBeatTimer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_heartBeatTimer, ^{
            
                [[APKDVRCommandFactory getSettingEVCommand] execute:^(id responseObject) {
                    NSLog(@"");
                } failure:^(int rval) {
                    NSLog(@"");
                }];
        });
    }
    return _heartBeatTimer;
}

@end
