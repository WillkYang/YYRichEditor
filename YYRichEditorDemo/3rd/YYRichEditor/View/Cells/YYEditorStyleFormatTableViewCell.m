//
//  YYEditorStyleFormatTableViewCell.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYEditorStyleFormatTableViewCell.h"
#import "YYStyleSettings.h"
#import "YYTextStyle.h"

@interface YYEditorStyleFormatTableViewCell()
@property (nonatomic, weak) IBOutlet UIButton *regularButton;
@property (nonatomic, weak) IBOutlet UIButton *boldButton;
@property (nonatomic, weak) IBOutlet UIButton *italicButton;
@property (nonatomic, weak) IBOutlet UIButton *underlineButton;
@property (nonatomic, weak) UIButton *lastSelectedButton;
@end

@implementation YYEditorStyleFormatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.regularButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.regularButton setTitleColor:[UIColor colorWithRed:0 green:204/255.f blue:187.f/255.f alpha:1.f] forState:UIControlStateSelected];
    [self.boldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.boldButton setTitleColor:[UIColor colorWithRed:0 green:204/255.f blue:187.f/255.f alpha:1.f] forState:UIControlStateSelected];
    [self.italicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.italicButton setTitleColor:[UIColor colorWithRed:0 green:204/255.f blue:187.f/255.f alpha:1.f] forState:UIControlStateSelected];
    [self.underlineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.underlineButton setTitleColor:[UIColor colorWithRed:0 green:204/255.f blue:187.f/255.f alpha:1.f] forState:UIControlStateSelected];
    [self buttonClick:self.regularButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//- (IBAction)regularButtonClick:(id)sender {
//    if (self.regularButton.isSelected) {
//        return;
//    }
//    [self.regularButton setSelected:!self.regularButton.isSelected];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
//        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsBoldName:@(!self.regularButton.isSelected)}];
//    }
//}
//
//- (IBAction)boldButtonClick:(id)sender {
//    if (self.boldButton.isSelected) {
//        return;
//    }
//    [self.boldButton setSelected:!self.boldButton.isSelected];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
//        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsBoldName:@(self.boldButton.isSelected)}];
//    }
//}
//
//- (IBAction)italicButtonClick:(id)sender {
//    if (self.italicButton.isSelected) {
//        return;
//    }
//    [self.italicButton setSelected:!self.italicButton.isSelected];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
//        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsItalicName:@(self.italicButton.isSelected)}];
//    }
//}
//
//- (IBAction)underlineButtonClick:(id)sender {
//    if (self.underlineButton.isSelected) {
//        return;
//    }
//    [self.underlineButton setSelected:!self.underlineButton.isSelected];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
//        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsUnderlineName:@(self.underlineButton.isSelected)}];
//    }
//}

- (IBAction)buttonClick:(id)button {
    if (button == self.lastSelectedButton) {
        return;
    }
    [self.lastSelectedButton setSelected:NO];
    [button setSelected:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
        NSDictionary *dict = nil;
        if (self.regularButton == button) dict = @{YYStyleSettingsBoldName : @(NO),YYStyleSettingsItalicName : @(NO),YYStyleSettingsUnderlineName : @(NO)};
        if (self.boldButton == button) dict = @{YYStyleSettingsBoldName : @(YES),YYStyleSettingsItalicName : @(NO),YYStyleSettingsUnderlineName : @(NO)};
        if (self.italicButton == button) dict = @{YYStyleSettingsItalicName : @(YES),YYStyleSettingsBoldName : @(NO),YYStyleSettingsUnderlineName : @(NO)};
        if (self.underlineButton == button) dict = @{YYStyleSettingsUnderlineName : @(YES),YYStyleSettingsBoldName : @(NO),YYStyleSettingsItalicName : @(NO)};
        [self.delegate yy_didChangedStyleSettings:dict];
    }
    self.lastSelectedButton = button;
}

- (void)updateWithTextStyle:(YYTextStyle *)textStyle {
    [self.regularButton setSelected:NO];
    [self.boldButton setSelected:NO];
    [self.italicButton setSelected:NO];
    [self.underlineButton setSelected:NO];
    
    if (textStyle.bold) {
        [self.boldButton setSelected:YES];
        return;
    }
    if (textStyle.italic) {
        [self.italicButton setSelected:YES];
        return;
    }
    if (textStyle.underline) {
        [self.underlineButton setSelected:YES];
        return;
    }
    if (!textStyle.bold) {
        [self.regularButton setSelected:YES];
        return;
    }
}
@end
