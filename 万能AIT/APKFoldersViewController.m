//
//  APKFoldersViewController.m
//  万能AIT
//
//  Created by Mac on 17/3/22.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKFoldersViewController.h"
#import "APKFloderCell.h"
#import "APKDVRFilesViewController.h"
#import "APKLocalFilesViewController.h"
#import "MBProgressHUD.h"
#import "APKDVR.h"
#import "APKAlertTool.h"
#import <Photos/Photos.h>
#import "APKAlbumCoverInfo.h"
#import "APKGetLocalAlbumCoverInfo.h"
#import "APKFlodersView.h"


static NSString *localFloderCellIdentifier = @"localFloderCell";
static NSString *dvrFloderCellIdentifier = @"dvrFloderCell";

@interface APKFoldersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,APKFlodersViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *localFloderCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dvrFloderCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *localFloderLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *dvrFloderLayout;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong,nonatomic) NSMutableArray *localAlbumInfos;
@property (strong,nonatomic) NSMutableArray *dvrAlbumInfos;
@property (strong,nonatomic) APKGetLocalAlbumCoverInfo *getLocalAlbumCoverInfo;
@property (strong,nonatomic) NSArray *albumSort;//决定文件夹的排序
@property (copy,nonatomic) void (^updateLocalAlbumCoverInfoBlock)(APKFileType fileType);
@property (strong,nonatomic) APKFlodersView *localFlodersView;
@property (strong,nonatomic) APKFlodersView *dvrFlodersView;

@end

@implementation APKFoldersViewController


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"相册", nil);

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.scrollViewContentWidth.constant = screenWidth * 2;
    self.scrollView.contentSize = CGSizeMake(screenWidth*2, CGRectGetHeight(self.scrollView.frame));
    
    CGFloat space = (self.localFloderLayout.sectionInset.left + self.localFloderLayout.sectionInset.right) * 2;
    CGFloat infoViewHeight = 29;
    CGFloat cellWidth = (screenWidth - space) / 2;
    CGFloat cellHeight = cellWidth * 0.77 + infoViewHeight;
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    self.localFloderLayout.itemSize = cellSize;
    self.dvrFloderLayout.itemSize = cellSize;
    
    [self.scrollView addSubview:self.dvrFlodersView];
    [self.scrollView addSubview:self.localFlodersView];
    
    self.scrollView.pagingEnabled = YES;

    
    [self.segmentControl removeAllSegments];
    [self.segmentControl insertSegmentWithTitle:NSLocalizedString(@"DVR", nil) atIndex:0 animated:NO];
    [self.segmentControl insertSegmentWithTitle:NSLocalizedString(@"本地", nil) atIndex:1 animated:NO];
    self.segmentControl.selectedSegmentIndex = 0;
    
    //Photos authorization
//    [self checkPHAuthorizationStatus];
    
    //setup block
//    [self setupUpdateLocalAlbumCoverInfoBlock];
}


#pragma mark - private method

