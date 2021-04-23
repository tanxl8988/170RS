//
//  APKBaseViewController.m
//  保时捷项目
//
//  Created by Mac on 16/4/21.
//
//

#import "APKBaseViewController.h"

@interface APKBaseViewController ()

@end

@implementation APKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *isDark = [[NSUserDefaults standardUserDefaults] objectForKey:@"DARKMODE"];
    if ([isDark isEqualToString:@"YES"]) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    }
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}



@end
