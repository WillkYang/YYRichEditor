//
//  YYParagraphConfig.h
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const YYParagraphTypeName;
extern NSString * const YYParagraphIndentName;

typedef enum : NSUInteger {
    YYParagraphTypeNone = 0,
    YYParagraphTypeList,
    YYParagraphTypeNumberList,
    YYParagraphTypeCheckbox,
} YYParagraphType;

@interface YYParagraphConfig : NSObject

@property (nonatomic, assign) YYParagraphType type;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) NSInteger indentLevel;
@property (nonatomic, readonly) NSParagraphStyle *paragraphStyle;

- (instancetype)initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle type:(YYParagraphType)type;

@end
