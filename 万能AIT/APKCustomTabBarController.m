//
//  APKCustomTabBarController.m
//  万能AIT
//
//  Created by Mac on 17/4/11.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKCustomTabBarController.h"

@interface APKCustomTabBarController ()

@end

@implementation APKCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *previewItem = self.tabBar.items[0];
    UITabBarItem *albumItem = self.tabBar.items[1];
    UITabBarItem *settingsItem = self.tabBar.items[2];
    previewItem.title = NSLocalizedString(@"", nil);
    albumItem.title = NSLocalizedString(@"", nil);
    settingsItem.title = NSLocalizedString(@"", nil);
    [self.tabBar setTintColor:[UIColor colorWithRed:180.f/255.f green:24.f/255.f blue:62.f/255.f alpha:1]];
    
    if (@available(iOS 12.0, *)) {
        BOOL isDark = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
        if (isDark) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"DARKMODE"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"DARKMODE"];
        }
    } else {
        // Fallback on earlier versions
    }
}


@end
