//
//  YYTextParser.h
//  YYLib
//
//  Created by WillkYang on 2017/7/19.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTextItem;

@interface YYTextParser : NSObject

+ (NSArray <YYTextItem *> *)yy_textItemsFromAttributedString:(NSAttributedString *)attributedString;

+ (NSAttributedString *)yy_attributedStringFromTextItems:(NSArray <YYTextItem *> *)textItems width:(CGFloat)width;

@end
