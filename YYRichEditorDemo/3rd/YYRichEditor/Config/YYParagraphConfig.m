//
//  YYParagraphConfig.m
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYParagraphConfig.h"

NSString * const YYParagraphTypeName = @"YYParagraphType";
NSString * const YYParagraphIndentName = @"YYParagraphIndent";

@implementation YYParagraphConfig

static CGFloat const kIndexPerLevel = 32.f;
static NSInteger const kMaxIndentLevel = 6;

- (instancetype)init {
    if (self = [super init]) {
        _type = YYParagraphTypeNone;
        _indentLevel = 0;
    }
    return self;
}

- (instancetype)initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle type:(YYParagraphType)type {
    if (self = [super init]) {
        _indentLevel = paragraphStyle.headIndent / kIndexPerLevel;
    }
    return self;
}

- (void)setIndentLevel:(NSInteger)indentLevel {
    if (indentLevel < 0) {
        indentLevel = 0;
    } else if (indentLevel > kMaxIndentLevel) {
        indentLevel = kMaxIndentLevel;
    }
    _indentLevel = indentLevel;
}

- (NSParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.headIndent = kIndexPerLevel * self.indentLevel;
    paragraphStyle.firstLineHeadIndent = kIndexPerLevel * self.indentLevel;
    paragraphStyle.alignment = self.alignment;
    return paragraphStyle;
}

@end
