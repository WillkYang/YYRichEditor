//
//  UIColor+Extension.h
//  YYRichEditorDemo
//
//  Created by WillkYang on 2017/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)
+ (UIColor *)colorWithHex:(UInt32)hex;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
