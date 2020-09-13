//
//  YYTextStyle.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YYTextStyleFormatNormal = 0,
    YYTextStyleFormatTitleSmall,
    YYTextStyleFormatTitleMedium,
    YYTextStyleFormatTitleLarge
} YYTextStyleFormat;

@interface YYTextStyle : NSObject

@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) BOOL underline;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) YYTextStyleFormat style;
+ (instancetype)textStyleWithType:(YYTextStyleFormat)style;
@end
