//
//  APKOpenSourceViewController.m
//  万能AIT
//
//  Created by mac on 2021/1/28.
//  Copyright © 2021 APK. All rights reserved.
//

#import "APKOpenSourceViewController.h"
#import <WebKit/WebKit.h>

@interface APKOpenSourceViewController ()<WKNavigationDelegate,UIGestureRecognizerDelegate>

@end

@implementation APKOpenSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];

    self.title = NSLocalizedString(@"开放源代码许可", nil);
    
    //初始化myWebView
    WKWebView *myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    NSURL *filePath = [NSURL new];
    NSString *lan = [self getLanguage];
    if ([lan containsString:@"fr"])
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"200311 OSS儔僀僙儞僗暥亜[KX085,KX086]iOS傾僾儕 (僀儞僞乕僼僃乕僗) 亜愝掕尵岅=僼儔儞僗岅" ofType:@"pdf"]];
    else if([lan containsString:@"ja"])
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"license-jp_ios" ofType:@"pdf"]];
    else
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"200311 OSS儔僀僙儞僗暥亜[KX085,KX086]iOS傾僾儕 (僀儞僞乕僼僃乕僗) 亜愝掕尵岅=擔杮岅丄僼儔儞僗岅埲奜" ofType:@"pdf"]];
    
    filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"170_APP_iOS 0413" ofType:@"pdf"]];

    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    myWebView.navigationDelegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
    longPress.delegate = self;

    longPress.minimumPressDuration = 0.4f;
    longPress.numberOfTouchesRequired = 1;
    longPress.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:longPress];
    
}


-(NSString *) getLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [[NSString alloc] initWithString:[languages objectAtIndex:0]];
    
    return currentLanguage;;
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = @"";

    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
