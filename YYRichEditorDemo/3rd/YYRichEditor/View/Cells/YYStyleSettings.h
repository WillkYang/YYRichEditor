//
//  YYStyleSettings.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#ifndef YYStyleSettings_h
#define YYStyleSettings_h

static NSString * const YYStyleSettingsBoldName = @"bold";
static NSString * const YYStyleSettingsItalicName = @"italic";
static NSString * const YYStyleSettingsUnderlineName = @"underline";
static NSString * const YYStyleSettingsFontSizeName = @"fontSize";
static NSString * const YYStyleSettingsTextColorName = @"textColor";
static NSString * const YYStyleSettingsFormatName = @"format";
static NSString * const YYStyleSettingsAlignName = @"align";
@protocol YYStyleSettings <NSObject>
- (void)yy_didChangedStyleSettings:(NSDictionary *)settings;
@end


#endif /* YYStyleSettings_h */
