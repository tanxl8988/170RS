//
//  APKPromiseView.m
//  Pioneer
//
//  Created by apical on 2019/6/20.
//  Copyright © 2019年 APK. All rights reserved.
//

#import "APKPromiseView.h"
#import "APKDVR.h"

@implementation APKPromiseView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.refuseButton setTitle:NSLocalizedString(@"不同意", nil) forState:UIControlStateNormal];
    [self.sureButton setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
    [self.setSureButton setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
    [self setButtonsEnable:NO];
}

-(void)setUpWebView
{
    //初始化myWebView
    NSURL *filePath = [NSURL new];
    NSString *lan = [self getLanguageStr];
    APKDVR *dvr = [APKDVR sharedInstance];
    if ([lan containsString:@"en"]) {

        filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_EN" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (EN)" ofType:@"docx"]];
    }else if ([lan containsString:@"fr"]){
              filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_FR" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (FR)" ofType:@"docx"]];
    }else if ([lan containsString:@"de"]){
              filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_DE" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (DE)" ofType:@"docx"]];
    }else if ([lan containsString:@"ru"]){
              filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_RU" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (RU)" ofType:@"docx"]];
    }else if ([lan containsString:@"it"]){
            filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_IT" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (IT)" ofType:@"docx"]];
    }else if ([lan containsString:@"es"]){
            filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_ES" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (ES)" ofType:@"docx"]];
    }else if ([lan containsString:@"nl"]){
            filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_NL" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (NL)" ofType:@"docx"]];
    }else if ([lan containsString:@"pl"]){
            filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_PL" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (PL)" ofType:@"docx"]];
    }else if([lan containsString:@"pt"]){
              filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_PT" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (PT)" ofType:@"docx"]];
    }else if([lan containsString:@"uk"]){
              filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_UA" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (UA)" ofType:@"docx"]];
    }else{
             filePath = _isEULA ? [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect EULA_clean_EN" ofType:@"docx"]] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Dash Camera Connect Privacy Policy (EN)" ofType:@"docx"]];
    }

    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 200)];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [self.wkWebView loadRequest:request];
    self.wkWebView.center = self.center;
    self.wkWebView.scrollView.delegate = self;
    [self.wkWebView sizeToFit];
    [self addSubview:self.wkWebView];
}

-(NSString *) getLanguageStr
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [[NSString alloc] initWithString:[languages objectAtIndex:0]];
    return  currentLanguage;
}

-(void)setButtonsEnable:(BOOL)enable
{
    if (enable == YES) {
        self.refuseButton.backgroundColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1];
        self.refuseButton.enabled = YES;
        
        self.sureButton.backgroundColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1];
        self.sureButton.enabled = YES;
        
        self.setSureButton.backgroundColor = [UIColor colorWithRed:183/255.f green:23/255.f blue:66/255.f alpha:1];
        self.setSureButton.enabled = YES;
    }else{
        
        self.sureButton.backgroundColor = [UIColor grayColor];
        self.sureButton.enabled = NO;
        
        self.setSureButton.backgroundColor = [UIColor grayColor];
        self.setSureButton.enabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger height = scrollView.contentSize.height - scrollView.contentOffset.y;
    if (height == (int)scrollView.frame.size.height-2)
        [self setButtonsEnable:YES];
}


- (IBAction)refuseButtonClicked:(UIButton *)sender {
    
    self.clickActionButton(100);
}

- (IBAction)sureButtonClicked:(UIButton *)sender {
    self.clickActionButton(101);
    if (!_isEULA) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"promiseValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}



@end
