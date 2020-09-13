//
//  YYEditorFontColorTableViewCell.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYStyleSettings;
@class YYTextStyle;

@interface YYEditorFontColorTableViewCell : UITableViewCell
@property (nonatomic, weak) id<YYStyleSettings> delegate;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, copy) NSArray *colors;

- (void)updateWithTextStyle:(YYTextStyle *)textStyle;
@end
