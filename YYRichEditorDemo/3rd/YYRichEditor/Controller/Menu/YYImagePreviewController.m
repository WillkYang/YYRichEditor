//
//  YYImagePreviewController.m
//  YYLib
//
//  Created by WillkYang on 2017/8/8.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYImagePreviewController.h"
#import <Photos/Photos.h>
#import <TOCropViewController/TOCropViewController.h>

@interface YYImagePreviewController () <TOCropViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation YYImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:244/255.f alpha:1.f].CGColor;
    [self.toolView.layer addSublayer:topBorder];
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_previewController:dismissPreviewWithCancel:image:)]) {
        [self.delegate yy_previewController:self dismissPreviewWithCancel:YES image:nil];
    }
}

- (IBAction)editButtonClick:(id)sender {
    TOCropViewController *vc = [[TOCropViewController alloc] initWithImage:self.image];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)doneButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_previewController:dismissPreviewWithCancel:image:)]) {
        [self.delegate yy_previewController:self dismissPreviewWithCancel:NO image:self.image];
    }
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    targetSize.width *= 2;
    targetSize.height *= 2;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL isDegraded = [info[PHImageResultIsDegradedKey] boolValue];
        if (!isDegraded) {
            self.image = result;
            self.imageView.image = result;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    BOOL hidden = self.bottomConstraint.constant == 0;
    self.bottomConstraint.constant = hidden ? -CGRectGetHeight(self.toolView.frame) : 0;
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    self.image = image;
    self.imageView.image = image;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
