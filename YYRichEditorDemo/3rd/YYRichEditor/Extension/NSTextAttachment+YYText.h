//
//  NSTextAttachment+YYText.h
//  YYLib
//
//  Created by WillkYang on 2017/7/18.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YYTextAttachmentTypeImage,
//    YYTextAttachmentTypeCheckBox,
} YYTextAttachmentType;

@interface NSTextAttachment (YYText)

+ (instancetype)checkBoxAttachment;
+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width;

@property (nonatomic, assign) YYTextAttachmentType attachmentType;
@property (nonatomic, strong) id userInfo;

@end
