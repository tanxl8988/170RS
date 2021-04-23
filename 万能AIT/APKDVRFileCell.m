//
//  APKDVRFileCell.m
//  万能AIT
//
//  Created by Mac on 17/3/23.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKDVRFileCell.h"


@implementation APKDVRFileCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCell:)];
    [self addGestureRecognizer:longpress];
    
    [self.downloadButton setTitle:NSLocalizedString(@"已下载", nil) forState:UIControlStateNormal];
}

- (void)didLongPressCell:(UILongPressGestureRecognizer *)sender{
    
    if (self.delegate) {
        
        if (sender.state == UIGestureRecognizerStateBegan) {
            if ([self.delegate respondsToSelector:@selector(didBeganLongPress:)]) {
                [self.delegate didBeganLongPress:self];
            }
        }
        else if(sender.state == UIGestureRecognizerStateEnded){
            if ([self.delegate respondsToSelector:@selector(didEndedLongPress:)]) {
                [self.delegate didEndedLongPress:self];
            }
        }
    }
}

- (void)configureCellWithDVRFile:(APKDVRFile *)file{
    
    self.titleLabel.text = file.name;
    self.downloadButton.hidden = !file.isDownloaded;
    self.lockButton.hidden = !file.isLocked;
    self.deleteButton.enabled = !file.isLocked;
    
    if (file.thumbnailPath) {
        UIImage *image = [UIImage imageWithContentsOfFile:file.thumbnailPath];
        self.imagev.image = image;
    }
}

- (IBAction)didClickDeleteButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickDeleteButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickDeleteButton:sender];
        }
    }
}

- (IBAction)didClickDownloadButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickDownloadButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickDownloadButton:sender];
        }
    }
}

- (IBAction)didClickLockButton:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(APKDVRFileCell:didClickLockButton:)]) {
            
            [self.delegate APKDVRFileCell:self didClickLockButton:sender];
        }
    }
}

@end
