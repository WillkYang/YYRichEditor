//
//  YYTextStyle.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextStyle.h"
#import "UIFont+YYText.h"

@implementation YYTextStyle

- (instancetype)init {
    if (self = [super init]) {
        _fontSize = [UIFont systemFontSize];
        _textColor = [UIColor whiteColor];
    }
    return self;
}

+ (instancetype)textStyleWithType:(YYTextStyleFormat)style {
    YYTextStyle *textStyle = [[self alloc] init];
    switch (style) {
        case YYTextStyleFormatTitleSmall:
            textStyle.fontSize = 18.f;
            break;
        case YYTextStyleFormatTitleMedium:
            textStyle.fontSize = 24.f;
            break;
        case YYTextStyleFormatTitleLarge:
            textStyle.fontSize = 30.f;
            break;
        default:
            textStyle.fontSize = 17.f;
            return textStyle;
    }
    textStyle.bold = YYTextStyleFormatNormal ? NO : YES;
    return textStyle;
}

- (YYTextStyleFormat)style {
    if (self.bold == YES && self.italic == NO && self.underline == NO) {
        if (self.fontSize == 18.f) {
            return YYTextStyleFormatTitleSmall;
        } else if (self.fontSize == 24.f) {
            return YYTextStyleFormatTitleMedium;
        } else if (self.fontSize == 30.f) {
            return YYTextStyleFormatTitleLarge;
        }
    }
    return YYTextStyleFormatNormal;
}

- (UIFont *)font {
    return [UIFont yy_fontWithFontSize:self.fontSize bold:self.bold italic:self.italic];
}
@end
