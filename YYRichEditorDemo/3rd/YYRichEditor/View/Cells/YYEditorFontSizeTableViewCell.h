//
//  YYEditorFontSizeTableViewCell.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYStyleSettings;
@class YYTextStyle;

@interface YYEditorFontSizeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YYStyleSettings> delegate;
@property (nonatomic, assign) NSInteger currentFontSize;

- (void)updateWithTextStyle:(YYTextStyle *)textStyle;
@end
