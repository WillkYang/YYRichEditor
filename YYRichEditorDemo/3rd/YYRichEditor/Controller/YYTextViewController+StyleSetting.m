//
//  YYTextViewController+StyleSetting.m
//  YYNote
//
//  Created by WillkYang on 2017/8/12.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextViewController+StyleSetting.h"
#import "YYParagraphConfig.h"
#import "YYTextStyle.h"
#import "NSTextAttachment+YYText.h"

@implementation YYTextViewController (StyleSetting)

#pragma mark - <YYStyleSettingsControllerDelegate>
- (void)yy_didChangedTextStyle:(YYTextStyle *)textStyle {
    self.currentTextStyle = textStyle;
    [self updateTextStyleTypingAttributes];
    [self updateTextStyleForSelection];
}

- (void)yy_didChangedParagraphIndentLevel:(NSInteger)level {
    
}

- (void)yy_didChangedParagraphType:(NSInteger)type {
    
    
}

- (void)yy_didChangedParagraphAlign:(NSTextAlignment)alignment {
    self.currentParagraphConfig.alignment = alignment;
    [self updateParagraphTypingAttributes];
    [self updateParagraphForSelectionWithKey:nil];
}

- (void)updateTextStyleTypingAttributes {
    NSMutableDictionary *typeAttributes = [self.textView.typingAttributes mutableCopy];
    typeAttributes[NSFontAttributeName] = self.currentTextStyle.font;
    typeAttributes[NSForegroundColorAttributeName] = self.currentTextStyle.textColor;
    typeAttributes[NSUnderlineStyleAttributeName] = @(self.currentTextStyle.underline ? NSUnderlineStyleSingle : NSUnderlineStyleNone);
    self.textView.typingAttributes = typeAttributes;
}

- (void)updateTextStyleForSelection {
    //    if (self.textView.selectedRange.length > 0) {
    //        [self.textView.textStorage addAttributes:self.textView.typingAttributes range:self.textView.selectedRange];
    //    }
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangeOfParagraphForCurrentSelection:self.textView];
    if (!ranges) {
        if (self.currentParagraphConfig.type == 0) {
            NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
            typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
            self.textView.typingAttributes = typingAttributes;
            return;
        }
        ranges = @[[NSValue valueWithRange:NSMakeRange(0, 0 )]];
    }
    NSInteger offset = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSValue *rangeValue in ranges) {
        NSRange range = NSMakeRange(rangeValue.rangeValue.location + offset, rangeValue.rangeValue.length);
        [attributedText addAttributes:self.textView.typingAttributes range:range];
    }
    if (offset > 0) {
        self.keepCurrentTextStyle = YES;
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length + offset - 1);
    }
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.selectedRange = selectedRange;
}


- (void)updateParagraphTypingAttributes {
    NSMutableDictionary *typeAttributes = [self.textView.typingAttributes mutableCopy];
    typeAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
    self.textView.typingAttributes = typeAttributes;
}

- (void)updateParagraphForSelectionWithKey:(NSString *)key {
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangeOfParagraphForCurrentSelection:self.textView];
    if (!ranges) {
        if (self.currentParagraphConfig.type == 0) {
            NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
            typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
            self.textView.typingAttributes = typingAttributes;
            return;
        }
        ranges = @[[NSValue valueWithRange:NSMakeRange(0, 0 )]];
    }
    NSInteger offset = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSValue *rangeValue in ranges) {
        NSRange range = NSMakeRange(rangeValue.rangeValue.location + offset, rangeValue.rangeValue.length);
        YYParagraphType type;
        if ([key isEqualToString:YYParagraphTypeName]) {
            type = self.currentParagraphConfig.type;
            if (self.currentParagraphConfig.type == YYParagraphTypeNone) {
                [attributedText deleteCharactersInRange:NSMakeRange(range.location, 1)];
                offset -= 1;
            } else {
                NSTextAttachment *textAttachment = [NSTextAttachment checkBoxAttachment];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, 1)];
                [attributedText insertAttributedString:attributedString atIndex:range.location];
                offset +=1;
            }
        } else {
            [attributedText addAttribute:NSParagraphStyleAttributeName value:self.currentParagraphConfig.paragraphStyle range:range];
        }
    }
    if (offset > 0) {
        self.keepCurrentTextStyle = YES;
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length + offset - 1);
    }
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.selectedRange = selectedRange;
}

// 获取所有选中的段落，用过\n来分割
- (NSArray *)rangeOfParagraphForCurrentSelection:(UITextView *)textView {
    NSRange selection = textView.selectedRange;
    NSInteger location,length,start = 0,end = selection.location;
    
    // 获取选中位置最前段落
    NSRange range = [textView.text rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(start, end-start)];
    location = (range.location != NSNotFound) ? range.location + 1 : 0; // 重点
    
    // 获取选中位置最末段落
    start = selection.location + selection.length;
    end = textView.text.length;
    range = [textView.text rangeOfString:@"\n" options:0 range:NSMakeRange(start, end - start)];
    length = (range.location != NSNotFound) ? (range.location + 1 - location) : textView.text.length - location; // 重点
    
    range = NSMakeRange(location, length);
    NSString *textInRange = [textView.text substringWithRange:range];
    NSArray *components = [textInRange componentsSeparatedByString:@"\n"];
    
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        if (i != components.count - 1) {
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length + 1)]];
            location += component.length + 1;
        } else {
            // 最后一个
            if (component.length == 0) {
                break;
            } else {
                [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length)]];
            }
        }
    }
    if (ranges.count == 0) {
        return nil;
    }
    return ranges;
}

@end
