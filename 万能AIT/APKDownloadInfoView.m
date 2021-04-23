//
//  APKDownloadInfoView.m
//  Innowa
//
//  Created by Mac on 17/4/26.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDownloadInfoView.h"

@interface APKDownloadInfoView ()

@property (copy,nonatomic) void(^cancelHandler)(void);

@end

@implementation APKDownloadInfoView

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.titleLabel.text = NSLocalizedString(@"下载", nil);
    [self.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    
    NSString *isDark = [[NSUserDefaults standardUserDefaults] objectForKey:@"DARKMODE"];
     if ([isDark isEqualToString:@"YES"]) {
         self.titleLabel.textColor = [UIColor blackColor];
         self.downloadInfoLabel.textColor = [UIColor blackColor];
         self.progressLabel.textColor = [UIColor blackColor];
         self.progressLabel2.textColor = [UIColor blackColor];
     }
}

- (IBAction)clickCancelButton:(UIButton *)sender {
    
    if (self.cancelHandler) {
        
        self.cancelHandler();
    }
}

#pragma mark - public method

- (void)dismiss{
    
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view cancelHandler:(void (^)(void))cancelHandler{
    
    self.cancelHandler = cancelHandler;
    self.frame = view.bounds;
    [view.window addSubview:self];
}


@end
