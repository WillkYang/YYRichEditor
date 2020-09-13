//
//  NSTextAttachment+YYText.m
//  YYLib
//
//  Created by WillkYang on 2017/7/18.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "NSTextAttachment+YYText.h"
#import <objc/runtime.h>
#import "YYParagraphConfig.h"

@implementation NSTextAttachment (YYText)

+ (instancetype)checkBoxAttachment {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.bounds = CGRectMake(0, 0, 20, 20);
    textAttachment.image = [self imageWithType:YYParagraphTypeCheckbox];
    return textAttachment;
}

+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    CGRect rect = CGRectZero;
    rect.size.width = width;
    rect.size.height = width * image.size.height / image.size.width;
    textAttachment.image = image;
    textAttachment.bounds = rect;
    return textAttachment;
}

+ (UIImage *)imageWithType:(YYParagraphType)type {
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor redColor] setStroke];
    path.lineWidth = 2.f;
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static void *attachmentTypeKey = &attachmentTypeKey;
static void *userInfoKey = &userInfoKey;

- (YYTextAttachmentType)attachmentType {
    return [(NSNumber *)objc_getAssociatedObject(self, attachmentTypeKey) intValue];
}

- (void)setAttachmentType:(YYTextAttachmentType)attachmentType {
    objc_setAssociatedObject(self, attachmentTypeKey, @(attachmentType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo {
    return objc_getAssociatedObject(self, userInfoKey);
}

- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
