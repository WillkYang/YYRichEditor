//
//  YYTextParser.m
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextParser.h"
#import "UIFont+YYText.h"
#import "YYParagraphConfig.h"
#import "NSTextAttachment+YYText.h"
#import "YYTextItem.h"

@implementation YYTextParser

// 转换string为textItem
+ (NSArray <YYTextItem *> *)yy_textItemsFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        if (attachment) {
            // 附件
            switch (attachment.attachmentType) {
                case YYTextAttachmentTypeImage:
                {
                    YYTextItem *item = [YYTextItem yy_textItemWithImageUrl:attachment.userInfo width:attachment.bounds.size.width height:attachment.bounds.size.height];
                    item.I = dataArray.count;
                    [dataArray addObject:item];
                }
                    break;
                default:
                    break;
            }
        } else {
            NSString *text = [[attributedString string] substringWithRange:effectiveRange];
            YYTextItem *item = [YYTextItem yy_textItemWithString:text sttributes:attributes];
            item.I = dataArray.count;
            [dataArray addObject:item];
        }
        effectiveRange = NSMakeRange(effectiveRange.location+effectiveRange.length, 0);
    }
    return [dataArray copy];
}

// 转换textItem为string
+ (NSAttributedString *)yy_attributedStringFromTextItems:(NSArray <YYTextItem *> *)textItems width:(CGFloat)width {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [textItems enumerateObjectsUsingBlock:^(YYTextItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.P) {
            // 图片
//            CGFloat width = [UIScreen mainScreen].bounds.size.width - 60;
            NSTextAttachment *attachment = [NSTextAttachment attachmentWithImage:[item getImageSync] width:width];
            attachment.bounds = CGRectMake(0, 0, width, width * item.H / item.W);
            attachment.userInfo = item.F;
            NSMutableAttributedString *string = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//            paragraphStyle.paragraphSpacingBefore = 20.f;
            paragraphStyle.paragraphSpacing = 20.f;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
            
            
            
            [attributedString appendAttributedString:string];
        } else {
            // 文字
            [attributedString appendAttributedString:[item yy_toString]];
        }
    }];
    return attributedString;
}

+ (NSString *)yy_simpleHtmlFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableString *htmlContent = [NSMutableString string];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        if (attachment) {
            // 附件
            switch (attachment.attachmentType) {
                case YYTextAttachmentTypeImage:
                    [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\"/>",attachment.userInfo]];
                    break;
                default:
                    break;
            }
        } else {
            NSString *text = [[attributedString string] substringWithRange:effectiveRange];
            [htmlContent appendString:text];
        }
        effectiveRange = NSMakeRange(effectiveRange.location+effectiveRange.length, 0);
    }
    return [htmlContent copy];
}

