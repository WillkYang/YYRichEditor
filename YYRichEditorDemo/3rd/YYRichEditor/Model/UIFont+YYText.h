//
//  UIFont+YYText.h
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YYText)

@property (nonatomic, readonly) BOOL bold;
@property (nonatomic, readonly) BOOL italic;
@property (nonatomic, readonly) CGFloat fontSize;

+ (instancetype)yy_fontWithFontSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic;

@end
