//
//  YYTextViewController.h
//  YYLib
//
//  Created by WillkYang on 2017/7/18.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTextItem;
@class YYTextStyle;
@class YYParagraphConfig;

@protocol YYRichEditorDelegate <NSObject>
- (void)yy_editorDoneWithContentArray:(NSArray <YYTextItem *> *)contentArray originString:(NSString *)string;
- (NSString *)yy_saveImage:(UIImage *)image;
@end

@interface YYTextViewController : UIViewController
@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, weak) id<YYRichEditorDelegate> delegate;
@property (nonatomic, assign) NSRange lastSelectedRange;
@property (nonatomic, assign) BOOL dontUpdateLastSelectedRange;
@property (nonatomic, strong) YYTextStyle *currentTextStyle;
@property (nonatomic, strong) YYParagraphConfig *currentParagraphConfig;
@property (nonatomic, assign) BOOL keepCurrentTextStyle;
@end
