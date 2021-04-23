//
//  APKAboatViewController.m
//  YunZhiHui2
//
//  Created by Cong's Jobs on 15/12/3.
//  Copyright © 2015年 Apical. All rights reserved.
//

#import "APKAboatViewController.h"
#import <WebKit/WebKit.h>

@interface APKAboatViewController ()<UIWebViewDelegate>
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) WKWebView *webView;
@end

@implementation APKAboatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"说明书", nil);
    [self.navigationController setNavigationBarHidden:NO];

    NSURL *filePath = [NSURL new];
    NSString *lan = [self getLanguageStr];
    if ([lan containsString:@"en"]) {

        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409_EN_html - iOS(EN)" ofType:@"pdf"]];
    }else if ([lan containsString:@"fr"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(FR)" ofType:@"pdf"]];
    }else if ([lan containsString:@"de"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(DE)" ofType:@"pdf"]];
    }else if ([lan containsString:@"ru"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(UR)" ofType:@"pdf"]];
    }else if ([lan containsString:@"it"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409html - iOS(IT)" ofType:@"pdf"]];
    }else if ([lan containsString:@"es"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(ES)" ofType:@"pdf"]];
    }else if ([lan containsString:@"nl"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(NL)" ofType:@"pdf"]];
    }else if ([lan containsString:@"pl"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409_EN_html - iOS(EN)" ofType:@"pdf"]];
    }else if([lan containsString:@"pt"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(PT)" ofType:@"pdf"]];
    }else if([lan containsString:@"uk"]){
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409.html - iOS(UR)" ofType:@"pdf"]];
    }else{
        filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20210409_EN_html - iOS(EN)" ofType:@"pdf"]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
}



-(NSString *) getLanguageStr
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [[NSString alloc] initWithString:[languages objectAtIndex:0]];
    return  currentLanguage;
}

#pragma mark - 设置返回按钮
- (void)setNavigationLeftBar
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


#pragma mark - 返回点击事件
- (void)back{
    [self dismissViewControllerAnimated:NO completion:^{
        nil;
    }];
}

-(WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}

-(UIScrollView*)scrollView
{
    float imageHeight = 0;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    int scrollviewHeight = 0;
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = NO;
        
        for (int i = 0;  i < 12; i++) {
            
            imageHeight = [UIImage imageNamed:[NSString stringWithFormat:@"080115345848_0html-iOS_%d",i]].size.height * width / [UIImage imageNamed:[NSString stringWithFormat:@"080115345848_0html-iOS_%d",i]].size.width;
            
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollviewHeight, width, imageHeight)];
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"080115345848_0html-iOS_%d",i]];
            [_scrollView addSubview:image];
            
            scrollviewHeight += imageHeight + 120*width/375;
        }
        
        _scrollView.contentSize = CGSizeMake(width, scrollviewHeight - 80);
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    
    return _scrollView;
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end









