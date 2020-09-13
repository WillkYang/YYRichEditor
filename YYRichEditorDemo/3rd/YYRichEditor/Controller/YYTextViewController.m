//
//  YYTextViewController.m
//  YYLib
//
//  Created by WillkYang on 2017/7/18.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextViewController.h"
#import "YYTopTabBarView.h"
#import "NSTextAttachment+YYText.h"
#import "YYTextParser.h"
#import "YYTextStyle.h"
#import "YYParagraphConfig.h"
#import <Masonry/Masonry.h>
#import "YYStyleSettingsController.h"
#import "YYImageSettingsController.h"
#import "UIFont+YYText.h"

#import <YYModel/YYModel.h>
#import "YYTextViewController+StyleSetting.h"
#import "UIColor+Extension.h"

@interface YYTextViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) YYTopTabBarView *contentInputAccessoryView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat keyboardSpacingHeight;
@property (nonatomic, strong) YYStyleSettingsController *styleSettingsViewController;
@property (nonatomic, strong) YYImageSettingsController *imageSettingsViewController;

@end

@implementation YYTextViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
    [self setCurrentParagraphConfig:[[YYParagraphConfig alloc] init]];
    [self setCurrentTextStyle:[YYTextStyle textStyleWithType:YYTextStyleFormatNormal]];
    [self updateParagraphTypingAttributes];
    [self updateTextStyleTypingAttributes];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTextView];
    CGRect rect = self.view.bounds;
    rect.size.height = 44.f;
    self.contentInputAccessoryView.frame = rect;
}

- (void)layoutTextView {
//    CGRect rect = [UIScreen mainScreen].bounds;
    CGRect rect = self.view.bounds;
    rect.origin.y = [self.topLayoutGuide length];
    rect.size.height -= rect.origin.y;
    self.textView.frame = rect;
    UIEdgeInsets insets = self.textView.contentInset;
    insets.bottom = self.keyboardSpacingHeight;
    self.textView.contentInset = insets;
}

#pragma mark - <KeyboardDelegate>
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.keyboardSpacingHeight != keyboardSize.height) {
        self.keyboardSpacingHeight = keyboardSize.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutTextView];
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardSpacingHeight != 0) {
        self.keyboardSpacingHeight = 0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutTextView];
        } completion:nil];
    }
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.textView.inputAccessoryView = self.contentInputAccessoryView;
    [self.imageSettingsViewController reload];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.textView.inputAccessoryView = nil;
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (_lastSelectedRange.location != textView.selectedRange.location) {
        if (_keepCurrentTextStyle) {
            // 如果当前行内容为空，则使用上一行的typeingattributes，所以在删除内容时，保持typingattributes不变
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
        } else {
            self.currentTextStyle = [self textStyleForSelection];
            self.currentParagraphConfig = [self paragraphForSelection];
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            [self reloadSettingsView];
        }
    }
    if (self.dontUpdateLastSelectedRange) {
        self.dontUpdateLastSelectedRange = NO;
        return;
    }
    _lastSelectedRange = textView.selectedRange;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location == 0 && range.length == 0 && text.length == 0) {
        // 光标在第一个位置，按下删除键，则删除段落设置
        self.currentParagraphConfig.indentLevel = 0.f;
        [self updateParagraphTypingAttributes];
    }
    _lastSelectedRange = NSMakeRange(range.location + text.length, 0);
    if (text.length == 0 && range.length > 0) {
        _keepCurrentTextStyle = YES;
    }
    return YES;
}

- (void)exportContent {
    if (!self.textView.attributedText || self.textView.attributedText.length == 0) {
        return;
    }
    NSArray *array = [YYTextParser yy_textItemsFromAttributedString:self.textView.attributedText];
    NSLog(@"text:%@", [array yy_modelToJSONString]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_editorDoneWithContentArray:originString:)]) {
        [self.delegate yy_editorDoneWithContentArray:array originString:self.textView.text];
    }
    return;
}

#pragma mark - events
- (void)changeInputView:(NSInteger)index {
    CGRect rect = self.view.bounds;
    rect.size.height = self.keyboardSpacingHeight - CGRectGetHeight(self.contentInputAccessoryView.frame);
    switch (index) {
        case 0:
        {
            self.textView.inputView = nil;
        }
            break;
        case 1:
        {
            UIView *inputView = [[UIView alloc] initWithFrame:rect];
            self.styleSettingsViewController.view.frame = rect;
            [inputView addSubview:self.styleSettingsViewController.view];
            self.textView.inputView = inputView;
            break;
        }
        case 2:
        {
            UIView *inputView = [[UIView alloc] initWithFrame:rect];
            self.imageSettingsViewController.view.frame = rect;
            [inputView addSubview:self.imageSettingsViewController.view];
            self.textView.inputView = inputView;
        }
            break;
        default:
            self.textView.inputView = nil;
            break;
    }
    [self.textView reloadInputViews];
}

