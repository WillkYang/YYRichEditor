//
//  YYTextItem.m
//  YYLib
//
//  Created by WillkYang on 2017/8/9.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextItem.h"
#import "UIFont+YYText.h"
#import "YYConfig.h"
#import "UIColor+Extension.h"

@interface YYTextItem()
@property (nonatomic, copy) NSMutableDictionary *imgDict;
@end

@implementation YYTextItem

+ (instancetype)yy_textItemWithString:(NSString *)string sttributes:(NSDictionary *)attributes {
    YYTextItem *item = [YYTextItem new];
    
    UIFont *font = attributes[NSFontAttributeName];
//    UIColor *fontColor = attributes[@"NSColor"];
    UIColor *textColor = attributes[NSForegroundColorAttributeName];
    NSParagraphStyle *style = attributes[NSParagraphStyleAttributeName];
    if (style) {
        item.A = style.alignment;
    }
    item.U = [attributes[NSUnderlineStyleAttributeName] boolValue];
    item.C = [self hexStringWithColor:textColor];
    item.S = font.fontSize;
    item.B = font.bold;
    item.P = NO;
    item.T = string;
//    item.A = attributes[NSTextAlignment];
    return item;
}

+ (instancetype)yy_textItemWithImageUrl:(NSString *)imageUrl width:(CGFloat)width height:(CGFloat)height {
    YYTextItem *item = [YYTextItem new];
    item.P = YES;
    item.W = width;
    item.H = height;
    item.F = imageUrl;
    return item;
}

+ (NSString *)hexStringWithColor:(UIColor *)color {
    NSString *colorString = [[CIColor colorWithCGColor:color.CGColor] stringRepresentation];
    NSArray *parts = [colorString componentsSeparatedByString:@" "];
    
    NSMutableString *hexString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < 3; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", (int)([parts[i] floatValue] * 255)]];
    }
    return [hexString copy];
}

- (NSString *)imageUrlDisp {
    if (_F) {
        if ([_F containsString:@"http"]) {
            return _F;
        } else {
            // 本地图片
//            return [[YYGlobal imgsDirPath] stringByAppendingPathComponent:_F];
            return [YYConfig.imageHostURL stringByAppendingPathComponent:_F];
        }
    }
    return @"";
}

- (void)setImageWithImageView:(UIImageView *)imageView {
    if (!_F) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block UIImage *image = [self getImageSync];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
           });
        }
    });
}

- (UIImage *)getImageSync {
    if (!_F) {
        return nil;
    }
    if (self.imgDict[_F]) {
        return self.imgDict[_F];
    }
    NSLog(@"没找到图片内存缓存");
    
    NSString *imgPath = [YYConfig.imageLocalPath stringByAppendingString:_F];
    UIImage *image;
    // 尝试直接读取本地
    if ([_F containsString:@"http"] || ![[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
        NSLog(@"下载图片");
        // 网络图片下载
        NSString *url;
        if (![_F containsString:@"http"]) {
            //TODO 此处修改为需要图片的网络下载地址
            url = [NSString stringWithFormat:@"%@/%@", YYConfig.imageHostURL, _F];
        }
        image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
        
        
    } else {
        NSLog(@"找到图片本地缓存");
        image = [UIImage imageWithContentsOfFile:imgPath];
    }
    if (image) {
        self.imgDict[_F] = image;
    }
    return image;
}

- (NSAttributedString *)yy_toString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.T];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    style.alignment = self.A;
    [string addAttribute:NSFontAttributeName value:[UIFont yy_fontWithFontSize:self.S bold:self.B italic:self.X] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:self.C] range:NSMakeRange(0, string.length)];
    return string;
}

- (NSMutableDictionary *)imgDict {
    if (!_imgDict) {
        _imgDict = [NSMutableDictionary dictionary];
    }
    return _imgDict;
}


+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"imgDict"];
}
@end
