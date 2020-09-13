
//
//  UIFont+YYText.m
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "UIFont+YYText.h"
#import "YYConfig.h"


@implementation UIFont (YYText)

- (BOOL)bold {
    return [self.description containsString:@"font-weight: bold"];
}

- (BOOL)italic {
    // 通过是否包含 matrix 判断斜体
    return self.fontDescriptor.fontAttributes[@"NSCTFontMatrixAttribute"] != nil;
}

- (CGFloat)fontSize {
    return [self.fontDescriptor.fontAttributes[@"NSFontSizeAttribute"] floatValue];
}

+ (instancetype)yy_fontWithFontSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic {
    UIFont *font = [UIFont fontWithName:bold ? kYNBoldFontName : kYNFontName size:fontSize];
    if (italic) {
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15*(CGFloat)M_PI/180), 1, 0, 0);
        UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:bold ? kYNBoldFontName : kYNFontName matrix:matrix];
        font = [UIFont fontWithDescriptor:descriptor size:fontSize];
    }
    return font;
}

//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:kYNFontName size:fontSize];
//}
@end
