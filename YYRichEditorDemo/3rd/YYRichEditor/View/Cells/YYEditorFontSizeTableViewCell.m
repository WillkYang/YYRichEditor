//
//  YYEditorFontSizeTableViewCell.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYEditorFontSizeTableViewCell.h"
#import "YYStyleSettings.h"
#import "YYTextStyle.h"

@interface YYEditorFontSizeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;

@end

@implementation YYEditorFontSizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.currentFontSize = 17.f;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%ld",self.currentFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)decreaseFontSize:(id)sender {
    [self updateFontSizeWithStep:-1];
}

- (IBAction)creaseFontSize:(id)sender {
    [self updateFontSizeWithStep:1];
}

- (void)updateFontSizeWithStep:(NSInteger)step {
    [self updateUIWithFontSize:self.currentFontSize + step];
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsFontSizeName:@(self.currentFontSize)}];
    }
}

- (void)updateWithTextStyle:(YYTextStyle *)textStyle {
    [self updateUIWithFontSize:textStyle.fontSize];
}

- (void)updateUIWithFontSize:(NSInteger)fontSize {
    self.currentFontSize = fontSize;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%ld",fontSize];
}
@end
