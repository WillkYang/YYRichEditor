//
//  YYImageSettingsController.h
//  YYLib
//
//  Created by WillkYang on 2017/8/8.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYImageSettingsController;

@protocol YYImageSettingsControllerDelegate <NSObject>
- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController presentPreview:(UIViewController *)previewController;
- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController insertImage:(UIImage *)image;
- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController presentImagePickerView:(UIViewController *)picker;
@end

@interface YYImageSettingsController : UIViewController

@property (nonatomic, weak) id<YYImageSettingsControllerDelegate> delegate;
- (void)reload;

@end
