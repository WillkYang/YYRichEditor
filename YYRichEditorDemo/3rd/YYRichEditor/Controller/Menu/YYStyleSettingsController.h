//
//  YYStyleSettingsController.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTextStyle;
@class YYParagraphConfig;

@protocol YYStyleSettingsControllerDelegate <NSObject>

- (void)yy_didChangedTextStyle:(YYTextStyle *)textStyle;
- (void)yy_didChangedParagraphIndentLevel:(NSInteger)level;
- (void)yy_didChangedParagraphType:(NSInteger)type;
- (void)yy_didChangedParagraphAlign:(NSTextAlignment)alignment;
@end

@interface YYStyleSettingsController : UITableViewController

@property (nonatomic, weak) id<YYStyleSettingsControllerDelegate> delegate;
@property (nonatomic, strong) YYTextStyle *textStyle;

- (void)reload;
- (void)setParagraphConfig:(YYParagraphConfig *)paragraphConfig;

@end