- (void)reloadSettingsView {
    self.styleSettingsViewController.textStyle = self.currentTextStyle;
    [self.styleSettingsViewController setParagraphConfig:self.currentParagraphConfig];
    [self.styleSettingsViewController reload];
}


#pragma mark updateTextStyle method

- (YYTextStyle *)textStyleForSelection {
    YYTextStyle *textStyle = [[YYTextStyle alloc] init];
    UIFont *font = self.textView.typingAttributes[NSFontAttributeName];
    textStyle.bold = font.bold;
    textStyle.italic = font.italic;
    textStyle.fontSize = font.fontSize;
    textStyle.textColor = self.textView.typingAttributes[NSForegroundColorAttributeName] ? : textStyle.textColor;
    if (self.textView.typingAttributes[NSUnderlineStyleAttributeName]) {
        textStyle.underline = [self.textView.typingAttributes[NSUnderlineStyleAttributeName] integerValue] == NSUnderlineStyleSingle;
    }
    return textStyle;
}

- (YYParagraphConfig *)paragraphForSelection {
    NSParagraphStyle *paragraphStyle = self.textView.typingAttributes[NSParagraphStyleAttributeName];
    YYParagraphType type = [self.textView.typingAttributes[YYParagraphTypeName] integerValue];
    YYParagraphConfig *config = [[YYParagraphConfig alloc] initWithParagraphStyle:paragraphStyle type:type];
    config.alignment = paragraphStyle.alignment;
    return config;
}

#pragma mark private method

- (UIStoryboard *)yy_storyboard {
    static dispatch_once_t onceToken;
    static UIStoryboard *storyboard = nil;
    dispatch_once(&onceToken, ^{
        storyboard = [UIStoryboard storyboardWithName:@"YYEditor" bundle:nil];
    });
    return storyboard;
}

#pragma mark - lazyload

- (YYTopTabBarView *)contentInputAccessoryView {
    if (!_contentInputAccessoryView) {
        NSArray *items = @[
                           @"Edit_Keyboard",
                           @"Edit_Font",
                           @"Edit_Photo"
                           ];
        _contentInputAccessoryView = [[YYTopTabBarView alloc] initWithItems:items distributionStyle:YYTopBarDistributionStyleOutScreenAlignmentLeft contentType:YYTopBarContentTypeImage indicatorType:YYTopBarIndicatorTypeMaxWidth handler:^(YYTopTabBarView *topBarView, NSInteger index) {
            [self changeInputView:index];
        }];
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5f);
        topBorder.backgroundColor = [UIColor colorWithHex:0xEFEFF4].CGColor;
        
        [_contentInputAccessoryView.layer addSublayer:topBorder];
        _contentInputAccessoryView.replayClickAction = YES;
        _contentInputAccessoryView.backgroundColor = [UIColor whiteColor];
        _contentInputAccessoryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        UIButton *doneButton = [[UIButton alloc] init];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorWithRed:0 green:204/255.f blue:187/255.f alpha:1.f] forState:UIControlStateNormal];
        [_contentInputAccessoryView addSubview:doneButton];
        
        [doneButton addTarget:self action:@selector(exportContent) forControlEvents:UIControlEventTouchUpInside];
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(_contentInputAccessoryView);
            make.width.equalTo(@60);
        }];
    }
    return _contentInputAccessoryView;
}

- (YYStyleSettingsController *)styleSettingsViewController {
    if (!_styleSettingsViewController) {
        _styleSettingsViewController = [[self yy_storyboard] instantiateViewControllerWithIdentifier:@"YYStyleSettingController"];
        _styleSettingsViewController.delegate = self;
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5f);
        topBorder.backgroundColor = [UIColor colorWithHex:0xEFEFF4].CGColor;
        
        [_styleSettingsViewController.view.layer addSublayer:topBorder];
        _styleSettingsViewController.textStyle = self.currentTextStyle;
        [_styleSettingsViewController setParagraphConfig:self.currentParagraphConfig];
    }
    return _styleSettingsViewController;
}

- (YYImageSettingsController *)imageSettingsViewController {
    if (!_imageSettingsViewController) {
        _imageSettingsViewController = [[self yy_storyboard] instantiateViewControllerWithIdentifier:@"YYImageSettingsController"];
        _imageSettingsViewController.delegate = self;
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5f);
        topBorder.backgroundColor = [UIColor colorWithHex:0xEFEFF4].CGColor;
        [_imageSettingsViewController.view.layer addSublayer:topBorder];
    }
    return _imageSettingsViewController;
}



- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.textColor = [UIColor colorWithRed:68/255.f green:68/255.f blue:68/255.f alpha:1.f];
        _textView.tintColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:17.f];
    }
    return _textView;
}

@end
