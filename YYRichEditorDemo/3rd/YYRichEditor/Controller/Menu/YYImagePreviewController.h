//
//  YYImagePreviewController.h
//  YYLib
//
//  Created by WillkYang on 2017/8/8.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYImagePreviewController;
@class PHAsset;

@protocol YYImagePreviewControllerDelegate <NSObject>
- (void)yy_previewController:(YYImagePreviewController *)previewController dismissPreviewWithCancel:(BOOL)cancel image:(UIImage *)image;
@end

@interface YYImagePreviewController : UIViewController
@property (nonatomic, weak) id<YYImagePreviewControllerDelegate> delegate;
@property (nonatomic, strong) PHAsset *asset;
@end
