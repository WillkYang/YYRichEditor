//
//  YYStyleSettingsController.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYStyleSettingsController.h"
#import "YYParagraphConfig.h"
#import "YYStyleSettings.h"
#import "YYTextStyle.h"
#import "YYEditorAlignTableViewCell.h"
#import "YYEditorStyleFormatTableViewCell.h"
#import "YYEditorFontSizeTableViewCell.h"
#import "YYEditorFontColorTableViewCell.h"

@interface YYStyleSettingsController () <YYStyleSettings, YYEditorAlignDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, assign) BOOL paragraphType;
@property (nonatomic, assign) BOOL shouldScrollToSelectedRow;
@property (nonatomic, strong) YYParagraphConfig *paragraphConfig;
@end

@implementation YYStyleSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.paragraphConfig = [[YYParagraphConfig alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    YYEditorAlignTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    YYEditorStyleFormatTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    YYEditorFontSizeTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    YYEditorFontColorTableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.delegate = self;
    cell1.delegate = self;
    cell2.delegate = self;
    cell3.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_needReload) {
        [self reload];
    }
}
- (void)reload {
    [self.tableView reloadData];
    _needReload = NO;
}

#pragma mark - setTextStyle
- (void)setTextStyle:(YYTextStyle *)textStyle {
    _textStyle = textStyle;
    _needReload = YES;
}

#pragma mark - setParagraph
- (void)setParagraphConfig:(YYParagraphConfig *)paragraphConfig {
    _paragraphType = paragraphConfig.type;
    _needReload = YES;
}

#pragma mark - YYStyleSettings
- (void)yy_didChangedStyleSettings:(NSDictionary *)settings {
    __block BOOL needReload = NO;
    [settings enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:YYStyleSettingsBoldName]) {
            self.textStyle.bold = [(NSNumber *)obj boolValue];
        } else if ([key isEqualToString:YYStyleSettingsItalicName]) {
            self.textStyle.italic = [(NSNumber *)obj boolValue];
        } else if ([key isEqualToString:YYStyleSettingsUnderlineName]) {
            self.textStyle.underline = [(NSNumber *)obj boolValue];
        } else if ([key isEqualToString:YYStyleSettingsFontSizeName]) {
            self.textStyle.fontSize = [(NSNumber *)obj integerValue];
        } else if ([key isEqualToString:YYStyleSettingsTextColorName]) {
            self.textStyle.textColor = obj;
        } else if ([key isEqualToString:YYStyleSettingsFormatName]) {
            UIColor *textColor = self.textStyle.textColor;
            self.textStyle = [YYTextStyle textStyleWithType:[obj integerValue]];
            self.textStyle.textColor = textColor;
            needReload = YES;
        }
    }];
    if (needReload) {
        [self.tableView reloadData];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedTextStyle:)]) {
        [self.delegate yy_didChangedTextStyle:self.textStyle];
    }
}

#pragma mark - YYEditorAlignDelegate
- (void)yy_editorAlignChangeType:(NSTextAlignment)type {
    self.paragraphConfig.alignment = type;
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedTextStyle:)]) {
        [self.delegate yy_didChangedParagraphAlign:type];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"YYStyleSettingsTableViewCell%ld",indexPath.row + 1] forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 111;
    } else {
        return 54;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [(YYEditorAlignTableViewCell *)cell updateWithAlignment:self.paragraphConfig.alignment];
        }
            break;
        case 1:
        {
            [(YYEditorStyleFormatTableViewCell *)cell updateWithTextStyle:self.textStyle];
        }
            break;
        case 2:
        {
            [(YYEditorFontSizeTableViewCell *)cell updateWithTextStyle:self.textStyle];
        }
            break;
        case 3:
        {
            [(YYEditorFontColorTableViewCell *)cell updateWithTextStyle:self.textStyle];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <UITableViewDelegate>

@end