/*
- (void)setupUpdateLocalAlbumCoverInfoBlock{
    
    __weak typeof(self)weakSelf = self;
    self.updateLocalAlbumCoverInfoBlock = ^(APKFileType fileType){
        
        if (self.localAlbumInfos.count == 0) return;
        
        [weakSelf.getLocalAlbumCoverInfo getLocalAlbumCoverInfoWithType:fileType completionHandler:^(APKAlbumCoverInfo *info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger item = [weakSelf.albumSort indexOfObject:@(fileType)];
                [weakSelf.localAlbumInfos replaceObjectAtIndex:item withObject:info];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
                [weakSelf.localFloderCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }];
    };
}

- (void)loadLocalAlbumCoverInfo{
    
    [self.getLocalAlbumCoverInfo getLocalAlbumCoverInfo:self.albumSort completionHandler:^(NSArray<APKAlbumCoverInfo *> *infos) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.localAlbumInfos setArray:infos];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
            [self.localFloderCollectionView insertSections:indexset];
        });
    }];
}
 

- (void)checkPHAuthorizationStatus{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        [self loadLocalAlbumCoverInfo];
        
    }else{
        
        if (status == PHAuthorizationStatusDenied) {
            
            [self showGetPHAuthorizationAlert];
            
        }else{
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    [self loadLocalAlbumCoverInfo];
                }
            }];
        }
    }
}

- (void)showGetPHAuthorizationAlert{
    
    [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"请允许访问iPhone的\"照片\"，否则无法使用下载功能！", nil) confirmHandler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            
            NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
            NSInteger iosVersionNumber = [[[iosVersion componentsSeparatedByString:@"."] firstObject] integerValue];
            if (iosVersionNumber >= 10) {
                
                [app openURL:url options:@{} completionHandler:^(BOOL success) {}];
                
            }else{
                
                [app openURL:url];
            }
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (collectionView == self.dvrFloderCollectionView) {
        
        return self.dvrAlbumInfos.count == 0 ? 0 : 1;
        
    }else{
        
        return self.localAlbumInfos.count == 0 ? 0 : 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return collectionView == self.localFloderCollectionView ? self.localAlbumInfos.count : self.dvrAlbumInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    APKFloderCell *cell = nil;
    if (collectionView == self.localFloderCollectionView) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:localFloderCellIdentifier forIndexPath:indexPath];
        APKAlbumCoverInfo *albumInfo = self.localAlbumInfos[indexPath.row];
        cell.label.text = albumInfo.info;
        cell.imagev.image = albumInfo.image;
        if (albumInfo.asset) {
            [[PHImageManager defaultManager] requestImageForAsset:albumInfo.asset targetSize:cell.coverImagev.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.coverImagev.image = result;
            }];
        }else{
            cell.coverImagev.image = nil;
        }
        
    }else if (collectionView == self.dvrFloderCollectionView){
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:dvrFloderCellIdentifier forIndexPath:indexPath];
        APKAlbumCoverInfo *albumInfo = self.dvrAlbumInfos[indexPath.row];
        cell.label.text = albumInfo.info;
        cell.imagev.image = albumInfo.image;
        cell.coverImagev.image = nil;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.localFloderCollectionView) {
        
        APKAlbumCoverInfo *albumInfo = self.localAlbumInfos[indexPath.row];
        [self performSegueWithIdentifier:@"browseLocalFiles" sender:albumInfo];
        
    }else if (collectionView == self.dvrFloderCollectionView){
        
        if (![APKDVR sharedInstance].isConnected) {
            
            [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接DVR", nil) confirmHandler:^(UIAlertAction *action) {
            }];
            return;
        }
        
        APKAlbumCoverInfo *albumInfo = self.dvrAlbumInfos[indexPath.row];
        [self performSegueWithIdentifier:@"browseDVRFiles" sender:albumInfo];
    }
}*/

#pragma mark - APKFlodersViewDelegate

- (void)APKFlodersView:(APKFlodersView *)flodersView didSelectedFloderAtIndex:(NSInteger)index{
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        APKDVR *dvr = [APKDVR sharedInstance];
        if (dvr.isConnected == YES) {
            
            [self performSegueWithIdentifier:@"browseDVRFiles" sender:@(index)];
        }
        else{
            
            [APKAlertTool showAlertInViewController:self title:nil message:NSLocalizedString(@"未连接", nil) confirmHandler:^(UIAlertAction *action) {
                nil;
            }];
        }
    }
    else if (self.segmentControl.selectedSegmentIndex == 1){
        
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            [self performSegueWithIdentifier:@"browseLocalFiles" sender:@(index)];//根据场景线推出控制器
        }
        else{
            [self checkPHAuthorizationStatus];
        }
    }
}

- (void)checkPHAuthorizationStatus{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
//        [self loadLocalAlbumCoverInfo];
        
    }else{
        
        if (status == PHAuthorizationStatusDenied) {
            
            [self showGetPhotosAuthorityAlert];
            
        }else{
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
//                    [self loadLocalAlbumCoverInfo];
                }
            }];
        }
    }
}

