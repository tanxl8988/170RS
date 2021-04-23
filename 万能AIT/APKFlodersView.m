//
//  APKFlodersView.m
//  Pioneer
//
//  Created by Mac on 17/9/12.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKFlodersView.h"


@interface APKFlodersView ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIImageView *imagev1;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIImageView *imagev2;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIImageView *imagev3;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIImageView *imagev4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation APKFlodersView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.button1.backgroundColor = [UIColor colorWithRed:53.f/255.f green:211.f/255.f blue:109.f/225.f alpha:1],self.button1.backgroundColor = [UIColor colorWithRed:47.f/255.f green:191.f/255.f blue:98.f/255.f alpha:1];
    self.button2.backgroundColor = [UIColor colorWithRed:111.f/255.f green:142.f/255.f blue:209.f/255.f alpha:1],self.button2.backgroundColor = [UIColor colorWithRed:103.f/255.f green:130.f/255.f blue:191.f/255.f alpha:1];
    self.button3.backgroundColor = [UIColor colorWithRed:219.f/255.f green:11.f/255.f blue:11.f/255.f alpha:1],self.button3.backgroundColor = [UIColor colorWithRed:168.f/255.f green:0 blue:0 alpha:1];
    self.button4.backgroundColor = [UIColor colorWithRed:92.f/255.f green:214.f/255.f blue:196.f/255.f alpha:1],self.button4.backgroundColor = [UIColor colorWithRed:81.f/255.f green:183.f/255.f blue:167.f/255.f alpha:1];

    self.label1.text = NSLocalizedString(@"视频", nil);
    self.label2.text = NSLocalizedString(@"事件", nil);
    self.label3.text = NSLocalizedString(@"泊车", nil);
    self.label4.text = NSLocalizedString(@"照片", nil);
}

#pragma mark - event response

- (IBAction)clickButton:(UIButton *)sender {
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(APKFlodersView:didSelectedFloderAtIndex:)])
        return;
    
    if (sender == self.button1) {
        
        [self.delegate APKFlodersView:self didSelectedFloderAtIndex:0];
    }
    else if (sender == self.button2){
        
        [self.delegate APKFlodersView:self didSelectedFloderAtIndex:1];
    }
    else if (sender == self.button3){
        
        [self.delegate APKFlodersView:self didSelectedFloderAtIndex:2];
    }
    else if (sender == self.button4){
        
        [self.delegate APKFlodersView:self didSelectedFloderAtIndex:3];
    }
}

@end
