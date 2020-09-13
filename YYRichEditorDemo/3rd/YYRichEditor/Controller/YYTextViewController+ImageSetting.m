//
//  YYTextViewController+ImageSetting.m
//  YYNote
//
//  Created by WillkYang on 2017/8/12.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextViewController+ImageSetting.h"
#import "YYImageSettingsController.h"
#import "NSTextAttachment+YYText.h"

@implementation YYTextViewController (ImageSetting)


- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController presentPreview:(UIViewController *)previewController {
    [self presentViewController:previewController animated:YES completion:nil];
}

- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController insertImage:(UIImage *)image {
    [self savePhoto:image];
}

- (void)yy_imageSettingsController:(YYImageSettingsController *)viewController presentImagePickerView:(UIViewController *)picker {
    picker.modalPresentationStyle = UIModalPresentationAutomatic;
//    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)savePhoto:(UIImage *)image {
    
    float actualWidth = image.size.width * image.scale;
    float boundsWidth = CGRectGetWidth(self.view.bounds) - 8.f*2;
    
    float compressionQuality = boundsWidth/actualWidth;
    compressionQuality = MIN(compressionQuality, 1);

    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    UIImage *compressImage = [UIImage imageWithData:imageData];
    
    if ([self.delegate respondsToSelector:@selector(yy_saveImage:)]) {
        NSString *fileName = [self.delegate yy_saveImage:compressImage];
        if (fileName) {
            __block NSTextAttachment *attachment = [self insertImageToTextView:compressImage];
            [self.textView resignFirstResponder];
            [self.textView scrollRangeToVisible:self.lastSelectedRange];
            attachment.attachmentType = YYTextAttachmentTypeImage;
            attachment.userInfo = fileName;
        }
    }
}

- (NSTextAttachment *)insertImageToTextView:(UIImage *)image {
    float boundsWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = boundsWidth - self.textView.textContainerInset.left - self.textView.textContainerInset.right - 12.f;
    NSTextAttachment *textAttachment = [NSTextAttachment attachmentWithImage:image width:width];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attributeString insertAttributedString:attachmentString atIndex:0];
    
    if (self.lastSelectedRange.location != 0 && ![[self.textView.text substringWithRange:NSMakeRange(self.lastSelectedRange.location - 1, 1)] isEqualToString:@"\n"]) {
        // 上一个字符不为"\n"且不是第一个位置 则图片前添加一个换行
        [attributeString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
    }
    [attributeString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, attributeString.length)];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    //    paragraphStyle.paragraphSpacingBefore = 20.f;
    //    paragraphStyle.paragraphSpacing = 20.f;
    //    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeString.length)];
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributeText replaceCharactersInRange:self.lastSelectedRange withAttributedString:attributeString];
    self.lastSelectedRange = NSMakeRange(self.lastSelectedRange.location + self.lastSelectedRange.length + 1, 0);
    self.textView.allowsEditingTextAttributes = YES;
    self.dontUpdateLastSelectedRange = YES;
    self.textView.attributedText = attributeText;
    self.textView.allowsEditingTextAttributes = NO;
    
    return textAttachment;
}
@end