- (void)showGetPhotosAuthorityAlert{//获得照片权限
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"将所记录数据下载到“照片“，请允许访问iPhone的”照片”", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            
            NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
            NSInteger iosVersionNumber = [[[iosVersion componentsSeparatedByString:@"."] firstObject] integerValue];
            if (iosVersionNumber >= 10) {
                
                [app openURL:url options:@{} completionHandler:^(BOOL success) { /*do nothing*/ }];
                
            }else{
                [app openURL:url];
            }
        }
    }];

    [alertController addAction:confirm];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        
        self.segmentControl.selectedSegmentIndex = 0;
        
    }else{
        
        self.segmentControl.selectedSegmentIndex = 1;
    }
}

#pragma mark - actions

- (IBAction)updateSegmentControl:(UISegmentedControl *)sender {
    
    CGFloat offsetX = 0;
    if (sender.selectedSegmentIndex == 1) {
        CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
        offsetX = scrollViewWidth;
    }
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = offsetX;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollView.contentOffset = offset;
    }];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"browseDVRFiles"]) {
        
        NSInteger index = [sender integerValue];
        APKFileType fileType;
        if (index == 0) {
            fileType = APKFileTypeVideo;
        }
        else if (index == 1){
            fileType = APKFileTypeEvent;
        }
        else if (index == 2){
            fileType = APKFileTypeSecurity;
        }
        else{
            fileType = APKFileTypeCapture;
        }
        
        APKDVRFilesViewController *vc = segue.destinationViewController;
        vc.fileType = fileType;
    }
    else if ([segue.identifier isEqualToString:@"browseLocalFiles"]){
        
        NSInteger index = [sender integerValue];
        APKFileType fileType;
        if (index == 0) {
            fileType = APKFileTypeVideo;
        }
        else if (index == 1){
            fileType = APKFileTypeEvent;
        }
        else if (index == 2){
            fileType = APKFileTypeSecurity;
        }
        else{
            fileType = APKFileTypeCapture;
        }
        
        APKLocalFilesViewController *vc = segue.destinationViewController;
        vc.fileType = fileType;
    }
}

#pragma mark - getter
/*
- (NSArray *)albumSort{
    
    if (!_albumSort) {
        
        _albumSort = @[@(APKFileTypeCapture),@(APKFileTypeVideo),@(APKFileTypeEvent)];
    }
    
    return _albumSort;
}

- (APKGetLocalAlbumCoverInfo *)getLocalAlbumCoverInfo{
    
    if (!_getLocalAlbumCoverInfo) {
        
        _getLocalAlbumCoverInfo = [[APKGetLocalAlbumCoverInfo alloc] init];
    }
    
    return _getLocalAlbumCoverInfo;
}

- (NSMutableArray *)localAlbumInfos{
    
    if (!_localAlbumInfos) {
        
        _localAlbumInfos = [[NSMutableArray alloc] init];
    }
    
    return _localAlbumInfos;
}

- (NSMutableArray *)dvrAlbumInfos{
    
    if (!_dvrAlbumInfos) {
        
        _dvrAlbumInfos = [[NSMutableArray alloc] init];
        for (NSNumber *number in self.albumSort) {
            
            APKFileType type = [number integerValue];
            APKAlbumCoverInfo *info = [APKAlbumCoverInfo dvrAlbumWithType:type];
            [_dvrAlbumInfos addObject:info];
        }
    }
    return _dvrAlbumInfos;
}*/

- (APKFlodersView *)dvrFlodersView{
    
    if (!_dvrFlodersView) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"APKFlodersView" owner:nil options:nil];
        for (id obj in arr) {
            if ([obj isKindOfClass:[APKFlodersView class]]) {
                
                _dvrFlodersView = obj;
                _dvrFlodersView.frame = CGRectMake(0, 0,CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
                _dvrFlodersView.delegate = self;
                break;
            }
        }
    }
    return _dvrFlodersView;
}

- (APKFlodersView *)localFlodersView{
    
    if (!_localFlodersView) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"APKFlodersView" owner:nil options:nil];
        for (id obj in arr) {
            if ([obj isKindOfClass:[APKFlodersView class]]) {
                
                _localFlodersView = obj;
                _localFlodersView.frame = CGRectMake(self.view.bounds.size.width, 0,CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
                _localFlodersView.delegate = self;

                break;
            }
        }
    }
    return _localFlodersView;
}

@end