+ (NSAttributedString *)yy_simpleAttributeStringFromHtml:(NSString *)htmlString width:(CGFloat)width {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSString *regex = @"<img.*?src=[\"|\']?(.*?)>";
    __block NSUInteger lastLoc = 0;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    [expression enumerateMatchesInString:htmlString options:0 range:NSMakeRange(0, htmlString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:[htmlString substringWithRange:NSMakeRange(lastLoc, result.range.location-lastLoc)]];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//        paragraphStyle.paragraphSpacingBefore = 20.f;
//        paragraphStyle.paragraphSpacing = 20.f;
//        paragraphStyle.lineSpacing = 8.f;
//        [textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
        
        [content appendAttributedString:textString];
        NSString *imgTag = [htmlString substringWithRange:result.range];
        NSRange urlRange = [imgTag rangeOfString:@"\"[^\\s]+\"" options:NSRegularExpressionSearch];
        if (urlRange.location != NSNotFound) {
            NSString *imgUrl = [[imgTag substringWithRange:urlRange] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            //        UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfFile:imgUrl]];
            NSTextAttachment *textAttachment = [NSTextAttachment attachmentWithImage:image width:width];
            textAttachment.attachmentType = YYTextAttachmentTypeImage;
            textAttachment.userInfo = imgUrl;
            NSMutableAttributedString *attachmentString = [[NSMutableAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//            paragraphStyle.paragraphSpacingBefore = 20.f;
//            paragraphStyle.paragraphSpacing = 20.f;
//            [attachmentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attachmentString.length)];
            [content appendAttributedString:attachmentString];
        }
        lastLoc = result.range.location + result.range.length;
    }];
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:[htmlString substringFromIndex:lastLoc]];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//    paragraphStyle.paragraphSpacingBefore = 20.f;
//    paragraphStyle.paragraphSpacing = 20.f;
//    paragraphStyle.lineSpacing = 8.f;
//    [textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textString.length)];
    [content appendAttributedString:textString];
//    [content appendAttributedString:[[NSAttributedString alloc] initWithString:[htmlString substringFromIndex:lastLoc]]];
    return [content copy];
}

+ (NSString *)yy_htmlFromAttributedString:(NSAttributedString *)attributedString {
    __block BOOL isNewParagraph = YES;
    NSMutableString *htmlContent = [NSMutableString string];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        NSParagraphStyle *paragraphStyle = attributes[@"NSParagraphStyle"];
        YYParagraphConfig *paragraphConfig = [[YYParagraphConfig alloc] initWithParagraphStyle:paragraphStyle type:YYParagraphTypeNone];
        if (attachment) {
            // 附件
            switch (attachment.attachmentType) {
                case YYTextAttachmentTypeImage:
                    [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\" width=100%%/>",attachment.userInfo]];
                    break;
                default:
                    break;
            }
        } else {
            NSString *text = [[attributedString string] substringWithRange:effectiveRange];
            UIFont *font = attributes[NSFontAttributeName];
            UIColor *fontColor = attributes[@"NSColor"];
            NSString *color = [self hexStringWithColor:fontColor];
            BOOL underline = [attributes[NSUnderlineStyleAttributeName] boolValue];
            __block BOOL isFirst = YES;
            NSArray *components = [text componentsSeparatedByString:@"\n"];
            [components enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!isFirst && !isNewParagraph) {
                    // 段末
                    [htmlContent appendString:@"</p>"];
                    isNewParagraph = YES;
                }
                if (isNewParagraph && (content.length > 0 || idx < components.count - 1)) {
                    [htmlContent appendString:[NSString stringWithFormat:@"<p style=\"text-indent:%@em; margin:4px auto 0px auto;\">", [@(2*paragraphConfig.indentLevel) stringValue]]];
                    isNewParagraph = NO;
                }
                [htmlContent appendString:[self htmlWithContent:content font:font underline:underline color:color]];
                isFirst = NO;
            }];
            if (effectiveRange.location + effectiveRange.length >= attributedString.length && ![htmlContent hasSuffix:@"</p>"]) {
               // 最后补上</p>
                [htmlContent appendString:@"</p>"];
            }
        }
        effectiveRange = NSMakeRange(effectiveRange.location+effectiveRange.length, 0);
    }
    return [htmlContent copy];
}

+ (NSString *)htmlWithContent:(NSString *)content font:(UIFont *)font underline:(BOOL)underline color:(NSString *)color {
    if (content.length == 0) {
        return @"";
    }
    if (font.bold) {
        content = [NSString stringWithFormat:@"<b>%@</b>", content];
    }
    if (font.italic) {
        content = [NSString stringWithFormat:@"<i>%@</i>", content];
    }
    if (underline) {
        content = [NSString stringWithFormat:@"<u>%@</u>", content];
    }
    return [NSString stringWithFormat:@"<font style=\"font-size:%f;color:%@\">%@</font>", font.fontSize, color, content];
}

+ (NSString *)hexStringWithColor:(UIColor *)color {
    NSString *colorString = [[CIColor colorWithCGColor:color.CGColor] stringRepresentation];
    NSArray *parts = [colorString componentsSeparatedByString:@" "];
    
    NSMutableString *hexString = [NSMutableString stringWithString:@"#"];
    for (int i = 0; i < 3; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", (int)([parts[i] floatValue] * 255)]];
    }
    return [hexString copy];
}

@end
