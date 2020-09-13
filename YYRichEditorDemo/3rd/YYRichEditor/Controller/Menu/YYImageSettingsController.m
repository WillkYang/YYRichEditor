//
//  YYImageSettingsController.m
//  YYLib
//
//  Created by WillkYang on 2017/8/8.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYImageSettingsController.h"
#import <Photos/Photos.h>
#import "YYImagePreviewController.h"
#import <RITLPhotos/RITLPhotos.h>


@interface YYImageSettingsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@end
@implementation YYImageSettingsCollectionViewCell
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedImageView.hidden = !selected;
}
@end

static NSString * const cellIdentifier = @"YYImageSettingsCollectionViewCell";

@interface YYImageSettingsController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYImagePreviewControllerDelegate, RITLPhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) UIViewController *previewController;
@property (assign, nonatomic) BOOL selecting;

@property (nonatomic, strong) PHFetchResult *photoResult;
@property (nonatomic, strong) NSMutableDictionary *photos;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation YYImageSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selecting = NO;
    [self fetchPhotos];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout =(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat height = CGRectGetHeight(self.collectionView.frame);
    layout.itemSize = CGSizeMake(height * 0.8, height);
    [self.collectionView setNeedsLayout];
}

- (void)fetchPhotos {
    PHFetchOptions *nearestPhotoOptions = [[PHFetchOptions alloc] init];
    nearestPhotoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    nearestPhotoOptions.fetchLimit = 20;
    self.photoResult = [PHAsset fetchAssetsWithOptions:nearestPhotoOptions];
    self.photos = [NSMutableDictionary dictionary];
}

- (void)reload {
    self.selecting = NO;
    self.selectedIndexPath = nil;
    [self.collectionView reloadData];
}

- (void)setSelecting:(BOOL)selecting {
    _selecting = selecting;
    
    if (selecting) {
        [self.button1 setTitle:@"预览" forState:UIControlStateNormal];
        [self.button2 setTitle:@"插入" forState:UIControlStateNormal];
        [self.button1 setImage:[UIImage imageNamed:@"photo_preview_icon"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"ico_insert_image"] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.button2 setTitleColor:[UIColor colorWithRed:93/255.f green:150/255.f blue:209/255.f alpha:1.f] forState:UIControlStateNormal];
    } else {
        [self.button1 setTitle:@"拍照" forState:UIControlStateNormal];
        [self.button2 setTitle:@"相册" forState:UIControlStateNormal];
        [self.button1 setImage:[UIImage imageNamed:@"photo_take_icon"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"photo_gallery_icon"] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.button2 setTitleColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.f] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonClick:(id)sender {
    if (self.selecting) {
        if (sender == self.button1) {
            // 预览
            YYImagePreviewController *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYImagePreviewController"];
            previewController.delegate = self;
            previewController.asset = self.photoResult[self.selectedIndexPath.item];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:previewController];
            [self.delegate yy_imageSettingsController:self presentPreview:previewController];
        } else {
            // 插入
            PHAsset *asset = self.photoResult[self.selectedIndexPath.item];
            CGSize targetSize = [UIScreen mainScreen].bounds.size;
            targetSize.width *= 2;
            targetSize.height *= 2;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                BOOL isDegraded = [info[PHImageResultIsDegradedKey] boolValue];
                if (!isDegraded) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
                        [self.delegate yy_imageSettingsController:self insertImage:result];
                    }
                }
            }];
        }
    } else {
        RITLPhotosViewController *picker = [RITLPhotosViewController photosViewController];
        picker.configuration.maxCount = 15;
        picker.photo_delegate = self;
        if (self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
            [self.delegate yy_imageSettingsController:self presentImagePickerView:picker];
        }
        
//        [self presentViewController:vc animated:YES completion:nil];
//        MSImagePickerController *picker = [[MSImagePickerController alloc] init];
//        picker.doneButtonTitle = @"插入";
//        picker.maxImageCount = 9;
//        picker.msDelegate = self;
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        if (sender == self.button1) {
//            // 拍照
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        } else {
//            // 相册
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }
////        picker.delegate = self;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
//            [self.delegate yy_imageSettingsController:self presentImagePickerView:picker];
//        }
    }
}

- (void)photosViewController:(UIViewController *)viewController
images:(NSArray <UIImage *> *)images
                       infos:(NSArray <NSDictionary *> *)infos {
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull scaledImage, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
               [self.delegate yy_imageSettingsController:self insertImage:scaledImage];
           }
    }];
}


#pragma mark - <UICollectionViewDataSource, UICollectionDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYImageSettingsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImage *image = self.photos[indexPath];
    if (image) {
        cell.imageView.image = image;
    } else {
        cell.imageView.image = nil;
        PHAsset *asset = self.photoResult[indexPath.row];
        CGSize targetSize = CGSizeMake(200, 200);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photos[indexPath] = result;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    cell.selected = [indexPath isEqual:self.selectedIndexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.selectedIndexPath]) {
        self.selectedIndexPath = nil;
        self.selecting = NO;
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else {
        self.selectedIndexPath = indexPath;
        self.selecting = YES;
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self fetchPhotos];
}

#pragma mark - YYImagePreviewControllerDelegate
//- (void)yy_previewController:(YYImagePreviewController *)previewController dismissPreviewWithCancel:(BOOL)cancel {
//    if (!cancel && self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
//        [self.delegate yy_imageSettingsController:self insertImage:self.photos[self.selectedIndexPath]];
//    }
//}

- (void)yy_previewController:(YYImagePreviewController *)previewController dismissPreviewWithCancel:(BOOL)cancel image:(UIImage *)image {
    if (!cancel && self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
        [self.delegate yy_imageSettingsController:self insertImage:image];
    }
}


#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    targetSize.width *=2;
    targetSize.height = targetSize.width * originImage.size.height / originImage.size.width;
    
    UIGraphicsBeginImageContext(targetSize);
    [originImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_imageSettingsController:insertImage:)]) {
        [self.delegate yy_imageSettingsController:self insertImage:scaledImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
